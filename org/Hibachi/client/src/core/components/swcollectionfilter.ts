/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionFilterController{
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
    template

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWCollectionFilter(
            utilityService
        );
        directive.$inject = [
            'utilityService'
        ];
        return directive;
    }
    
    //@ngInject
    constructor(private utilityService){}

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        var filter = {
                propertyIdentifier:scope.SWCollectionFilter.propertyIdentifier,
                comparisonOperator:scope.SWCollectionFilter.comparisonOperator,
                comparisonValue:scope.SWCollectionFilter.comparisonValue,
                logicalOperator:scope.SWCollectionFilter.logicalOperator,
                hidden:scope.SWCollectionFilter.hidden
        };
       
        if(angular.isDefined(scope.swCollectionConfig)){ 
            scope.swCollectionConfig.filters.push(filter); 
        }
    }
}
export{
    SWCollectionFilterController,
    SWCollectionFilter
}