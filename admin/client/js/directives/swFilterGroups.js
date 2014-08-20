angular.module('slatwalladmin')
.directive('swFilterGroups', 
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
			filterGroupItem: "=",
			filterPropertiesList:"=",
			incrementFilterCount:"&"
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"filterGroups.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function($scope,$element,$attrs){
			$scope.itemInUse = false;
			$scope.setItemInUse = function(booleanValue){
				$scope.itemInUse = booleanValue;
			}
			
		}
	}
}]);
	
