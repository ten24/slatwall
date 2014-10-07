'use strict';
angular.module('slatwalladmin').controller('pageDialog', [
	'$scope',
	'$location',
	'$slatwall',
	'$log',
	'$anchorScroll',
	'dialogService',
function(
	$scope,
	$location,
	$slatwall,
	$log,
	$anchorScroll,
	dialogService
	
){
	$scope.$id = 'pageDialogController';
		
	//get url param to retrieve collection listing
	$scope.pageDialogs = dialogService.getPageDialogs();
	$scope.scrollToTopOfDialog = function(){
		$location.hash('topOfPageDialog');
		$anchorScroll();
	};
	
}]);