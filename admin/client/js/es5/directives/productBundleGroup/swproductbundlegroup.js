/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var CollectionFilterItem = (function () {
        function CollectionFilterItem(name, type, displayPropertyIdentifier, propertyIdentifier, displayValue, value, comparisonOperator, logicalOperator) {
            this.name = name;
            this.type = type;
            this.displayPropertyIdentifier = displayPropertyIdentifier;
            this.propertyIdentifier = propertyIdentifier;
            this.displayValue = displayValue;
            this.value = value;
            this.comparisonOperator = comparisonOperator;
            this.logicalOperator = logicalOperator;
        }
        return CollectionFilterItem;
    })();
    slatwalladmin.CollectionFilterItem = CollectionFilterItem;
    var SWProductBundleGroupController = (function () {
        function SWProductBundleGroupController($log, $timeout, collectionConfigService, productBundleService, metadataservice, utilityservice, $slatwall, partialsPath) {
            var _this = this;
            this.$log = $log;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.productBundleService = productBundleService;
            this.metadataservice = metadataservice;
            this.utilityservice = utilityservice;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.openCloseAndRefresh = function () {
                _this.showAdvanced = !_this.showAdvanced;
                if (_this.productBundleGroup.data.skuCollectionConfig.filterGroups[_this.index].filterGroup.length) {
                    _this.getCollection();
                }
            };
            this.deleteEntity = function (type) {
                if (angular.isNumber(type)) {
                    _this.removeProductBundleGroupFilter(type);
                }
                else {
                    _this.removeProductBundleGroup(_this.index);
                }
            };
            this.getCollection = function () {
                _this.collectionConfig.getEntity().then(function (response) {
                    _this.collection = response;
                });
            };
            this.increaseCurrentCount = function () {
                if (angular.isDefined(_this.totalPages) && _this.totalPages != _this.currentPage) {
                    _this.currentPage++;
                }
                else {
                    _this.currentPage = 1;
                }
            };
            this.resetCurrentCount = function () {
                _this.currentPage = 1;
            };
            this.getFiltersByTerm = function (keyword, filterTerm) {
                _this.loading = true;
                _this.showAll = true;
                var _loadingCount;
                if (_this.timeoutPromise) {
                    _this.$timeout.cancel(_this.timeoutPromise);
                }
                _this.timeoutPromise = _this.$timeout(function () {
                    if (filterTerm.value === 'All') {
                        _this.showAll = true;
                        _this.productBundleGroupFilters.value = [];
                        _loadingCount = _this.searchOptions.options.length - 1;
                        for (var i in _this.searchOptions.options) {
                            _this.$log.debug("INT");
                            _this.$log.debug(i);
                            if (i > 0) {
                                var option = _this.searchOptions.options[i];
                                (function (keyword, option) {
                                    var searchAllCollectionConfig = _this.collectionConfigService.newCollectionConfig(_this.searchOptions.options[i].value);
                                    searchAllCollectionConfig.setKeywords(keyword);
                                    searchAllCollectionConfig.setCurrentPage(_this.currentPage);
                                    searchAllCollectionConfig.setPageShow(_this.pageShow);
                                    //searchAllCollectionConfig.setAllRecords(true);
                                    searchAllCollectionConfig.getEntity().then(function (value) {
                                        _this.recordsCount = value.recordsCount;
                                        _this.pageRecordsStart = value.pageRecordsStart;
                                        _this.pageRecordsEnd = value.pageRecordsEnd;
                                        _this.totalPages = value.totalPages;
                                        var formattedProductBundleGroupFilters = _this.productBundleService.formatProductBundleGroupFilters(value.pageRecords, option);
                                        for (var j in formattedProductBundleGroupFilters) {
                                            if (_this.productBundleGroup.data.skuCollectionConfig.filterGroups[_this.index].filterGroup.indexOf(formattedProductBundleGroupFilters[j]) == -1) {
                                                _this.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
                                                _this.$log.debug(formattedProductBundleGroupFilters[j]);
                                            }
                                        }
                                        // Increment Down The Loading Count
                                        _loadingCount--;
                                        // If the loadingCount drops to 0, then we can update scope
                                        if (_loadingCount == 0) {
                                            //This sorts the array of objects by the objects' "type" property alphabetically
                                            _this.productBundleGroupFilters.value = _this.utilityservice.arraySorter(_this.productBundleGroupFilters.value, ["type", "name"]);
                                            _this.$log.debug(_this.productBundleGroupFilters.value);
                                        }
                                        _this.loading = false;
                                    });
                                })(keyword, option);
                            }
                        }
                    }
                    else {
                        _this.showAll = false;
                        _this.searchCollectionConfig = _this.collectionConfigService.newCollectionConfig(filterTerm.value);
                        _this.searchCollectionConfig.setKeywords(keyword);
                        _this.searchCollectionConfig.setCurrentPage(_this.currentPage);
                        _this.searchCollectionConfig.setPageShow(_this.pageShow);
                        _this.searchCollectionConfig.getEntity().then(function (value) {
                            _this.recordsCount = value.recordsCount;
                            _this.pageRecordsStart = value.pageRecordsStart;
                            _this.pageRecordsEnd = value.pageRecordsEnd;
                            _this.totalPages = value.totalPages;
                            _this.$log.debug('getFiltersByTerm');
                            _this.$log.debug(value);
                            _this.productBundleGroupFilters.value = _this.productBundleService.formatProductBundleGroupFilters(value.pageRecords, filterTerm) || [];
                            _this.loading = false;
                        });
                    }
                }, 500);
            };
            this.addFilterToProductBundle = function (filterItem, include, index) {
                var collectionFilterItem = new CollectionFilterItem(filterItem.name, filterItem.type, filterItem.type, filterItem.propertyIdentifier, filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID'], filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID']);
                if (include === false) {
                    collectionFilterItem.comparisonOperator = '!=';
                }
                else {
                    collectionFilterItem.comparisonOperator = '=';
                }
                if (_this.productBundleGroup.data.skuCollectionConfig.filterGroups[_this.index].filterGroup.length > 0) {
                    collectionFilterItem.logicalOperator = 'OR';
                }
                //Adds filter item to designated filtergroup
                _this.productBundleGroup.data.skuCollectionConfig.filterGroups[_this.index].filterGroup.push(collectionFilterItem);
                //Removes the filter item from the left hand search result
                _this.productBundleGroupFilters.value.splice(index, 1);
                _this.productBundleGroup.forms[_this.formName].skuCollectionConfig.$setDirty();
            };
            this.removeProductBundleGroupFilter = function (index) {
                //Pushes item back into array
                _this.productBundleGroupFilters.value.push(_this.productBundleGroup.data.skuCollectionConfig.filterGroups[_this.index].filterGroup[index]);
                //Sorts Array
                _this.productBundleGroupFilters.value = _this.utilityservice.arraySorter(_this.productBundleGroupFilters.value, ["type", "name"]);
                //Removes the filter item from the filtergroup
                _this.productBundleGroup.data.skuCollectionConfig.filterGroups[_this.index].filterGroup.splice(index, 1);
                _this.productBundleGroup.forms[_this.formName].skuCollectionConfig.$setDirty();
            };
            this.$id = 'productBundleGroup';
            this.maxRecords = 10;
            this.recordsCount = 0;
            this.pageRecordsStart = 0;
            this.pageRecordsEnd = 0;
            this.showAll = false;
            this.showAdvanced = false;
            this.currentPage = 1;
            this.pageShow = 10;
            /*this.skuCollectionConfig = {
                baseEntityName:"Sku",
                baseEntityAlias:"_sku",
                collectionConfig:this.productBundleGroup.data.skuCollectionConfig,
                collectionObject:'Sku'
            };*/
            this.searchOptions = {
                options: [
                    {
                        name: "All",
                        value: "All"
                    },
                    {
                        name: "Product Type",
                        value: "productType"
                    },
                    {
                        name: "Brand",
                        value: "brand"
                    },
                    {
                        name: "Products",
                        value: "product"
                    },
                    {
                        name: "Skus",
                        value: "sku"
                    }
                ],
                selected: {
                    name: "All",
                    value: "All"
                },
                setSelected: function (searchOption) {
                    _this.searchOptions.selected = searchOption;
                    _this.getFiltersByTerm(_this.productBundleGroupFilters.keyword, searchOption);
                }
            };
            this.navigation = {
                value: 'Basic',
                setValue: function (value) {
                    _this.value = value;
                }
            };
            this.filterTemplatePath = this.partialsPath + "productBundle/productbundlefilter.html";
            this.productBundleGroupFilters = {};
            this.productBundleGroupFilters.value = [];
            if (angular.isUndefined(this.productBundleGroup.productBundleGroupFilters)) {
                this.productBundleGroup.productBundleGroupFilters = [];
            }
            if (!angular.isDefined(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index])) {
                this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index] = {};
                this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup = [];
            }
            var options = {
                filterGroupsConfig: this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup,
                columnsConfig: this.productBundleGroup.data.skuCollectionConfig.columns,
            };
            this.collectionConfig = collectionConfigService.newCollectionConfig('Sku');
            this.collectionConfig.loadFilterGroups(options.filterGroupsConfig);
            this.collectionConfig.loadColumns(options.columnsConfig);
            this.collectionConfig.setAllRecords(true);
            this.getCollection();
        }
        SWProductBundleGroupController.$inject = ["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath"];
        return SWProductBundleGroupController;
    })();
    slatwalladmin.SWProductBundleGroupController = SWProductBundleGroupController;
    var SWProductBundleGroup = (function () {
        function SWProductBundleGroup($log, $timeout, collectionConfigService, productBundleService, metadataservice, utilityservice, $slatwall, partialsPath) {
            this.$log = $log;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.productBundleService = productBundleService;
            this.metadataservice = metadataservice;
            this.utilityservice = utilityservice;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.restrict = "EA";
            this.scope = {};
            this.bindToController = {
                productBundleGroup: "=",
                index: "=",
                addProductBundleGroup: "&",
                removeProductBundleGroup: "&",
                formName: "@"
            };
            this.controller = SWProductBundleGroupController;
            this.controllerAs = "swProductBundleGroup";
            this.link = function ($scope, element, attrs) {
            };
            this.templateUrl = partialsPath + "productbundle/productbundlegroup.html";
        }
        SWProductBundleGroup.$inject = ["$http", "$slatwall", "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath"];
        return SWProductBundleGroup;
    })();
    slatwalladmin.SWProductBundleGroup = SWProductBundleGroup;
    angular.module('slatwalladmin')
        .directive('swProductBundleGroup', ["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath",
        function ($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, $slatwall, partialsPath) {
            return new SWProductBundleGroup($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, $slatwall, partialsPath);
        }
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/productBundleGroup/swproductbundlegroup.js.map