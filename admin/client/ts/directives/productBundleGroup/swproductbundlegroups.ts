'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroups', [
	'$http',
	'$log',
	'$slatwall',
	'metadataService',
	'productBundlePartialsPath',
	'productBundleService',
	function(
		$http,
		$log,
		$slatwall,
		metadataService,
		productBundlePartialsPath,
		productBundleService
	){
		return {
			restrict: 'EA',
			
			templateUrl:productBundlePartialsPath+"productbundlegroups.html",
			scope:{
				sku:"=",
				productBundleGroups:"=",
				addProductBundleGroup:"&"
			},
			controller: ['$scope','$element','$attrs',function($scope, $element,$attrs){
				$scope.$id = 'productBundleGroups';
				$log.debug('productBundleGroups');
				$log.debug($scope.productBundleGroups);
				$scope.editing = $scope.editing || true;
				angular.forEach($scope.productBundleGroups,function(obj){
					productBundleService.decorateProductBundleGroup(obj);
					obj.data.$$editing = false;
				});
				
				$scope.removeProductBundleGroup = function(index){
					$scope.productBundleGroups.splice(index,1);
					$log.debug("Deleting PBG #" + index);
					$log.debug($scope.productBundleGroups);
					
					
				};
				$scope.addProductBundleGroup = function(){
					$log.debug("LOOKY LOOKY HERE HERE");
					
					var productBundleGroup = $scope.sku.$$addProductBundleGroup();
					$log.debug(productBundleGroup.data);
					
					productBundleService.decorateProductBundleGroup(productBundleGroup);

					$log.debug(productBundleGroup.data);
					
					$scope.sku.data.productBundleGroups.selectedProductBundleGroup = productBundleGroup;
				};
				
				
				
			}]
		};
	}
]);
	