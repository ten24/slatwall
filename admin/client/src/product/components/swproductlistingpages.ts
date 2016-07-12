/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWProductListingPagesController {
    
    //@ngInject
    constructor(

    ){
        
    }
}

class SWProductListingPages implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
    };
    
    public controller=SWProductListingPagesController;
    public controllerAs="swProductListingPage";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            paginationService,
		    formBuilderPartialsPath,
			slatwallPathBuilder
        ) => new SWProductListingPages(
            $http,
            $hibachi,
            paginationService,
			formBuilderPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
			'formBuilderPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
		private $http,
        private $hibachi,
        private paginationService,
	    private formBuilderPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(formBuilderPartialsPath) + "/productlistingpages.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWProductListingPagesController,
	SWProductListingPages
};
