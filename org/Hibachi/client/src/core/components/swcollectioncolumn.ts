/// <reference path='../../../typings/hibachiTypescript.d.ts' />


class SWCollectionColumnController{
    constructor(){}
}

class SWCollectionColumn implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        isVisible:"@?",
        isSearchable:"@?",
        isDeletable:"@?",
        isExportable:"@?",
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
        
        var column = {
                propertyIdentifier:scope.swCollectionColumn.propertyIdentifier,
                isVisible:scope.swCollectionColumn.isVisible,
                isSearchable:scope.swCollectionColumn.isSearchable,
                isDeletable:scope.swCollectionColumn.isDeletable, 
                isExportable:scope.swCollectionColumn.isExportable,
                hidden:scope.swCollectionColumn.hidden
        };
        
        if(angular.isDefined(scope.swCollectionConfig)){ 
            scope.swCollectionConfig.columns.push(column); 
        }
    }
}
export{
    SWCollectionColumn,
    SWCollectionColumnController
}