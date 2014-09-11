'use strict';
angular.module('slatwalladmin').controller('pageDialog', [
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
	
	//get url param to retrieve collection listing
	$scope.pageDialogs = dialogService.getPageDialogs();
	
}]);

angular.module('slatwalladmin').controller('clickController', [
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
	
	$scope.openCreateDialog = function() {
		dialogService.addCreatePageDialog('createproductbundle');	
	}
	
}]);
	