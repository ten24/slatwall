/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWProductBundleGroupsController{

    public sku;
    public productBundleGroups;

    //@ngInject
    constructor(public $scope,
                public $element,
                public $attrs,
                public $log,
                public productBundleService,
                public $hibachi
    ){
        $scope.editing = $scope.editing || true;

        angular.forEach(this.productBundleGroups,(obj)=>{
            productBundleService.decorateProductBundleGroup(obj);
            obj.data.$$editing = false;
        });
    }

    public removeProductBundleGroup = (index)=>{
        if(angular.isDefined(this.productBundleGroups[index]) && this.productBundleGroups[index].$$isPersisted()){
            this.productBundleGroups[index].$$delete().then((data)=>{
                //no more logic to run
            });
        }
        this.productBundleGroups.splice(index,1);
    }

    public addProductBundleGroup = () =>{
        var productBundleGroup = this.$hibachi.newProductBundleGroup();



        productBundleGroup.$$setProductBundleSku(this.sku);

        productBundleGroup = this.productBundleService.decorateProductBundleGroup(productBundleGroup);

    }

}


class SWProductBundleGroups implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {
        sku:"=",
        productBundleGroups:"="
    };
    public bindToController = {
        sku:"=",
        productBundleGroups:"="
    };
    public controller = SWProductBundleGroupsController;
    public controllerAs="swProductBundleGroups";


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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath)+"productbundlegroups.html";
    }
}
export{
    SWProductBundleGroups,
    SWProductBundleGroupsController
}
