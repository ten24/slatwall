angular.module('slatwalladmin')
.directive('swFilterGroupItem',['$http','$compile','$templateCache',function($http,$compile,$templateCache){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			logicalOperator: "="
		},
		link: function(scope, element,attrs){
			console.log(scope.logicalOperator);
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/filterGroupItem.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			$scope.uuid = guid();
        }  
	}
}]);
	
	
