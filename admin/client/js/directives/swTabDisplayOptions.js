angular.module('slatwalladmin')
.directive('swTabDisplayOptions',
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
			siblingItems:"=",
			incrementFilterCount:"&",
			setItemInUse:"&",
			filterPropertiesList:"="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"tabDisplayOptions.html";
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
	
	
