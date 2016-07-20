/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWAssignedProductsController {

    public collectionConfig; 
    public contentId:string; 
    public typeaheadDataKey:string; 
    
    //@ngInject
    constructor(
        private collectionConfigService,
        private utilityService
    ){
        this.collectionConfig = collectionConfigService.newCollectionConfig("Product"); 
        this.collectionConfig.addDisplayProperty("productID,productName,productDescription");
        this.typeaheadDataKey = utilityService.createID(32); 
    }
}

class SWAssignedProducts implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
        contentId:"@?"
    };
    
    public controller=SWAssignedProductsController;
    public controllerAs="swAssignedProducts";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            paginationService,
		    contentPartialsPath,
			slatwallPathBuilder
        ) => new SWAssignedProducts(
            $http,
            $hibachi,
            paginationService,
			contentPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
			'contentPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
		private $http,
        private $hibachi,
        private paginationService,
	    private contentPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "/assignedproducts.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWAssignedProductsController,
	SWAssignedProducts
};
