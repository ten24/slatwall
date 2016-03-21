/// <reference path='../../../typings/hibachiTypescript.d.ts' />


class SWCollectionColumnController{
    constructor(){}
}

class SWCollectionColumn implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        hidden:"@?"
    };
    public controller=SWCollectionColumn;
    public controllerAs="swCollectionColumn";
    public template=""; 

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWCollectionColumn(
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
        
        console.log("scoop",scope)
        
        var column = {
                propertyIdentifier:scope.swTypeaheadSearchFilter.propertyIdentifier,
                hidden:scope.swTypeaheadSearchFilter.hidden
        };
    }
}
export{
    SWCollectionColumn,
    SWCollectionColumnController
}