angular.module('slatwalladmin')
.directive('swCriteriaBoolean', 
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
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"criteriaBoolean.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		
		controller: function ($scope, $element, $attrs) {
			console.log($scope.filterGroupItem);
			
        } 
	}
}]);
	
