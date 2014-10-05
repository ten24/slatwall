'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroups', 
['$http',
 '$log',
'productBundlePartialsPath',
function($http,
$log,
productBundlePartialsPath){
	return {
		restrict: 'A',
		templateUrl:productBundlePartialsPath+"productbundlegroups.html",
		scope:{
			productBundleGroups:"="
		},
		link: function(scope, element,attrs){
			$log.debug('productBundleGroups');
			$log.debug(scope.productBundleGroups);
			
			scope.removeProductBundleGroup = function(index){
				delete scope.productBundleGroups[index];
			};
		}
	};
}]);
	
