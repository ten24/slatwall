var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var ProductCreateController = (function () {
        function ProductCreateController($scope, $element, $log, $slatwall, collectionConfigService, selectionService) {
            var _this = this;
            this.$scope = $scope;
            this.$element = $element;
            this.$log = $log;
            this.$slatwall = $slatwall;
            this.collectionConfigService = collectionConfigService;
            this.selectionService = selectionService;
            this.$log.debug('init product_create controller');
            //on select change get collection
            this.$scope.preprocessproduct_createCtrl.productTypeChanged = function (selectedOption) {
                _this.$scope.preprocessproduct_createCtrl.selectedOption = selectedOption;
                _this.$scope.preprocessproduct_createCtrl.getCollection();
                _this.selectionService.clearSelection('ListingDisplay');
            };
            this.$scope.preprocessproduct_createCtrl.getCollection = function () {
                _this.collectionConfig = _this.collectionConfigService.newCollectionConfig('Option');
                _this.collectionConfig.setDisplayProperties('optionGroup.optionGroupName,optionName', undefined, { isVisible: true });
                _this.collectionConfig.addDisplayProperty('optionID', undefined, { isVisible: false });
                //this.collectionConfig.addFilter('optionGroup.optionGroupID',$('input[name="currentOptionGroups"]').val(),'NOT IN')
                _this.collectionConfig.addFilter('optionGroup.globalFlag', 1, '=');
                _this.collectionConfig.addFilter('optionGroup.productTypes.productTypeID', _this.$scope.preprocessproduct_createCtrl.selectedOption.value, '=', 'OR');
                _this.collectionConfig.setOrderBy('optionGroup.sortOrder|ASC,sortOrder|ASC');
                _this.$scope.preprocessproduct_createCtrl.collectionListingPromise = _this.collectionConfig.getEntity();
                _this.$scope.preprocessproduct_createCtrl.collectionListingPromise.then(function (data) {
                    _this.$scope.preprocessproduct_createCtrl.collection = data;
                    _this.$scope.preprocessproduct_createCtrl.collection.collectionConfig = _this.collectionConfig;
                });
            };
            var jQueryOptions = $("select[name='product.productType.productTypeID']")[0];
            this.$scope.preprocessproduct_createCtrl.options = [];
            angular.forEach(jQueryOptions, function (jQueryOption) {
                var option = {
                    label: jQueryOption.label,
                    value: jQueryOption.value
                };
                _this.$scope.preprocessproduct_createCtrl.options.push(option);
            });
            this.$scope.preprocessproduct_createCtrl.productTypeChanged(this.$scope.preprocessproduct_createCtrl.options[0]);
        }
        ProductCreateController.$inject = ["$scope", '$element', '$log', "$slatwall", "collectionConfigService", "selectionService"];
        return ProductCreateController;
    })();
    slatwalladmin.ProductCreateController = ProductCreateController;
    angular.module('slatwalladmin').controller('preprocessproduct_create', ProductCreateController);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/preprocessproduct_create.js.map