/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWProductBundleGroups{
    public static Factory(){
        var directive = (
            $http,
			$log,
			$hibachi,
			metadataService,
			productBundlePartialsPath,
			productBundleService,
			slatwallPathBuilder
        )=> new SWProductBundleGroups(
            $http,
			$log,
			$hibachi,
			metadataService,
			productBundlePartialsPath,
			productBundleService,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
			'$log',
			'$hibachi',
			'metadataService',
			'productBundlePartialsPath',
			'productBundleService',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        $http,
		$log,
		$hibachi,
		metadataService,
		productBundlePartialsPath,
		productBundleService,
	   slatwallPathBuilder
    ){
        return {
			restrict: 'EA',

			templateUrl:slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath)+"productbundlegroups.html",
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
                    if(angular.isDefined($scope.productBundleGroups[index])&&$scope.productBundleGroups[index].$$isPersisted()){ 
                        $scope.productBundleGroups[index].$$delete().then((data)=>{
                            //no more logic to run     
                        });
                    } 
                    $scope.productBundleGroups.splice(index,1);
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
