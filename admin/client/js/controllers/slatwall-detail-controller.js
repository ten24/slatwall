'use strict';
angular.module('slatwalladmin').controller('slatwall-detail-controller', [
	'$scope',
	'$location',
	'$log',
	'$slatwall',
	'partialsPath',
function(
	$scope,
	$location,
	$log,
	$slatwall,
	partialsPath
){
	$scope.$id="slatwallDetailController";
	$log.debug('slatwallDetailController');
	
	var setupMetaData = function(){
		$scope[$scope.entityName.toLowerCase()] = $scope.entity;
		$scope.detailTabs = $scope.entity.metaData.$$getDetailTabs();
		$log.debug('detailtabs');
		$log.debug($scope.detailTabs);
	};
	
	var propertyCasedEntityName = $scope.entityName.charAt(0).toUpperCase() + $scope.entityName.slice(1);
	
	
	$scope.tabPartialPath = partialsPath+'entity/';
	
	$scope.getEntity = function(){
		if($scope.entityID === 'null'){
			$scope.entity = $slatwall['new'+propertyCasedEntityName]();
			setupMetaData();
		}else{
			var entityPromise = $slatwall['get'+propertyCasedEntityName]({id:$scope.entityID});
			entityPromise.promise.then(function(){
				$scope.entity = entityPromise.value;
				setupMetaData();
			});
		}
		
	};
	$scope.getEntity();
	
	$scope.deleteEntity = function(){
		var deletePromise = $scope.entity.$$delete();
		deletePromise.then(function(){
			$location.path( '/entity/'+propertyCasedEntityName+'/' );
		});
	};
	
	
	$scope.allTabsOpen = false;
	
}]);