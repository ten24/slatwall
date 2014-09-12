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
	
	$scope.closePageDialog = function( index ) {
		dialogService.removePageDialog( index );
    }
	
}]);