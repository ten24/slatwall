'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroups', 
['$http',
 '$log',
'productBundlePartialsPath',
'productBundleService',
function($http,
$log,
productBundlePartialsPath,
productBundleService){
	return {
		restrict: 'A',
		templateUrl:productBundlePartialsPath+"productbundlegroups.html",
		scope:{
			productBundleGroups:"=" 
		},
		controller: function($scope, $element,$attrs){
			$log.debug('productBundleGroups');
			$log.debug($scope.productBundleGroups);
			
			this.removeProductBundleGroup = function(index){
				//delete $scope.productBundleGroups[index];
				$scope.productBundleGroups.splice(index,1);
			};
			
		}
	};
}]);
	
