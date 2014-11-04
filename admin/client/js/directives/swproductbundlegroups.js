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
			addProductBundleGroup:"&"
		},
		controller: function($scope, $element,$attrs){
			$scope.$id = 'productBundleGroups';
			$log.debug('productBundleGroups');
			$log.debug($scope.productBundleGroups);
			
			this.removeProductBundleGroup = function(index){
				//delete $scope.productBundleGroups[index];
				$scope.productBundleGroups.splice(index,1);
			};
			
		}
	};
}]);
	
