'use strict';
angular.module('slatwalladmin')
.directive('swRbkey', 
[
'$slatwall',
'$rootScope',
'$compile',
function(
	$slatwall,
	$rootScope,
	$compile
){
	return {
		restrict: 'A',
		scope:{
			swRbkey:"="
		},
		link: function(scope, element,attrs){
			var rbKeyValue = scope.swRbkey;
			
			console.log('running rbkey');
			console.log(rbKeyValue);
			if(angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)){
				console.log($slatwall.getRBKey(rbKeyValue));
				element.text($slatwall.getRBKey(rbKeyValue));
			}
			
			var hasResourceBundleListener = $rootScope.$on('hasResourceBundle',function(event,data){
				console.log('received event');
				console.log(rbKeyValue);
			//	console.log($slatwall.getRBKey(rbKeyValue));
				if(angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)){
					console.log($slatwall.getRBKey(rbKeyValue));
					element.text($slatwall.getRBKey(rbKeyValue));
				}
				hasResourceBundleListener();
			});
		}
	};
}]);
	
