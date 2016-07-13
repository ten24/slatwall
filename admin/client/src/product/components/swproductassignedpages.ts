/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWProductAssignedPagesController {
    
    //@ngInject
    constructor(

    ){
        
    }
}

class SWProductAssignedPages implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
    };
    
    public controller=SWProductAssignedPagesController;
    public controllerAs="swProductAssignedPages";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            paginationService,
		    productPartialsPath,
			slatwallPathBuilder
        ) => new SWProductAssignedPages(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/productassignedpages.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWProductAssignedPagesController,
	SWProductAssignedPages
};
