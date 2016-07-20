/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWProductListingPagesController {

    public edit:boolean; 
    public selectedListingPageIdPaths:string; 
    public productID:string;
    public collectionConfig:any;
    
    //@ngInject
    constructor(
        private collectionConfigService 
    ){
        this.collectionConfig = collectionConfigService.newCollectionConfig("Content"); 
        this.collectionConfig.addDisplayProperty("contentID, title, activeFlag, site.siteName");
    }
}

class SWProductListingPages implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
        edit:"=?",
        selectedListingPageIdPaths:"@?",
        productId:"@?"
    };
    
    public controller=SWProductListingPagesController;
    public controllerAs="swProductListingPages";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            paginationService,
		    productPartialsPath,
			slatwallPathBuilder
        ) => new SWProductListingPages(
            $http,
            $hibachi,
            paginationService,
			productPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
			'productPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
		private $http,
        private $hibachi,
        private paginationService,
	    private productPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/productlistingpages.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWProductListingPagesController,
	SWProductListingPages
};
