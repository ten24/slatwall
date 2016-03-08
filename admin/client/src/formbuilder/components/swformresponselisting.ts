/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormResponseListingController {
    
    private formId;
    private columns; 
    private pageRecords; 
    private paginator; 
    
    //@ngInject
    constructor(
        private $http,
        private $hibachi,
        private paginationService
    ){
        this.init();
    }
    
    init = () => {   
        if(angular.isUndefined(this.formId)){
            throw("Form ID is required for swFormResponseListing");
        }
        
        this.paginator = this.paginationService.createPagination();
        this.paginator.getCollection = this.updateFormResponses;
        
        this.updateFormResponses(); 
    }
    
    export = () => {
        $('body').append('<form action="' 
              + this.$hibachi.getUrlWithActionPrefix() 
              + 'api:main.exportformresponses&formID=' + this.formId  
              + '" method="post" id="formExport"></form>');
              
        $('#formExport')
            .submit()
            .remove();
    }
    
    updateFormResponses = () => {
        var formResponsesRequestUrl = this.$hibachi.getUrlWithActionPrefix() + "api:main.getformresponses&formID=" + this.formId;
   
        var params:any = {};      
        params.currentPage = this.paginator.currentPage || 1;
        params.pageShow = this.paginator.pageShow || 10;
        
        var formResponsesPromise = this.$http({
            method: 'GET',
            url: formResponsesRequestUrl,
            params: params
        });
        
        formResponsesPromise.then((response)=>{
            this.columns = response.data.columnRecords; 
            this.pageRecords = response.data.pageRecords; 
            this.paginator.recordsCount = response.data.recordsCount;
            this.paginator.totalPages = response.data.totalPages;
            this.paginator.pageStart = response.data.pageRecordsStart; 
            this.paginator.pageEnd = response.data.pageRecordsEnd;
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
            paginationService,
		    formBuilderPartialsPath,
			slatwallPathBuilder
        ) => new SWFormResponseListing(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(formBuilderPartialsPath) + "/formresponselisting.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWFormResponseListingController,
	SWFormResponseListing
};
