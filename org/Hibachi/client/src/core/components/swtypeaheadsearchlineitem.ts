/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWTypeaheadSearchLineItemController{
    constructor(){}
}

class SWTypeaheadSearchLineItem implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        comparisonOperator:"@?",
        comparisonValue:"@?",
        logicalOperator:"@?",
        hidden:"@?"
    };
    public controller=SWTypeaheadSearchLineItemController;
    public controllerAs="swTypeaheadSearchLineItem";
    public static $inject = ['utilityService'];

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWTypeaheadSearchLineItem(
            utilityService
        );
        directive.$inject = [
            'utilityService'
        ];
        return directive;
    }
    
    constructor(private utilityService){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        
        if( angular.isDefined(scope.swTypeaheadSearchLineItem.comparisonOperator) &&
            angular.isDefined(scope.swTypeaheadSearchLineItem.comparisonValue) 
        ){
           var filter = {
                    propertyIdentifier:scope.swTypeaheadSearchLineItem.propertyIdentifier,
                    comparisonOperator:scope.swTypeaheadSearchLineItem.comparisonOperator,
                    comparisonValue:scope.swTypeaheadSearchLineItem.comparisonValue,
                    logicalOperator:scope.swTypeaheadSearchLineItem.logicalOperator,
                    hidden:scope.swTypeaheadSearchLineItem.hidden
           };
        } 
        
        var uploaded = false; 
        
        if(angular.isDefined(scope.$parent.swTypeaheadSearch)){ 
            scope.$parent.swTypeaheadSearch.displayList.push(scope.swTypeaheadSearchLineItem.propertyIdentifier);
            if(angular.isDefined(filter)){
                scope.$parent.swTypeaheadSearch.filters.push(filter);
            }
        } 
        
        if(angular.isDefined(scope.$parent.swTypeaheadInputField)){
            scope.$parent.swTypeaheadInputField.displayList.push(scope.swTypeaheadSearchLineItem.propertyIdentifier);
            if(angular.isDefined(filter)){
                scope.$parent.swTypeaheadInputField.filters.push(filter);
            }
        }   
    }
}
export{
    SWTypeaheadSearchLineItem,
    SWTypeaheadSearchLineItemController
}