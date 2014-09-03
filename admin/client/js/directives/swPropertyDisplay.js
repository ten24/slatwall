angular.module('slatwalladmin')
.directive('swPropertyDisplay', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
partialsPath,
$log){
	return {
		restrict: 'A',
		scope:{
			object:"=",
			property:"@",
			isEditable:"="
		},
		link: function(scope, element,attrs){
			$log.debug(scope.object);
			$log.debug(scope.property);
			$log.debug(scope.isEditable);
			var Partial = partialsPath+"propertyDisplay.html";
			var templateLoader = $http.get(Partial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		}
	};
}]);
	
