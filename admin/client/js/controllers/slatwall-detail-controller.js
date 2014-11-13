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
	
	/*$scope.getRBKey = function(key){
		console.log(key);
		return $slatwall.getRBKey(key);
	};*/
	$scope.entity = $slatwall['new'+$scope.entityName]();
	$scope.getRBKey = $slatwall.getRBKey;
	$scope.tabPartialPath = partialsPath+'entity/';
	
	$scope.getEntity = function(){
		
		$scope.entity = $slatwall['get'+$scope.entityName]({id:$scope.entityID});
		$scope[$scope.entityName.toLowerCase()] = $scope.entity;
		$scope.entityDisplay = {
			plural:$slatwall.getRBKey('entity.'+$scope.entityName.toLowerCase()+'_plural')
		};
	};
	$scope.getEntity();
	
	$scope.allTabsOpen = false;
	
}]);