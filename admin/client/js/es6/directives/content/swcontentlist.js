/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWContentListController {
        constructor($scope, $log, $timeout, $slatwall, paginationService, observerService, collectionConfigService) {
            this.$scope = $scope;
            this.$log = $log;
            this.$timeout = $timeout;
            this.$slatwall = $slatwall;
            this.paginationService = paginationService;
            this.observerService = observerService;
            this.collectionConfigService = collectionConfigService;
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
            this.getCollection = (isSearching) => {
                this.collectionConfig = collectionConfigService.newCollectionConfig('Content');
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
                    keywords: this.keywords
                };
                var column = {};
                if (!isSearching || this.keywords === '') {
                    this.isSearching = false;
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
                    this.isSearching = true;
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
                if (angular.isDefined(this.selectedSite)) {
                    var selectedSiteFilter = {
                        logicalOperator: "AND",
                        propertyIdentifier: "site.siteID",
                        comparisonOperator: "=",
                        value: this.selectedSite.siteID
                    };
                    filterGroupsConfig[0].filterGroup.push(selectedSiteFilter);
                }
                if (angular.isDefined(this.orderBy)) {
                    var orderByConfig = [];
                    orderByConfig.push(this.orderBy);
                    options.orderByConfig = angular.toJson(orderByConfig);
                }
                angular.forEach(columnsConfig, (column) => {
                    this.collectionConfig.addColumn(column.propertyIdentifier, column.title, column);
                });
                this.collectionConfig.addDisplayAggregate('childContents', 'COUNT', 'childContentsCount', { isVisible: false, isSearchable: false, title: 'test' });
                this.collectionConfig.addDisplayProperty('site.siteID', undefined, {
                    isVisible: false,
                    ormtype: 'id',
                    isSearchable: false
                });
                this.collectionConfig.addDisplayProperty('site.domainNames', undefined, {
                    isVisible: false,
                    isSearchable: true
                });
                angular.forEach(filterGroupsConfig[0].filterGroup, (filter) => {
                    this.collectionConfig.addFilter(filter.propertyIdentifier, filter.value, filter.comparisonOperator, filter.logicalOperator);
                });
                this.collectionListingPromise = this.collectionConfig.getEntity();
                this.collectionListingPromise.then((value) => {
                    angular.forEach(value.pageRecords, (node) => {
                        node.site_domainNames = node.site_domainNames.split(",")[0];
                    });
                    this.collection = value;
                    //this.collectionConfig = angular.fromJson(this.collection.collectionConfig);
                    //this.collectionConfig.columns = columnsConfig;
                    this.collection.collectionConfig = this.collectionConfig;
                    this.firstLoad = true;
                    this.loadingCollection = false;
                });
                this.collectionListingPromise;
            };
            //this.getCollection(false);
            this.keywords = "";
            this.loadingCollection = false;
            var searchPromise;
            this.searchCollection = () => {
                if (searchPromise) {
                    this.$timeout.cancel(searchPromise);
                }
                searchPromise = $timeout(() => {
                    $log.debug('search with keywords');
                    $log.debug(this.keywords);
                    $('.childNode').remove();
                    //Set current page here so that the pagination does not break when getting collection
                    this.loadingCollection = true;
                    this.getCollection(true);
                }, 500);
            };
            var siteChanged = (selectedSiteOption) => {
                this.selectedSite = selectedSiteOption;
                this.getCollection();
            };
            this.observerService.attach(siteChanged, 'optionsChanged', 'siteOptions');
            var sortChanged = (orderBy) => {
                this.orderBy = orderBy;
                this.getCollection();
            };
            this.observerService.attach(sortChanged, 'sortByColumn', 'siteSorting');
            var optionsLoaded = () => {
                this.observerService.notify('selectFirstOption');
            };
            this.observerService.attach(optionsLoaded, 'optionsLoaded', 'siteOptionsLoaded');
        }
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
    slatwalladmin.SWContentListController = SWContentListController;
    class SWContentList {
        constructor(partialsPath, observerService) {
            this.partialsPath = partialsPath;
            this.observerService = observerService;
            this.restrict = 'E';
            //public bindToController=true;
            this.controller = SWContentListController;
            this.controllerAs = "swContentList";
            this.link = (scope, element, attrs, controller, transclude) => {
                scope.$on('$destroy', function handler() {
                    observerService.detachByEvent('optionsChanged');
                    observerService.detachByEvent('sortByColumn');
                });
            };
            this.templateUrl = this.partialsPath + 'content/contentlist.html';
        }
    }
    slatwalladmin.SWContentList = SWContentList;
    angular.module('slatwalladmin').directive('swContentList', ['partialsPath', 'observerService', (partialsPath, observerService) => new SWContentList(partialsPath, observerService)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/content/swcontentlist.js.map