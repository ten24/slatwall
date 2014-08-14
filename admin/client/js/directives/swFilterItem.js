angular.module('slatwalladmin')
.directive('swFilterItem', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',

function($http,
$compile,
$templateCache,
collectionService,
partialsPath){
	return {
		restrict: 'A',
		scope:{
			filterItem: "=",
			siblingItems: "=",
			setItemInUse: "&",
			filterPropertiesList:"="
		},
		link: function(scope, element,attrs){
			var propertyAlias = scope.filterItem.propertyIdentifier.split(".").pop();
			scope.filterItem.displayPropertyIdentifier = propertyAlias;
			var filterGroupsPartial = partialsPath+"filterItem.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			if(typeof($scope.filterItem.isClosed) === 'undefined'){
				$scope.filterItem.isClosed = true;
			}
			if(typeof($scope.filterItem.disabled) === 'undefined'){
				$scope.filterItem.disabled = false;
			}
			if(typeof($scope.filterItem.siblingItems) === 'undefined'){
				$scope.filterItem.siblingItems = $scope.siblingItems;
			}
			$scope.filterItem.setItemInUse = $scope.setItemInUse;
			
			$scope.selectFilterItem = function(filterItem){
				collectionService.selectFilterItem(filterItem);
				
			}
        } 
	}
}]);
	
