angular.module('slatwalladmin')
.directive('swAddFilterButtons', ['$http','$compile','$templateCache','collectionService',function($http,$compile,$templateCache,collectionService){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			itemInUse:"="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/addFilterButtons.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			$scope.addFilterItem = function(filterItemGroup){
				collectionService.newFilterItem(filterItemGroup);
			}
			
			$scope.addFilterGroupItem = function(filterItemGroup){
				collectionService.newFilterGroupItem(filterItemGroup);
			}
        } 
	}
}]);
	
