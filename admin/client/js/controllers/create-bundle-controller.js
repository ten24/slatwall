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
		formService,
		partialsPath
	){
		$scope.partialsPath = partialsPath;
		
		function getParameterByName(name) {
		    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		        results = regex.exec(location.search);
		    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
		}
		
		$scope.$id="create-bundle-controller";
		//if this view is part of the dialog section, call the inherited function
		if(angular.isDefined($scope.scrollToTopOfDialog)){
			$scope.scrollToTopOfDialog();
		}
		
		var productID = getParameterByName('productID');
		
		$scope.productBundleGroup;
		
		if(angular.isDefined(productID) && productID !== ''){
			var productPromise = $slatwall.getProduct({id:productID});
			
			productPromise.promise.then(function(){
				productPromise.value.$$getSkus().then(function(){
					productPromise.value.data.skus[0].$$getProductBundleGroups().then(function(){
						
						$scope.product = productPromise.value;
						angular.forEach($scope.product.data.skus[0].data.productBundleGroups,function(productBundleGroup){
							productBundleGroup.$$getProductBundleGroupType();
							
						});
					});
				});
			});
			
			
		}else{
			$scope.product = $slatwall.newProduct();
			var brand = $slatwall.newBrand();
			var productType = $slatwall.newProductType();
			$scope.product.$$setBrand(brand);
			$scope.product.$$setProductType(productType);
			$scope.product.$$addSku();
			$scope.product.data.skus[0].data.productBundleGroups = [];
		}

		$scope.saveProductBundle = function(closeDialogIndex){
			$scope.product.$$save();
		};
		
		
	}
]);
