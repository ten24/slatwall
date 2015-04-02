'use strict';
angular.module('slatwalladmin').controller('routerController', [
	'$scope',
	'$routeParams',
	'$location',
	'$log',
	'$injector',
	'$compile',
	'partialsPath',
	'baseURL',
function(
	$scope,
	$routeParams,
	$location,
	$log,
	$injector,
	$compile,
	partialsPath,
	baseURL
){
	$scope.$id="routerController";
	$scope.partialRoute = '';
	
	$log.debug($routeParams);
	$log.debug($location);
	var path = $location.path();
	$scope.controllerType = path.split('/')[1];
	var type;
	
	if($scope.controllerType === 'entity'){
		$scope.entityName = $routeParams.entityName;
		if(angular.isDefined($routeParams.entityID)){
			$scope.entityID = $routeParams.entityID || '';
		}
	}

	var directiveToRender;
	if($scope.entityName){
		if($scope.entityID){
			$scope.directiveToRender = 'sw-detail';
		}else{
			$scope.directiveToRender = 'sw-list';
		}
	}

// 	<sw-detail ng-if="entityName && entityID"></sw-detail>

// <sw-list ng-if="entityName && !entityID"></sw-list>

	compiled = $compile('<' + $scope.directiveToRender + '></'+ $scope.directiveToRender +'>')($scope);

    //append this to customElements
   // $element.append(compiled);

}]);