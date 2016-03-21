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
            $compile
        )=>new SWTypeaheadSearchLineItem(
            $compile
        );
        directive.$inject = [
            '$compile'
        ];
        return directive;
    }
    
    //@ngInject
    constructor(private $compile){}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: (scope: any, element: JQuery, attrs: angular.IAttributes) => {
                console.log("scoopelement", element)
                var innerHTML = '<span ng-bind="item.' + scope.swTypeaheadSearchLineItem.propertyIdentifier + '"></span>';
                element.append(innerHTML);
                
                //below is deprecated code pre dates swCollection, swCollectionFilter, and swCollectionColumn
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
            },
            post: (scope: any, element: JQuery, attrs: angular.IAttributes) => {}
        };
    }
}
export{
    SWTypeaheadSearchLineItem,
    SWTypeaheadSearchLineItemController
}