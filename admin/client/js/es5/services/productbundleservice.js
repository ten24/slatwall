/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var slatwalladmin;
(function (slatwalladmin) {
    var ProductBundleService = (function (_super) {
        __extends(ProductBundleService, _super);
        function ProductBundleService($log, $slatwall, utilityService) {
            var _this = this;
            _super.call(this);
            this.$log = $log;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.decorateProductBundleGroup = function (productBundleGroup) {
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
            this.formatProductBundleGroupFilters = function (productBundelGroupFilters, filterTerm) {
                _this.$log.debug('formatProductBundleGroupFilters');
                _this.$log.debug(filterTerm);
                if (filterTerm.value === 'sku') {
                    for (var i in productBundelGroupFilters) {
                        productBundelGroupFilters[i].name = productBundelGroupFilters[i][filterTerm.value + 'Code'];
                        productBundelGroupFilters[i].type = filterTerm.name;
                        productBundelGroupFilters[i].entityType = filterTerm.value;
                        productBundelGroupFilters[i].propertyIdentifier = '_sku.skuID';
                    }
                }
                else {
                    for (var i in productBundelGroupFilters) {
                        productBundelGroupFilters[i].name = productBundelGroupFilters[i][filterTerm.value + 'Name'];
                        productBundelGroupFilters[i].type = filterTerm.name;
                        productBundelGroupFilters[i].entityType = filterTerm.value;
                        if (filterTerm.value === 'brand' || filterTerm.value === 'productType') {
                            productBundelGroupFilters[i].propertyIdentifier = '_sku.product.' + filterTerm.value + '.' + filterTerm.value + 'ID';
                        }
                        else {
                            productBundelGroupFilters[i].propertyIdentifier = '_sku.' + filterTerm.value + '.' + filterTerm.value + 'ID';
                        }
                    }
                }
                _this.$log.debug(productBundelGroupFilters);
                return productBundelGroupFilters;
            };
            this.$log = $log;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
        }
        ProductBundleService.$inject = [
            '$log', '$slatwall', 'utilityService'
        ];
        return ProductBundleService;
    })(slatwalladmin.BaseService);
    slatwalladmin.ProductBundleService = ProductBundleService;
    angular.module('slatwalladmin').service('productBundleService', ProductBundleService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/productbundleservice.js.map