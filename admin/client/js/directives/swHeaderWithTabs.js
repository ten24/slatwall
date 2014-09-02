angular.module('slatwalladmin')
.directive('swHeaderWithTabs', 
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
			headerTitle:"=",
			tabArray:"="
		},
		link: function(scope, element,attrs){
			var Partial = partialsPath+"headerWithTabs.html";
			var templateLoader = $http.get(Partial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			//public functions
			$scope.selectedTabChanged = function(selectedTab){
				
			};
        } 
	};
}]);
	
