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
			var filterGroupsPartial = partialsPath+"editFilterItem.html"
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
			console.log($scope.selectedFilterProperty);
			//$scope.filterPropertiesList.selectedFilterProperty = $scope.filterItem.propertyIdentifier;
			console.log($scope.selectedFilterProperty);
			console.log($scope.filterItem);
			
			$scope.selectedFilterPropertyChanged = function(selectedFilterProperty){
				console.log(selectedFilterProperty);
			}
        } 
	}
}]);
	
