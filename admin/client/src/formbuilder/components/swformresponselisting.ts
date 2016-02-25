/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormResponseListingController {
    
    private formId;
    private columns; 
    private pageRecords; 
    
    //@ngInject
    constructor(
        private $http,
        private $hibachi
    ){
        this.init();
    }
    
    init = () => { 
        
        if(angular.isUndefined(this.formId)){
            throw("Form ID is required for swFormResponseListing");
        }
        
        var formResponsesRequestUrl = this.$hibachi.getUrlWithActionPrefix() + "api:main.getformresponses&formID=" + this.formId;
        
        var formResponsesPromise = this.$http({
            method: 'GET',
            url: formResponsesRequestUrl
        });
        
        formResponsesPromise.then((response)=>{
            console.log("Form Responses: ", response);
            this.columns = response.data.columnRecords; 
            this.pageRecords = response.data.pageRecords; 
        }, (response)=>{
            throw("There was a problem collecting the form responses");
        });
        
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
            $http,
            $hibachi,
		    formBuilderPartialsPath,
			slatwallPathBuilder
        ) => new SWFormResponseListing(
            $http,
            $hibachi,
			formBuilderPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
			'formBuilderPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
		private $http,
        private $hibachi,
	    private formBuilderPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(formBuilderPartialsPath) + "/formresponselisting.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWFormResponseListingController,
	SWFormResponseListing
};
