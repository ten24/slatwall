'use strict';
angular.module('slatwalladmin').controller('create-bundle-controller', [
    '$scope',
    '$location',
    '$log',
    '$rootScope',
    '$window',
    '$slatwall',
    'dialogService',
    'alertService',
    'productBundleService',
    'formService',
    'partialsPath',
    function ($scope, $location, $log, $rootScope, $window, $slatwall, dialogService, alertService, productBundleService, formService, partialsPath) {
        $scope.partialsPath = partialsPath;
        var getParameterByName = (name) => {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        };
        $scope.$id = "create-bundle-controller";
        //if this view is part of the dialog section, call the inherited function
        if (angular.isDefined($scope.scrollToTopOfDialog)) {
            $scope.scrollToTopOfDialog();
        }
        var productID = getParameterByName('productID');
        var productBundleConstructor = () => {
            $log.debug($scope);
            if (angular.isDefined($scope.product)) {
                for (var form in $scope.product.forms) {
                    formService.resetForm($scope.product.forms[form]);
                }
                if (angular.isDefined($scope.product.data.skus[0])) {
                    for (var form in $scope.product.data.skus[0].forms) {
                        formService.resetForm($scope.product.data.skus[0].forms[form]);
                    }
                }
                if (angular.isDefined($scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup)) {
                    for (var form in $scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup.forms) {
                        formService.resetForm($scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup.forms[form]);
                    }
                }
            }
            $scope.product = $slatwall.newProduct();
            var brand = $slatwall.newBrand();
            var productType = $slatwall.newProductType();
            $scope.product.$$setBrand(brand);
            $scope.product.$$setProductType(productType);
            $scope.product.$$addSku();
            $scope.product.data.skus[0].data.productBundleGroups = [];
        };
        $scope.productBundleGroup;
        if (angular.isDefined(productID) && productID !== '') {
            var productPromise = $slatwall.getProduct({ id: productID });
            productPromise.promise.then(function () {
                $log.debug(productPromise.value);
                productPromise.value.$$getSkus().then(function () {
                    productPromise.value.data.skus[0].$$getProductBundleGroups().then(function () {
                        $scope.product = productPromise.value;
                        angular.forEach($scope.product.data.skus[0].data.productBundleGroups, function (productBundleGroup) {
                            productBundleGroup.$$getProductBundleGroupType();
                            productBundleService.decorateProductBundleGroup(productBundleGroup);
                            productBundleGroup.data.$$editing = false;
                        });
                    });
                });
            }, productBundleConstructor());
        }
        else {
            productBundleConstructor();
        }
        $scope.saveProductBundle = (closeDialogIndex, saveAndNew) => {
            $scope.newSaving = true;
            $log.debug($scope.newSaving);
            $scope.dIndex = closeDialogIndex;
            $scope.product.$$save().then(function () {
                $log.debug("Turn off the loader after saving.");
                $scope.newSaving = false;
                $scope.closeSaving = true;
                $rootScope.closePageDialog($scope.dIndex);
                if (saveAndNew) {
                    $rootScope.openPageDialog('productbundle/createproductbundle');
                }
            });
        };
    }
]);

//# sourceMappingURL=../controllers/create-bundle-controller.js.map