/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWContentListController = (function () {
        function SWContentListController($scope, $log, $timeout, $slatwall, paginationService, observerService, collectionConfigService) {
            var _this = this;
            this.$scope = $scope;
            this.$log = $log;
            this.$timeout = $timeout;
            this.$slatwall = $slatwall;
            this.paginationService = paginationService;
            this.observerService = observerService;
            this.collectionConfigService = collectionConfigService;
            this.openRoot = true;
            this.$log.debug('slatwallcontentList init');
            var pageShow = 50;
            if (this.pageShow !== 'Auto') {
                pageShow = this.pageShow;
            }
            this.pageShowOptions = [
                { display: 10, value: 10 },
                { display: 20, value: 20 },
                { display: 50, value: 50 },
                { display: 250, value: 250 }
            ];
            this.loadingCollection = false;
            this.selectedSite;
            this.orderBy;
            var orderByConfig;
            this.getCollection = function (isSearching) {
                _this.collectionConfig = collectionConfigService.newCollectionConfig('Content');
                var columnsConfig = [
                    //{"propertyIdentifier":"_content_childContents","title":"","isVisible":true,"isDeletable":true,"isSearchable":true,"isExportable":true,"ormtype":"string","aggregate":{"aggregateFunction":"COUNT","aggregateAlias":"childContentsCount"}},
                    {
                        propertyIdentifier: '_content.contentID',
                        isVisible: false,
                        ormtype: 'id',
                        isSearchable: true
                    },
                    {
                        propertyIdentifier: '_content.urlTitlePath',
                        isVisible: false,
                        isSearchable: true
                    },
                    //need to get template via settings
                    {
                        propertyIdentifier: '_content.allowPurchaseFlag',
                        isVisible: true,
                        ormtype: 'boolean',
                        isSearchable: false
                    },
                    {
                        propertyIdentifier: '_content.productListingPageFlag',
                        isVisible: true,
                        ormtype: 'boolean',
                        isSearchable: false
                    },
                    {
                        propertyIdentifier: '_content.activeFlag',
                        isVisible: true,
                        ormtype: 'boolean',
                        isSearchable: false
                    }
                ];
                var options = {
                    currentPage: '1',
                    pageShow: '1',
                    keywords: _this.keywords
                };
                var column = {};
                if (!isSearching || _this.keywords === '') {
                    _this.isSearching = false;
                    var filterGroupsConfig = [
                        {
                            "filterGroup": [
                                {
                                    "propertyIdentifier": "parentContent",
                                    "comparisonOperator": "is",
                                    "value": 'null'
                                }
                            ]
                        }
                    ];
                    column = {
                        propertyIdentifier: '_content.title',
                        isVisible: true,
                        ormtype: 'string',
                        isSearchable: true,
                        tdclass: 'primary'
                    };
                    columnsConfig.unshift(column);
                }
                else {
                    _this.isSearching = true;
                    var filterGroupsConfig = [
                        {
                            "filterGroup": [
                                {
                                    "propertyIdentifier": "excludeFromSearch",
                                    "comparisonOperator": "!=",
                                    "value": true
                                }
                            ]
                        }
                    ];
                    column = {
                        propertyIdentifier: '_content.title',
                        isVisible: false,
                        ormtype: 'string',
                        isSearchable: true
                    };
                    columnsConfig.unshift(column);
                    var titlePathColumn = {
                        propertyIdentifier: '_content.titlePath',
                        isVisible: true,
                        ormtype: 'string',
                        isSearchable: false
                    };
                    columnsConfig.unshift(titlePathColumn);
                }
                //if we have a selected Site add the filter
                if (angular.isDefined(_this.selectedSite)) {
                    var selectedSiteFilter = {
                        logicalOperator: "AND",
                        propertyIdentifier: "site.siteID",
                        comparisonOperator: "=",
                        value: _this.selectedSite.siteID
                    };
                    filterGroupsConfig[0].filterGroup.push(selectedSiteFilter);
                }
                if (angular.isDefined(_this.orderBy)) {
                    var orderByConfig = [];
                    orderByConfig.push(_this.orderBy);
                    options.orderByConfig = angular.toJson(orderByConfig);
                }
                angular.forEach(columnsConfig, function (column) {
                    _this.collectionConfig.addColumn(column.propertyIdentifier, column.title, column);
                });
                _this.collectionConfig.addDisplayAggregate('childContents', 'COUNT', 'childContentsCount', { isVisible: false, isSearchable: false, title: 'test' });
                _this.collectionConfig.addDisplayProperty('site.siteID', undefined, {
                    isVisible: false,
                    ormtype: 'id',
                    isSearchable: false
                });
                _this.collectionConfig.addDisplayProperty('site.domainNames', undefined, {
                    isVisible: false,
                    isSearchable: true
                });
                angular.forEach(filterGroupsConfig[0].filterGroup, function (filter) {
                    _this.collectionConfig.addFilter(filter.propertyIdentifier, filter.value, filter.comparisonOperator, filter.logicalOperator);
                });
                _this.collectionListingPromise = _this.collectionConfig.getEntity();
                _this.collectionListingPromise.then(function (value) {
                    _this.collection = value;
                    _this.collection.collectionConfig = _this.collectionConfig;
                    _this.firstLoad = true;
                    _this.loadingCollection = false;
                });
                _this.collectionListingPromise;
            };
            //this.getCollection(false);
            this.keywords = "";
            this.loadingCollection = false;
            var searchPromise;
            this.searchCollection = function () {
                if (searchPromise) {
                    _this.$timeout.cancel(searchPromise);
                }
                searchPromise = $timeout(function () {
                    $log.debug('search with keywords');
                    $log.debug(_this.keywords);
                    $('.childNode').remove();
                    //Set current page here so that the pagination does not break when getting collection
                    _this.loadingCollection = true;
                    _this.getCollection(true);
                }, 500);
            };
            var siteChanged = function (selectedSiteOption) {
                _this.selectedSite = selectedSiteOption;
                _this.openRoot = true;
                _this.getCollection();
            };
            this.observerService.attach(siteChanged, 'optionsChanged', 'siteOptions');
            var sortChanged = function (orderBy) {
                _this.orderBy = orderBy;
                _this.getCollection();
            };
            this.observerService.attach(sortChanged, 'sortByColumn', 'siteSorting');
            var optionsLoaded = function () {
                _this.observerService.notify('selectFirstOption');
            };
            this.observerService.attach(optionsLoaded, 'optionsLoaded', 'siteOptionsLoaded');
        }
        SWContentListController.$inject = [
            '$scope',
            '$log',
            '$timeout',
            '$slatwall',
            'paginationService',
            'observerService',
            'collectionConfigService'
        ];
        return SWContentListController;
    })();
    slatwalladmin.SWContentListController = SWContentListController;
    var SWContentList = (function () {
        function SWContentList(partialsPath, observerService) {
            this.partialsPath = partialsPath;
            this.observerService = observerService;
            this.restrict = 'E';
            //public bindToController=true;
            this.controller = SWContentListController;
            this.controllerAs = "swContentList";
            this.link = function (scope, element, attrs, controller, transclude) {
                scope.$on('$destroy', function handler() {
                    observerService.detachByEvent('optionsChanged');
                    observerService.detachByEvent('sortByColumn');
                });
            };
            this.templateUrl = this.partialsPath + 'content/contentlist.html';
        }
        return SWContentList;
    })();
    slatwalladmin.SWContentList = SWContentList;
    angular.module('slatwalladmin').directive('swContentList', ['partialsPath', 'observerService', function (partialsPath, observerService) { return new SWContentList(partialsPath, observerService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swcontentlist.js.map
