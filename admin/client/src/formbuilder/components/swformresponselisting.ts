/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormResponseListingController {
    
    private formId;
    private columns; 
    private pageRecords; 
    private paginator; 
    private dateFilter; 
    
    //@ngInject
    constructor(
        private $filter,
        private $http,
        private $hibachi,
        private paginationService,
        private requestService
    ){
        
        this.dateFilter = $filter("dateFilter");
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
        var exportFormResponseRequest = this.requestService.newAdminRequest(
            this.$hibachi.getUrlWithActionPrefix() + 'api:main.exportformresponses&formID=' + this.formId,
            {},
            'GET'
        ); 

        exportFormResponseRequest.promise.then((response)=>{
            var anchor = angular.element('<a/>');
            anchor.attr({
                href: 'data:attachment/csv;charset=utf-8,' + encodeURI(response),
                target: '_blank',
                download: 'formresponses' + this.formId + '.csv'
            })[0].click();
        });
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
            for(var i = 0; i < this.pageRecords.length; i++){
                if(angular.isDefined(this.pageRecords[i].createdDateTime)){
                    this.pageRecords[i].createdDateTime = this.dateFilter(this.pageRecords[i].createdDateTime,"MMM dd, yyyy - hh:mm a");
                }
            }
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
