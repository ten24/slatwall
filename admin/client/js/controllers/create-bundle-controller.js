'use strict';
angular.module('slatwalladmin').controller('create-bundle-controller', [
	'$scope',
	'$location',
	'$slatwall',
	'$log',
	'$rootScope',
	'alertService',
	'dialogService',
	'productBundleService',
	'formService',
function(
	$scope,
	$location,
	$slatwall,
	$log,
	$rootScope,
	alertService,
	dialogService,
	productBundleService,
	formService
){
	$scope.$id="create-bundle-controller";
		//if this view is part of the dialog section, call the inherited function
	if(angular.isDefined($scope.scrollToTopOfDialog)){
		$scope.scrollToTopOfDialog();
	}
	
	
	$log.debug('getProductBundleProcessObject ');
	var processObjectPromise = $slatwall.getProcessObject(
		'Product',
		null,
		'CreateBundle',
		'productTypeOptions,product.brandOptions,product.productCode,product.productName,product.price,product.brand,product.productType,productBundleGroups'
	);
	
	processObjectPromise.then(function(value){
		$log.debug('getProcessObject');
		$scope.processObject = value.data;
		formService.setForm($scope.form.createProductBundle);
		$log.debug($scope.processObject);
	},function(reason){
		//display error message if getter fails
		var messages = reason.MESSAGES;
		var alerts = alertService.formatMessagesToAlerts(messages);
		alertService.addAlerts(alerts);
	});
	
	$scope.addProductBundleGroup = function(){
		$log.debug('add bundle group');
		var productBundleGroup = productBundleService.newProductBundle();
		$scope.processObject.productBundleGroups.value.push(productBundleGroup);
		$log.debug($scope.processObject.productBundleGroups);
	};
	
	$scope.saveProductBundle = function(closeDialogIndex){
		
		var createProductBundleForm = formService.getForm('form.createProductBundle');
		//only save the form if it passes validation
		createProductBundleForm.$submitted = true;
		if(createProductBundleForm.$valid === true){
			//custom validation for product BundleGroups
			if(isProductBundleGroupsValid()){
				var params = {
					"price":createProductBundleForm["product.price"].$modelValue,
					"product.productType.productTypeID":createProductBundleForm["product.productType"].$modelValue.value,
					"product.productName":createProductBundleForm['product.productName'].$modelValue,
					"product.productCode":createProductBundleForm['product.productCode'].$modelValue,
					"product.brand.brandID":createProductBundleForm['product.brand'].$modelValue.value,
					"productBundleGroups":angular.toJson($scope.processObject.productBundleGroups.value)
				};
				$log.debug(params);
				var saveProductBundlePromise = $slatwall.saveEntity('Product', null, params,'CreateBundle');
				saveProductBundlePromise.then(function(value){
					$log.debug('saving Product Bundle');
					var messages = value.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
					if(angular.isDefined(closeDialogIndex)){
						$rootScope.closePageDialog(closeDialogIndex);
					}
					
					formService.resetForm(createProductBundleForm);
					
				},function(reason){
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
			}
		}
	};
	
	var isProductBundleGroupsValid = function(){
		var isValid = true;
		console.log('productBundleGroups');
		console.log($scope.processObject.productBundleGroups.value);
		if(!$scope.processObject.productBundleGroups.value.length){
			$log.debug('hasnogroup');
			isValid = false;
		}else{
			//validate each productBundleGroup
			for(var i in $scope.processObject.productBundleGroups.value){
				var productBundleGroup = $scope.processObject.productBundleGroups.value[i];
				if(angular.isUndefined(productBundleGroup.productBundleGroupType.typeID)){
					$log.debug('hasnotypeid');
					isValid = false;
				}
				if(!productBundleGroup.productBundleGroupFilters.length){
					$log.debug('hasnofilters');
					isValid = false;
				}
			}
		}
		
			
		return isValid;
	};
}]);