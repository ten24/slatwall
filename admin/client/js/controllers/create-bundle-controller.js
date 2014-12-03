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
	function(
		$scope,
		$location,
		$log,
		$rootScope,
		$window,
		$slatwall,
		dialogService,
		alertService,
		productBundleService,
		formService
	){
		$scope.$id="create-bundle-controller";
		//if this view is part of the dialog section, call the inherited function
		if(angular.isDefined($scope.scrollToTopOfDialog)){
			$scope.scrollToTopOfDialog();
		}
		
		var productID = $location.search().productID;
		console.log('productID');
		console.log(productID);
		$scope.productBundleGroup;
		
		if(angular.isDefined(productID)){
			var product = $slatwall.getProduct({id:productID});
			
		}else{
			$scope.product = $slatwall.newProduct();
			var brand = $slatwall.newBrand();
			var productType = $slatwall.newProductType();
			$scope.product.$$setBrand(brand);
			$scope.product.$$setProductType(productType);
			$scope.product.$$addSku();
			$scope.product.data.skus[0].data.productBundleGroups = [];
			console.log($scope.product);
		}

		$scope.saveProductBundle = function(closeDialogIndex){
			$scope.product.$$save();
		};

		
	}
]);
