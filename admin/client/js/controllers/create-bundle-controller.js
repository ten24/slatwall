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
	var processObjectPromise = $slatwall.getProcessObject(
		'Product',
		null,
		'createBundle',
		'productTypeOptions,product.brandOptions,product.productCode,product.productName,product.price,product.brand,product.productType'
	);
	processObjectPromise.then(function(value){
		$log.debug('getProcessObject');
		$scope.processObject = value.data;
		
		var validation = $slatwall.getValidation('Product_Create');
		validation.then(function(value){
			$log.debug('getValidation');
			$log.debug(value);
			$scope.processObject.validation = value;
			
			formService.setForm($scope.form.createProductBundle);
			
		},function(reason){
			var messages = reason.MESSAGES;
			var alerts = alertService.formatMessagesToAlerts(messages);
			alertService.addAlerts(alerts);
		});
		$log.debug($scope.processObject);
	},function(reason){
		//display error message if getter fails
		var messages = reason.MESSAGES;
		var alerts = alertService.formatMessagesToAlerts(messages);
		alertService.addAlerts(alerts);
	});
	
	$scope.saveProductBundle = function(closeDialogIndex){
		$log.debug('saving Product Bundle');
		var createProductBundleForm = formService.getForm('form.createProductBundle');
		$log.debug(createProductBundleForm);
		//only save the form if it passes validation
		createProductBundleForm.$submitted = true;
		if(createProductBundleForm.$valid === true){
			//if valid and we have a close index then close
			if(angular.isDefined(closeDialogIndex)){
				$rootScope.closePageDialog(closeDialogIndex);
			}
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