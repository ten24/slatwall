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
				
				this.removeProductBundleGroup = function(index){
					$scope.productBundleGroups.splice(index,1);
					$log.debug("Deleting PBG #" + index);
					$log.debug($scope.productBundleGroups);
					
					
				};
				$scope.addProductBundleGroup = function(){
					var productBundleGroup = $scope.sku.$$addProductBundleGroup();
					productBundleService.decorateProductBundleGroup(productBundleGroup);
					
					$scope.sku.data.productBundleGroups.selectedProductBundleGroup = productBundleGroup;
				};
				
				
				
			}]
		};
	}
]);
	
