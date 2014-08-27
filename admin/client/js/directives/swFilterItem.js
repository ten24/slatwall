angular.module('slatwalladmin')
.directive('swFilterItem', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
partialsPath,
$log){
	return {
		restrict: 'A',
		scope:{
			filterItem: "=",
			siblingItems: "=",
			setItemInUse: "&",
			filterPropertiesList:"=",
			saveCollection:"&",
			removeFilterItem:"&",
			filterItemIndex:"="
		},
		link: function(scope, element,attrs){
			
			var filterGroupsPartial = partialsPath+"filterItem.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			if(angular.isUndefined($scope.filterItem.$$isClosed)){
				$scope.filterItem.$$isClosed = true;
			}
			if(angular.isUndefined($scope.filterItem.$$disabled)){
				$scope.filterItem.$$disabled = false;
			}
			if(angular.isUndefined($scope.filterItem.$$siblingItems)){
				$scope.filterItem.$$siblingItems = $scope.siblingItems;
			}
			$scope.filterItem.setItemInUse = $scope.setItemInUse;
			
			$scope.selectFilterItem = function(filterItem){
				collectionService.selectFilterItem(filterItem);
			};
			
			$scope.logicalOperatorChanged = function(logicalOperatorValue){
				$log.debug('logicalOperatorChanged');
				$log.debug(logicalOperatorValue);
				$scope.filterItem.logicalOperator = logicalOperatorValue;
				$scope.saveCollection();
			};
			
			console.log($scope.removeFilterItem);
			console.log($scope.filterItemIndex);
			
        } 
	};
}]);
	
