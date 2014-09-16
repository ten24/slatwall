'use strict';
angular.module('slatwalladmin').controller('create-bundle-controller', [
	'$scope',
	'$location',
	'slatwallService',
	'dialogService',
	'$log',
function(
	$scope,
	$location,
	slatwallService,
	dialogService,
	$log
){
	
	$scope.processObject = {};
	$scope.processObject.bundleGroups = [
		{
			'minimumQuantity': 1,
			'maximumQuantity': 1,
			'bundleGroupType': {
				'typeName': 'Deck'
			}
		}
	];
	
}]);