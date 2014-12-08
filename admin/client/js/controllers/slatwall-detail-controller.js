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
	
	$scope.entity = $slatwall['new'+propertyCasedEntityName]();
	$scope.getRBKey = $slatwall.getRBKey;
	$scope.tabPartialPath = partialsPath+'entity/';
	
	$scope.getEntity = function(){
		
		$scope.entity = $slatwall['get'+propertyCasedEntityName]({id:$scope.entityID});
		$scope[$scope.entityName.toLowerCase()] = $scope.entity;
		$scope.entityDisplay = {
			plural:$slatwall.getRBKey('entity.'+$scope.entityName.toLowerCase()+'_plural')
		};
	};
	$scope.getEntity();
	
	$scope.allTabsOpen = false;
	
}]);