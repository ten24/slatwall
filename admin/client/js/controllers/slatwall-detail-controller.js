'use strict';
angular.module('slatwalladmin').controller('slatwall-detail-controller', [
	'$scope',
	'$log',
	'$slatwall',
	'partialsPath',
function(
	$scope,
	$log,
	$slatwall,
	partialsPath
){
	$scope.$id="slatwallDetailController";
	$log.debug('slatwallDetailController');
	
	var propertyCasedEntityName = $scope.entityName.charAt(0).toUpperCase() + $scope.entityName.slice(1);
	
	$scope.getRBKey = $slatwall.getRBKey;
	$scope.tabPartialPath = partialsPath+'entity/';
	
	$scope.getEntity = function(){
		var entityPromise = $slatwall['get'+propertyCasedEntityName]({id:$scope.entityID});
		entityPromise.promise.then(function(){
			$scope.entity = entityPromise.value;
			$scope[$scope.entityName.toLowerCase()] = $scope.entity;
			$scope.entityDisplay = {
				plural:$slatwall.getRBKey('entity.'+$scope.entityName.toLowerCase()+'_plural')
			};
			$scope.detailTabs = $scope.entity.metaData.$$getDetailTabs();
		});
	};
	$scope.getEntity();
	
	$scope.allTabsOpen = false;
	
}]);