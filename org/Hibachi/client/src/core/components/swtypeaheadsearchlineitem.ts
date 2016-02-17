/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWTypeaheadSearchLineItemController{

    constructor(

    ){
        this.init();
    }

    public init = () =>{

    }
}

class SWTypeaheadSearchLineItem implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@"
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
        if(angular.isDefined(scope.$parent.swTypeaheadSearch)){
            scope.$parent.swTypeaheadSearch.displayList.push(scope.swTypeaheadSearchLineItem.propertyIdentifier);
        }
    }
}
export{
    SWTypeaheadSearchLineItem,
    SWTypeaheadSearchLineItemController
}