'use strict';
angular.module('slatwalladmin').controller('edit-bundle-controller', [
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
	var productID = $location.search().productID;
	
	var filterGroupsConfig = '[{"filterGroup":[{"propertyIdentifier":"ProductBundleGroup.productBundleSku.product.productID","comparisonOperator":"=","value":"'+productID+'"}]}]';
	
	var productBundleGroupsOptions = {
			context:'edit',
			filterGroupsConfig:filterGroupsConfig.trim()
	};
	
	$scope.productBundleGroups = {
		value:[]
	};
		
	var productBundleGroupPromise = $slatwall.getEntity(
		'ProductBundleGroup',
		productBundleGroupsOptions
	);
	
	productBundleGroupPromise.then(function(value){
		$log.debug('getProcessObject');
		$scope.productBundleGroups.value = value.pageRecords;
		for(var i in $scope.productBundleGroups.value){
			var productBundleGroupTypeOptions = {
					propertyIdentifiersList:'ProductBundleGroup.productBundleGroupType',
					id:$scope.productBundleGroups.value[i].productBundleGroupID
			};
			
			var productBundleGroupTypePromise = $slatwall.getEntity(
				'productBundleGroup',
				productBundleGroupTypeOptions
			);
			
			productBundleGroupTypePromise.then(function(value){
				console.log();
				$scope.productBundleGroups.value[i].productBundleGroupType = value.pageRecords[0].productBundleGroupType[0];
				
			},function(reason){
				//display error message if getter fails
				var messages = reason.MESSAGES;
				var alerts = alertService.formatMessagesToAlerts(messages);
				alertService.addAlerts(alerts);
			});
			
		}
		$log.debug($scope.productBundleGroups);
	},function(reason){
		//display error message if getter fails
		var messages = reason.MESSAGES;
		var alerts = alertService.formatMessagesToAlerts(messages);
		alertService.addAlerts(alerts);
	});
	
}]);