'use strict';
angular.module('slatwalladmin').controller('routerController', [
	'$scope',
	'$routeParams',
	'$location',
	'$log',
	'partialsPath',
	'baseURL',
function(
	$scope,
	$routeParams,
	$location,
	$log,
	partialsPath,
	baseURL
){
	$scope.$id="routerController";
	$scope.partialRoute = '';
	
	$log.debug($routeParams);
	$log.debug($location);
	var path = $location.path();
	var controllerType = path.split('/')[1];
	var type;
	
	/*var getPartialByType = function(type){
		if(type){
			
		}
	}
	var getPartialByControllerTypeAndType = function(controllerType,type){
		
		if(contollerType === 'entity'){
			return partialsPath+controllerType+'/'+type;
		}
		
		
	};*/
	var partial;
	if(controllerType === 'entity'){
		$scope.entityName = $routeParams.entityName;
		$scope.entityID = $routeParams.entityID || '';
		
		if($scope.entityID.length){
			partial = partialsPath+'entity/'+'slatwall-detail.html';
		}else{
			partial = partialsPath+'entity/'+'slatwall-list.html';
		}
	}
	
	$scope.partialRoute = partial;
	
}]);