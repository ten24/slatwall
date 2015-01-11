'use strict';
angular.module('slatwalladmin')
.directive('swRbkey', 
[
'$slatwall',
'$rootScope',
function(
	$slatwall,
	$rootScope
){
	return {
		restrict: 'A',
		link: function(scope, element,attrs){
			var rbKeyValue = attrs.swRbkey;
			console.log('running rbkey');
			element.text($slatwall.getRBKey(rbKeyValue));
			var hasResourceBundleListener = $rootScope.$on('hasResourceBundle',function(event,data){
				console.log('received event');
				console.log(rbKeyValue);
				console.log($slatwall.getRBKey(rbKeyValue));
				element.text($slatwall.getRBKey(rbKeyValue));
				hasResourceBundleListener();
			});
		}
	};
}]);
	
