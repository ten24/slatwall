/// <reference path='../../../typings/hibachiTypescript.d.ts' />


class SWCollectionColumnController{
    constructor(){}
}

class SWCollectionColumn implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        fallbackPropertyIdentifiers:"@?",
        isVisible:"=?",
        isSearchable:"=?",
        isDeletable:"=?",
        isExportable:"=?",
        isKeywordColumn:"=?",
        isOnlyKeywordColumn:"=?",
        tdclass:"@?",
        hidden:"=?"
    };
    public controller=SWCollectionColumn;
    public controllerAs="swCollectionColumn";
    public template=""; 

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            scopeService, 
            utilityService
        )=>new SWCollectionColumn(
            scopeService, 
            utilityService
        );
        directive.$inject = [
            'scopeService',
            'utilityService'
        ];
        return directive;
    }
    
    //@ngInject
    constructor(private scopeService, private utilityService){}

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        
        if(angular.isUndefined(scope.swCollectionColumn.isKeywordColumn)){
            scope.swCollectionColumn.isKeywordColumn = false;
        }
        if(angular.isUndefined(scope.swCollectionColumn.isOnlyKeywordColumn)){
            scope.swCollectionColumn.isOnlyKeywordColumn = scope.swCollectionColumn.isKeywordColumn;
        }  
        if(angular.isUndefined(scope.swCollectionColumn.isVisible)){
            scope.swCollectionColumn.isVisible = true; 
        }
        if(angular.isUndefined(scope.swCollectionColumn.isSearchable)){
            scope.swCollectionColumn.isSearchable = false; 
        }
        if(angular.isUndefined(scope.swCollectionColumn.isDeletable)){
            scope.swCollectionColumn.isDeletable = false; 
        }
        if(angular.isUndefined(scope.swCollectionColumn.isExportable)){
            scope.swCollectionColumn.isExportable = true; 
        }

        var column = {
                propertyIdentifier:scope.swCollectionColumn.propertyIdentifier,
                fallbackPropertyIdentifiers:scope.swCollectionColumn.fallbackPropertyIdentifiers,
                isVisible:scope.swCollectionColumn.isVisible,
                isSearchable:scope.swCollectionColumn.isSearchable,
                isDeletable:scope.swCollectionColumn.isDeletable, 
                isExportable:scope.swCollectionColumn.isExportable,
                hidden:scope.swCollectionColumn.hidden,
                tdclass:scope.swCollectionColumn.tdclass,
                isKeywordColumn:scope.swCollectionColumn.isKeywordColumn, 
                isOnlyKeywordColumn:scope.swCollectionColumn.isOnlyKeywordColumn
        };

        
        var currentScope = this.scopeService.getRootParentScope(scope,"swCollectionConfig"); 
        
        if(angular.isDefined(currentScope.swCollectionConfig)){ 
            //push directly here because we've already built the column object
            currentScope.swCollectionConfig.columns.push(column); 
            currentScope.swCollectionConfig.columnsDeferred.resolve(); 
        } else {
            throw("Could not find swCollectionConfig in the parent scope from swcollectioncolumn");
        }
    }
}
export{
    SWCollectionColumn,
    SWCollectionColumnController
}
