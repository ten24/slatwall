angular.module('slatwalladmin')
.directive('swEditFilterItem', 
['$http',
'$compile',
'$templateCache',
'partialsPath',

function($http,
$compile,
$templateCache,
partialsPath){
	return {
		restrict: 'A',
		scope:{
			filterItem: "=",
			filterPropertiesList:"="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"editFilterItem.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			//initialize directive
			if(angular.isUndefined($scope.filterItem.isClosed)){
				$scope.filterItem.isClosed = true;
			}
			for(i in $scope.filterPropertiesList.DATA){
				var filterProperty = $scope.filterPropertiesList.DATA[i];
				console.log(filterProperty.propertyIdentifier);
				if(filterProperty.propertyIdentifier === $scope.filterItem.propertyIdentifier){
					$scope.selectedFilterProperty = $scope.filterItem;
				}
			}
			
			//public functions
			$scope.selectedFilterPropertyChanged = function(selectedFilterProperty){
				console.log(selectedFilterProperty);
				$scope.selectedFilterProperty = selectedFilterProperty;
			}
        } 
	}
}]);
	
