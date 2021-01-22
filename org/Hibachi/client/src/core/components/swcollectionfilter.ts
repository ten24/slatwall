/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionFilterController{
    // @ngInject;
    constructor(){}
}

class SWCollectionFilter implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        comparisonOperator:"@?",
        comparisonValue:"@?",
        logicalOperator:"@?",
        hidden:"@?"
    };
    public controller=SWCollectionFilterController;
    public controllerAs="SWCollectionFilter";
    public template = "";

    public static Factory(){
        return /** @ngInject; */ (scopeService, utilityService ) => new this( scopeService, utilityService);
    }
    
    //@ngInject
    constructor(private scopeService, private utilityService){}

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        var filter = {
                propertyIdentifier:scope.SWCollectionFilter.propertyIdentifier,
                comparisonOperator:scope.SWCollectionFilter.comparisonOperator,
                comparisonValue:scope.SWCollectionFilter.comparisonValue,
                logicalOperator:scope.SWCollectionFilter.logicalOperator,
                hidden:scope.SWCollectionFilter.hidden
        };
        var currentScope = this.scopeService.getRootParentScope(scope, "swCollectionConfig");
       
        if(angular.isDefined(currentScope.swCollectionConfig)){ 
            currentScope.swCollectionConfig.filters.push(filter); 
            currentScope.swCollectionConfig.filtersDeferred.resolve(); 
        } else { 
            throw("could not find swCollectionConfig in the parent scope from swcollectionfilter");
        }
    }
}
export{
    SWCollectionFilterController,
    SWCollectionFilter
}