/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionConfigController{
    public filters = []; 
    public columns = []; 
    public collectionConfig;
    
    //@ngInject
    constructor(
        public collectionConfigService
    ){
        
    }
}

class SWCollectionConfig implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public transclude=true;
    public bindToController={
        entityName:"@",
        allRecords:"@?",
        parentDirectiveControllerAsName:"@",
        collectionConfigProperty:"@?"
    };
    public controller=SWCollectionConfigController;
    public controllerAs="swCollectionConfig";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            collectionConfigService
        )=>new SWCollectionConfig(
            collectionConfigService
        );
        directive.$inject = [
            'collectionConfigService'
        ];
        return directive;
    }
    
    //@ngInject
    constructor( 
        public collectionConfigService
    ){}

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: (scope: any, element: JQuery, attrs: angular.IAttributes) => {
                if(angular.isUndefined(scope.swCollectionConfig.entityName)){
                    throw("You must provide an entityname to swCollectionConfig");
                }
                
                if(angular.isUndefined(scope.swCollectionConfig.parentDirectiveControllerAsName)){
                    throw("You must privde the parent directives Controller-As Name to swCollectionConfig");
                }
                
                if(angular.isUndefined(scope.swCollectionConfig.collectionConfigProperty)){
                    scope.swCollectionConfig.collectionConfigProperty = "collectionConfig"; 
                }
                
                if(angular.isUndefined(scope.swCollectionConfig.allRecords)){
                    scope.swCollectionConfig.allRecords=false;
                }
                
                var newCollectionConfig = this.collectionConfigService.newCollectionConfig(scope.swCollectionConfig.entityName);
                newCollectionConfig.setAllRecords(scope.swCollectionConfig.allRecords);               
                
                var parentScope = scope.$parent;
                
                for(var tries = 0; tries < 3; tries++){
                    if(tries > 0){
                        var parentScope = parentScope.$parent;
                    }   
                    if(angular.isDefined(parentScope)){
                        var parentDirective = parentScope[scope.swCollectionConfig.parentDirectiveControllerAsName];
                    } 
                    if(angular.isDefined(parentDirective)){
                        break; 
                    }
                }   
               
                //populate the columns and the filters
                transclude(scope,()=>{});
                
                angular.forEach(scope.swCollectionConfig.columns, (column)=>{
                        newCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
                });
                angular.forEach(scope.swCollectionConfig.filters, (filter)=>{
                        newCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
                }); 
                if(angular.isDefined(parentDirective)){
                    parentDirective[scope.swCollectionConfig.collectionConfigProperty] = newCollectionConfig;
                }
            },
            post: (scope: any, element: JQuery, attrs: angular.IAttributes) => {}
        };
    }
}
export{
    SWCollectionConfig,
    SWCollectionConfigController
}