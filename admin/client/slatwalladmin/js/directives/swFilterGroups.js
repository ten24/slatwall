angular.module('slatwalladmin')
.directive('swFilterGroups', ['$http','$compile','$templateCache','collectionService',function($http,$compile,$templateCache,collectionService){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/filterGroups.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
			
		},
		controller: function($scope,$element,$attrs){
		}
	}
}]);
	
