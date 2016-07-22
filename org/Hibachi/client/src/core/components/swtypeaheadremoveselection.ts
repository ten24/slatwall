/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadRemoveSelectionController {

    public index;
    public tableID:string; 
    public typeaheadDataKey:string; 

    constructor(
        public typeaheadService
    ){
        
    }

    public removeSelection = () =>{
        this.typeaheadService.removeSelection(this.typeaheadDataKey,this.index);
    }
}

class SWTypeaheadRemoveSelection implements ng.IDirective{

	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};

	public bindToController = {
        typeaheadDataKey:"@?",
        index:"@?"
	};
	public controller=SWTypeaheadRemoveSelectionController;
	public controllerAs="swTypeaheadRemoveSelection";

    // @ngInject
	constructor( private scopeService, 
                 private corePartialsPath,
                 hibachiPathBuilder
    ){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadremoveselection.html";
	}

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
            scopeService
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadRemoveSelection(
            scopeService
            ,corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["scopeService","corePartialsPath",'hibachiPathBuilder'];
		return directive;
	}

     public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        if(this.scopeService.hasParentScope(scope, "swListingDisplay")) {
            var listingDisplayScope = this.scopeService.locateParentScope( scope, "swListingDisplay")["swListingDisplay"];
            scope.swTypeaheadRemoveSelection.typeaheadDataKey = listingDisplayScope.typeaheadDataKey;
            scope.swTypeaheadRemoveSelection.listingId = listingDisplayScope.tableID; 
        }
     }
}
export{
	SWTypeaheadRemoveSelection,
	SWTypeaheadRemoveSelectionController
}