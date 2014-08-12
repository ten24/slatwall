angular.module('slatwalladmin')
.directive('swEditFilterItem', ['$http','$compile','$templateCache',function($http,$compile,$templateCache){
	return {
		restrict: 'A',
		scope:{
			filterItem: "="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/editFilterItem.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			
        } 
	}
}]);
	
