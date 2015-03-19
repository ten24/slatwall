'use strict';
angular.module('slatwalladmin').controller('slatwall-list-controller', [
	'$scope',
	'$log',
	'$slatwall',
function(
	$scope,
	$log,
	$slatwall
){
	/*$scope.entityName is inherited from routeController*/
	$scope.$id="slatwallListController";
	$log.debug('slatwallListController');
	$scope.entityDisplayName = $slatwall.getRBKey('entity.'+$scope.entityName.toLowerCase());
	
	$scope.getCollection = function(){
		
		var pageShow = 50;
		if($scope.pageShow !== 'Auto'){
			pageShow = $scope.pageShow;
		}
		
		var collectionListingPromise = $slatwall.getEntity($scope.entityName, {currentPage:$scope.currentPage, pageShow:pageShow, keywords:$scope.keywords});
		collectionListingPromise.then(function(value){
			$scope.collection = value;
			$scope.collectionConfig = angular.fromJson($scope.collection.collectionConfig);
		});
	};
	$scope.getCollection();
	
}]);