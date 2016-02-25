/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormResponseListingController {
    
    private formId;
    
    //@ngInject
    constructor(
        
    ){
        
    }

}

class SWFormResponseListing implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
        "formId":"@"
    };
    
    public controller=SWFormResponseListingController;
    public controllerAs="swFormResponseListing";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $hibachi,
		    formBuilderPartialsPath,
			slatwallPathBuilder
        ) => new SWFormResponseListing(
            $hibachi,
			formBuilderPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
			'formBuilderPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
		private $hibachi,
	    private formBuilderPartialsPath,
		private slatwallPathBuilder
	){
        console.log("WE HAVE ARRIVED");
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(formBuilderPartialsPath) + "/formresponselisting.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWFormResponseListingController,
	SWFormResponseListing
};
