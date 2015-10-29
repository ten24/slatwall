/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class ProductBundleService extends slatwalladmin.BaseService {
        constructor($log, $slatwall, utilityService) {
            super();
            this.$log = $log;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.decorateProductBundleGroup = (productBundleGroup) => {
                productBundleGroup.data.$$editing = true;
                var prototype = {
                    $$setMinimumQuantity: function (quantity) {
                        if (quantity < 0 || quantity === null) {
                            this.minimumQuantity = 0;
                        }
                        if (quantity > this.maximumQuantity) {
                            this.maximumQuantity = quantity;
                        }
                    },
                    $$setMaximumQuantity: function (quantity) {
                        if (quantity < 1 || quantity === null) {
                            this.maximumQuantity = 1;
                        }
                        if (this.maximumQuantity < this.minimumQuantity) {
                            this.minimumQuantity = this.maximumQuantity;
                        }
                    },
                    $$setActive: function (value) {
                        this.active = value;
                    },
                    $$toggleEdit: function () {
                        if (angular.isUndefined(this.$$editing) || this.$$editing === false) {
                            this.$$editing = true;
                        }
                        else {
                            this.$$editing = false;
                        }
                    }
                };
                angular.extend(productBundleGroup.data, prototype);
            };
            this.formatProductBundleGroupFilters = (productBundleGroupFilters, filterTerm) => {
                this.$log.debug('FORMATTING PRODUCT BUNDLE FILTERs');
                this.$log.debug(productBundleGroupFilters);
                this.$log.debug(filterTerm);
                if (filterTerm.value === 'sku') {
                    for (var i in productBundleGroupFilters) {
                        productBundleGroupFilters[i].name = productBundleGroupFilters[i][filterTerm.value + 'Code'];
                        productBundleGroupFilters[i].type = filterTerm.name;
                        productBundleGroupFilters[i].entityType = filterTerm.value;
                        productBundleGroupFilters[i].propertyIdentifier = '_sku.skuID';
                    }
                }
                else {
                    for (var i in productBundleGroupFilters) {
                        productBundleGroupFilters[i].name = productBundleGroupFilters[i][filterTerm.value + 'Name'];
                        productBundleGroupFilters[i].type = filterTerm.name;
                        productBundleGroupFilters[i].entityType = filterTerm.value;
                        if (filterTerm.value === 'brand' || filterTerm.value === 'productType') {
                            productBundleGroupFilters[i].propertyIdentifier = '_sku.product.' + filterTerm.value + '.' + filterTerm.value + 'ID';
                        }
                        else {
                            productBundleGroupFilters[i].propertyIdentifier = '_sku.' + filterTerm.value + '.' + filterTerm.value + 'ID';
                        }
                    }
                }
                this.$log.debug(productBundleGroupFilters);
                return productBundleGroupFilters;
            };
            this.$log = $log;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
        }
    }
    ProductBundleService.$inject = [
        '$log', '$slatwall', 'utilityService'
    ];
    slatwalladmin.ProductBundleService = ProductBundleService;
    angular.module('slatwalladmin').service('productBundleService', ProductBundleService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/productbundleservice.js.map