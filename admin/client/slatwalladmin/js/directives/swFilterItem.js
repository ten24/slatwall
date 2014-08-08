angular.module('slatwalladmin')
.directive('swFilterItem', ['$http','$compile','$templateCache',function($http,$compile,$templateCache){
	return {
		restrict: 'A',
		scope:{
			filterItem: "="
		},
		link: function(scope, element,attrs){
			
			console.log(scope.filterItem);
			var propertyAlias = scope.filterItem.propertyIdentifier.split(".").pop();
			scope.filterItem.displayPropertyIdentifier = propertyAlias;
			console.log(scope.filterItem);
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/filterItem.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		}
	}
}]);
	
