/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class CollectionFilterItem {
        constructor(name, type, displayPropertyIdentifier, propertyIdentifier, displayValue, value, comparisonOperator, logicalOperator) {
            this.name = name;
            this.type = type;
            this.displayPropertyIdentifier = displayPropertyIdentifier;
            this.propertyIdentifier = propertyIdentifier;
            this.displayValue = displayValue;
            this.value = value;
            this.comparisonOperator = comparisonOperator;
            this.logicalOperator = logicalOperator;
        }
    }
    slatwalladmin.CollectionFilterItem = CollectionFilterItem;
    class SWProductBundleGroupController {
        constructor($log, $timeout, collectionConfigService, productBundleService, metadataservice, utilityservice, $slatwall, partialsPath) {
            this.$log = $log;
            this.$timeout = $timeout;
            this.collectionConfigService = collectionConfigService;
            this.productBundleService = productBundleService;
            this.metadataservice = metadataservice;
            this.utilityservice = utilityservice;
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.openCloseAndRefresh = () => {
                this.showAdvanced = !this.showAdvanced;
                if (this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.length) {
                    this.getCollection();
                }
            };
            this.deleteEntity = (type) => {
                if (angular.isNumber(type)) {
                    this.removeProductBundleGroupFilter(type);
                }
                else {
                    this.removeProductBundleGroup(this.index);
                    this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup = [];
                }
            };
            this.getCollection = () => {
                var options = {
                    filterGroupsConfig: angular.toJson(this.productBundleGroup.data.skuCollectionConfig.filterGroups),
                    columnsConfig: angular.toJson(this.productBundleGroup.data.skuCollectionConfig.columns),
                    currentPage: 1,
                    pageShow: 10
                };
                var collectionPromise = this.$slatwall.getEntity('Sku', options);
                collectionPromise.then((response) => {
                    this.collection = response;
                });
            };
            this.increaseCurrentCount = () => {
                if (angular.isDefined(this.totalPages) && this.totalPages != this.currentPage) {
                    this.currentPage++;
                }
                else {
                    this.currentPage = 1;
                }
            };
            this.resetCurrentCount = () => {
                this.currentPage = 1;
            };
            this.getFiltersByTerm = (keyword, filterTerm) => {
                //save search 
                this.keyword = keyword;
                this.filterTerm = filterTerm;
                this.loading = true;
                this.showAll = true;
                var _loadingCount;
                if (this.timeoutPromise) {
                    this.$timeout.cancel(this.timeoutPromise);
                }
                this.timeoutPromise = this.$timeout(() => {
                    if (filterTerm.value === 'All') {
                        this.showAll = true;
                        this.productBundleGroupFilters.value = [];
                        _loadingCount = this.searchOptions.options.length - 1;
                        for (var i in this.searchOptions.options) {
                            this.$log.debug("INT");
                            this.$log.debug(i);
                            if (i > 0) {
                                var option = this.searchOptions.options[i];
                                ((keyword, option) => {
                                    if (this.searchAllCollectionConfigs.length < 4) {
                                        this.searchAllCollectionConfigs.push(this.collectionConfigService.newCollectionConfig(this.searchOptions.options[i].value));
                                    }
                                    this.searchAllCollectionConfigs[i - 1].setKeywords(keyword);
                                    this.searchAllCollectionConfigs[i - 1].setCurrentPage(this.currentPage);
                                    this.searchAllCollectionConfigs[i - 1].setPageShow(this.pageShow);
                                    //searchAllCollectionConfig.setAllRecords(true);
                                    this.searchAllCollectionConfigs[i - 1].getEntity().then((value) => {
                                        this.recordsCount = value.recordsCount;
                                        this.pageRecordsStart = value.pageRecordsStart;
                                        this.pageRecordsEnd = value.pageRecordsEnd;
                                        this.totalPages = value.totalPages;
                                        var formattedProductBundleGroupFilters = this.productBundleService.formatProductBundleGroupFilters(value.pageRecords, option, this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup);
                                        for (var j in formattedProductBundleGroupFilters) {
                                            if (this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.indexOf(formattedProductBundleGroupFilters[j]) == -1) {
                                                this.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
                                                this.$log.debug(formattedProductBundleGroupFilters[j]);
                                            }
                                        }
                                        // Increment Down The Loading Count
                                        _loadingCount--;
                                        // If the loadingCount drops to 0, then we can update scope
                                        if (_loadingCount == 0) {
                                            //This sorts the array of objects by the objects' "type" property alphabetically
                                            this.productBundleGroupFilters.value = this.utilityservice.arraySorter(this.productBundleGroupFilters.value, ["type", "name"]);
                                            this.$log.debug(this.productBundleGroupFilters.value);
                                            if (this.productBundleGroupFilters.value.length == 0) {
                                                this.currentPage = 0;
                                            }
                                        }
                                        this.loading = false;
                                    });
                                })(keyword, option);
                            }
                        }
                    }
                    else {
                        this.showAll = false;
                        if (angular.isUndefined(this.searchCollectionConfig) || filterTerm.value != this.searchCollectionConfig.baseEntityName) {
                            this.searchCollectionConfig = this.collectionConfigService.newCollectionConfig(filterTerm.value);
                        }
                        this.searchCollectionConfig.setKeywords(keyword);
                        this.searchCollectionConfig.setCurrentPage(this.currentPage);
                        this.searchCollectionConfig.setPageShow(this.pageShow);
                        this.searchCollectionConfig.getEntity().then((value) => {
                            this.recordsCount = value.recordsCount;
                            this.pageRecordsStart = value.pageRecordsStart;
                            this.pageRecordsEnd = value.pageRecordsEnd;
                            this.totalPages = value.totalPages;
                            this.$log.debug('getFiltersByTerm');
                            this.$log.debug(value);
                            this.productBundleGroupFilters.value = this.productBundleService.formatProductBundleGroupFilters(value.pageRecords, filterTerm, this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup) || [];
                            this.loading = false;
                        });
                    }
                }, 500);
            };
            this.addFilterToProductBundle = (filterItem, include, index) => {
                var collectionFilterItem = new CollectionFilterItem(filterItem.name, filterItem.type, filterItem.type, filterItem.propertyIdentifier, filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID'], filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID']);
                if (include === false) {
                    collectionFilterItem.comparisonOperator = '!=';
                }
                else {
                    collectionFilterItem.comparisonOperator = '=';
                }
                if (this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.length > 0) {
                    collectionFilterItem.logicalOperator = 'OR';
                }
                if (angular.isDefined(this.searchCollectionConfig)) {
                    this.searchCollectionConfig.addFilter(this.searchCollectionConfig.baseEntityName + "ID", collectionFilterItem.value, "!=");
                }
                if (this.showAll) {
                    switch (collectionFilterItem.type) {
                        case 'Product Type':
                            this.searchAllCollectionConfigs[0].addFilter("productTypeID", collectionFilterItem.value, "!=");
                            break;
                        case 'Brand':
                            this.searchAllCollectionConfigs[1].addFilter("brandID", collectionFilterItem.value, "!=");
                            break;
                        case 'Products':
                            this.searchAllCollectionConfigs[2].addFilter("productID", collectionFilterItem.value, "!=");
                            break;
                        case 'Skus':
                            this.searchAllCollectionConfigs[3].addFilter("skuID", collectionFilterItem.value, "!=");
                            break;
                    }
                }
                //Adds filter item to designated filtergroup
                this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.push(collectionFilterItem);
                this.productBundleGroup.forms[this.formName].skuCollectionConfig.$setDirty();
                //reload the list to correct pagination show all takes too long for this to be graceful
                if (!this.showAll) {
                    this.getFiltersByTerm(this.keyword, this.filterTerm);
                }
                else {
                    //Removes the filter item from the left hand search result
                    this.productBundleGroupFilters.value.splice(index, 1);
                }
            };
            this.removeProductBundleGroupFilter = (index) => {
                //Pushes item back into array
                this.productBundleGroupFilters.value.push(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup[index]);
                //Sorts Array
                this.productBundleGroupFilters.value = this.utilityservice.arraySorter(this.productBundleGroupFilters.value, ["type", "name"]);
                //Removes the filter item from the filtergroup
                var collectionFilterItem = this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.splice(index, 1)[0];
                if (angular.isDefined(this.searchCollectionConfig)) {
                    this.searchCollectionConfig.removeFilter(this.searchCollectionConfig.baseEntityAlias + '.' + this.searchCollectionConfig.baseEntityName + "ID", collectionFilterItem.value, "!=");
                }
                if (this.showAll) {
                    switch (collectionFilterItem.type) {
                        case 'Product Type':
                            this.searchAllCollectionConfigs[0].removeFilter("_productType.productTypeID", collectionFilterItem.value, "!=");
                            break;
                        case 'Brand':
                            this.searchAllCollectionConfigs[1].removeFilter("_brand.brandID", collectionFilterItem.value, "!=");
                            break;
                        case 'Products':
                            this.searchAllCollectionConfigs[2].removeFilter("_product.productID", collectionFilterItem.value, "!=");
                            break;
                        case 'Skus':
                            this.searchAllCollectionConfigs[3].removeFilter("_sku.skuID", collectionFilterItem.value, "!=");
                            break;
                    }
                }
                if (!this.showAll) {
                    this.getFiltersByTerm(this.keyword, this.filterTerm);
                }
                else {
                    this.productBundleGroupFilters.value.splice(index, 0, collectionFilterItem);
                }
                this.productBundleGroup.forms[this.formName].skuCollectionConfig.$setDirty();
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
            this.searchAllCollectionConfigs = [];
            if (angular.isUndefined(this.filterPropertiesList)) {
                this.filterPropertiesList = {};
                var filterPropertiesPromise = this.$slatwall.getFilterPropertiesByBaseEntityName('_sku');
                filterPropertiesPromise.then((value) => {
                    metadataservice.setPropertiesList(value, '_sku');
                    this.filterPropertiesList['_sku'] = metadataservice.getPropertiesListByBaseEntityAlias('_sku');
                    metadataservice.formatPropertiesList(this.filterPropertiesList['_sku'], '_sku');
                });
            }
            this.skuCollectionConfig = {
                baseEntityName: "Sku",
                baseEntityAlias: "_sku",
                collectionConfig: this.productBundleGroup.data.skuCollectionConfig,
                collectionObject: 'Sku'
            };
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
                setSelected: (searchOption) => {
                    this.searchOptions.selected = searchOption;
                    this.getFiltersByTerm(this.productBundleGroupFilters.keyword, searchOption);
                }
            };
            this.navigation = {
                value: 'Basic',
                setValue: (value) => {
                    this.value = value;
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
            this.getCollection();
        }
    }
    SWProductBundleGroupController.$inject = ["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath"];
    slatwalladmin.SWProductBundleGroupController = SWProductBundleGroupController;
    class SWProductBundleGroup {
        constructor($log, $timeout, collectionConfigService, productBundleService, metadataservice, utilityservice, $slatwall, partialsPath) {
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
            this.link = ($scope, element, attrs) => {
            };
            this.templateUrl = partialsPath + "productbundle/productbundlegroup.html";
        }
    }
    SWProductBundleGroup.$inject = ["$http", "$slatwall", "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath"];
    slatwalladmin.SWProductBundleGroup = SWProductBundleGroup;
    angular.module('slatwalladmin')
        .directive('swProductBundleGroup', ["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath",
            ($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, $slatwall, partialsPath) => new SWProductBundleGroup($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, $slatwall, partialsPath)
    ]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swproductbundlegroup.js.map
