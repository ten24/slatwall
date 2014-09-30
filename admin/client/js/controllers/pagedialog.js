'use strict';
angular.module('slatwalladmin').controller('pageDialog', [
	'$scope',
	'$location',
	'$slatwall',
	'$log',
	'dialogService',
function(
	$scope,
	$location,
	$slatwall,
	$log,
	dialogService
	
){
	
	//get url param to retrieve collection listing
	$scope.pageDialogs = dialogService.getPageDialogs();
	
}]);