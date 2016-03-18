/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWTypeaheadSearchFilterController{
    constructor(){}
}

class SWTypeaheadSearchFilter implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        comparisonOperator:"@?",
        comparisonValue:"@?",
        logicalOperator:"@?",
        hidden:"@?"
    };
    public controller=SWTypeaheadSearchFilterController;
    public controllerAs="swTypeaheadSearchFilter";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWTypeaheadSearchFilter(
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
                propertyIdentifier:scope.swTypeaheadSearchFilter.propertyIdentifier,
                comparisonOperator:scope.swTypeaheadSearchFilter.comparisonOperator,
                comparisonValue:scope.swTypeaheadSearchFilter.comparisonValue,
                logicalOperator:scope.swTypeaheadSearchFilter.logicalOperator,
                hidden:scope.swTypeaheadSearchFilter.hidden
        };
        
        if(angular.isDefined(scope.$parent.swTypeaheadSearch)){ 
            if(angular.isDefined(filter)){
                scope.$parent.swTypeaheadSearch.filters.push(filter);
            }
        } 
        
        if(angular.isDefined(scope.$parent.swTypeaheadInputField)){
            if(angular.isDefined(filter)){
                scope.$parent.swTypeaheadInputField.filters.push(filter);
            }
        }   
    }
}
export{
    SWTypeaheadSearchFilter,
    SWTypeaheadSearchFilterController
}