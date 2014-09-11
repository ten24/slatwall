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







angular.module('slatwalladmin').controller('mainController', [
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
	
	$scope.openCreateDialog = function( createPartial ) {
		dialogService.addCreatePageDialog( createPartial );	
	}
	
}]);
	