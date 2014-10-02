'use strict';
angular.module('slatwalladmin').controller('create-bundle-controller', [
	'$scope',
	'$location',
	'$slatwall',
	'$log',
	'$rootScope',
	'alertService',
	'dialogService',
	'formService',
function(
	$scope,
	$location,
	$slatwall,
	$log,
	$rootScope,
	alertService,
	dialogService,
	formService
	
	
){
		//if this view is part of the dialog section, call the inherited function
		if(angular.isDefined($scope.scrollToTopOfDialog)){
			$scope.scrollToTopOfDialog();
		}
		
		
		$log.debug('getProductBundleProcessObject ');
		var processObjectPromise = $slatwall.getProcessObject(
			'Product',
			null,
			'CreateBundle',
			'productTypeOptions,product.brandOptions,product.productCode,product.productName,product.price,product.brand,product.productType'
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
		
	
	$scope.saveProductBundle = function(closeDialogIndex){
		
		var createProductBundleForm = formService.getForm('form.createProductBundle');
		//only save the form if it passes validation
		createProductBundleForm.$submitted = true;
		if(createProductBundleForm.$valid === true){
			var params = {
				"price":createProductBundleForm["product.price"].$modelValue,
				"product.productType.productTypeID":createProductBundleForm["product.productType"].$modelValue.value,
				"product.productName":createProductBundleForm['product.productName'].$modelValue,
				"product.productCode":createProductBundleForm['product.productCode'].$modelValue,
				"product.brand.brandID":createProductBundleForm['product.brand'].$modelValue.value
			};
			$log.debug(params);
			var saveProductBundlePromise = $slatwall.saveEntity('product', null, params,'create');
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
			//if valid and we have a close index then close
			
		}
	};
	
	/*$scope.processObject.bundleGroups = [
		{
			'minimumQuantity': 1,
			'maximumQuantity': 1,
			'bundleGroupType': {
				'typeName': 'Deck'
			}
		}
	];
	
	$scope.product = {};*/
	
}]);