angular.module('slatwalladmin')
.directive('swCriteriaDate', 
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
			itemInUse:"=",
			setItemInUse:"&"
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"criteriaDate.html";
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
	
