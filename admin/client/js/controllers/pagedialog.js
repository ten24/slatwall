'use strict';
angular.module('slatwalladmin').controller('pageDialog', [
	'$scope',
	'$location',
	'$slatwall',
	'dialogService',
	'$log',
function(
	$scope,
	$location,
	$slatwall,
	dialogService,
	$log
){
	
	//get url param to retrieve collection listing
	$scope.pageDialogs = dialogService.getPageDialogs();
	
}]);