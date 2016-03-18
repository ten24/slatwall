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
        isSearchable:"@?",
    };
    public controller=SWTypeaheadSearchLineItemController;
    public controllerAs="swTypeaheadSearchLineItem";

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
    
    //@ngInject
    constructor(private utilityService){}

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
           
        var column = {
                propertyIdentifier:scope.swTypeaheadSearchLineItem.propertyIdentifier,
                isSearchable:scope.swTypeaheadSearchLineItem.isSearchable
        };
           
        if(angular.isDefined(scope.$parent.swTypeaheadSearch)){ 
            scope.$parent.swTypeaheadSearch.columns.push(column);
        } 
        
        if(angular.isDefined(scope.$parent.swTypeaheadInputField)){
            scope.$parent.swTypeaheadInputField.columns.push(column);
        }   
    }
}
export{
    SWTypeaheadSearchLineItem,
    SWTypeaheadSearchLineItemController
}