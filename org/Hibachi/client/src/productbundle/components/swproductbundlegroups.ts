/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
class SWProductBundleGroups{
    public static Factory(){
        var directive = (
            $http,
			$log,
			$slatwall,
			metadataService,
			productBundlePartialsPath,
			productBundleService,
			pathBuilderConfig
        )=> new SWProductBundleGroups(
            $http,
			$log,
			$slatwall,
			metadataService,
			productBundlePartialsPath,
			productBundleService,
			pathBuilderConfig
        );
        directive.$inject = [
            '$http',
			'$log',
			'$slatwall',
			'metadataService',
			'productBundlePartialsPath',
			'productBundleService',
			'pathBuilderConfig'
        ];
        return directive;
    }
    constructor(
        $http,
		$log,
		$slatwall,
		metadataService,
		productBundlePartialsPath,
		productBundleService,
			pathBuilderConfig
    ){
        return {
			restrict: 'EA',

			templateUrl:pathBuilderConfig.buildPartialsPath(productBundlePartialsPath)+"productbundlegroups.html",
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

					var productBundleGroup = $scope.sku.$$addProductBundleGroup();

					productBundleService.decorateProductBundleGroup(productBundleGroup);

					$scope.sku.data.productBundleGroups.selectedProductBundleGroup = productBundleGroup;
				};
			}]
		};
    }
}
export{
    SWProductBundleGroups
}
