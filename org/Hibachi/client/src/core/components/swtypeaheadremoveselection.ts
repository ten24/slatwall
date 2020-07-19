/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadRemoveSelectionController {

    public listingId:string; 
    public pageRecord:any; 
    public typeaheadDataKey:string; 
    public disabled:boolean; 

    constructor(
        public $scope,
        public listingService,
        public scopeService, 
        public typeaheadService,
        public utilityService
    ){
        this.listingService.attachToListingPageRecordsUpdate(this.listingId, this.updatePageRecord, this.utilityService.createID(32));
        if(angular.isUndefined(this.disabled)){
            this.disabled = false; 
        }
    }

    public updatePageRecord = () =>{
        
        if(this.scopeService.hasParentScope(this.$scope, "pageRecord")) {
            var pageRecordScope = this.scopeService.getRootParentScope( this.$scope, "pageRecord")["pageRecord"];
            this.pageRecord = pageRecordScope;
        }
    }

    public removeSelection = () =>{
        if(!this.disabled){
            this.typeaheadService.removeSelection( this.typeaheadDataKey,
                                               undefined,
                                               this.pageRecord
                                             );
                                
            this.listingService.removeListingPageRecord(this.listingId,this.pageRecord)
        } 
    }
}

class SWTypeaheadRemoveSelection implements ng.IDirective{

    public transclude = true; 
	public restrict = "EA";
	
	public scope = {};
	public bindToController = {
        typeaheadDataKey:"@?",
        index:"@?", 
        disabled:"=?"
	};
	
	public controller=SWTypeaheadRemoveSelectionController;
	public controllerAs="swTypeaheadRemoveSelection";

    public template = require("./typeaheadremoveselection.html");

    // @ngInject
	constructor( private scopeService ){}

	public static Factory(){
		return /** @ngInject; */ (scopeService) => new this(scopeService);
	}

     public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) => {
        if(this.scopeService.hasParentScope(scope, "swListingDisplay")) {
            var listingDisplayScope = this.scopeService.getRootParentScope( scope, "swListingDisplay")["swListingDisplay"];
            scope.swTypeaheadRemoveSelection.typeaheadDataKey = listingDisplayScope.typeaheadDataKey;
            scope.swTypeaheadRemoveSelection.listingId = listingDisplayScope.tableID; 
        }
        if(this.scopeService.hasParentScope(scope, "pageRecord")) {
            var pageRecordScope = this.scopeService.getRootParentScope( scope, "pageRecord")["pageRecord"];
            scope.swTypeaheadRemoveSelection.pageRecord = pageRecordScope;
        }
     }
}
export{
	SWTypeaheadRemoveSelection,
	SWTypeaheadRemoveSelectionController
}