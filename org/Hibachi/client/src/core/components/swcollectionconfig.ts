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
    public bindToController={
        entityName:"@",
        parentDirectiveControllerAsName:"@",
        collectionConfigProperty:"@?"
    };
    public controller=SWCollectionConfigController;
    public controllerAs="swCollectionConfig";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWCollectionConfig(
            utilityService
        );
        directive.$inject = [
            'utilityService'
        ];
        return directive;
    }
    
    //@ngInject
    constructor( 
        public collectionConfigService
    ){}

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, transclude:any) =>{

        if(angular.isUndefined(scope.swCollectionConfig.entityName)){
            throw("You must provide an entityname to swCollectionConfig");
        }
        
        if(angular.isUndefined(scope.swCollectionConfig.parentDirectiveControllerAsName)){
            throw("You must privde the parent directives Controller-As Name to swCollectionConfig");
        }
        
        if(angular.isUndefined(scope.swCollectionConfig.collectionConfigProperty)){
            scope.swCollectionConfig.collectionConfigProperty = "collectionConfig"; 
        }
        
        var newCollectionConfig = this.collectionConfigService.newCollectionConfig(scope.swCollectionConfig.entityName);
        var parentDirective = scope[scope.swCollectionConfig.parentDirectiveControllerAsName];
       
        //populate the columns and the filters
        transclude(scope,()=>{});
        
        angular.forEach(scope.swCollectionConfig.columns, (column)=>{
                newCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
        });
        angular.forEach(scope.swCollectionConfig.filters, (filter)=>{
                newCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 
        parentDirective[scope.swCollectionConfig.collectionConfigProperty] = newCollectionConfig;
        
    }
}
export{
    SWCollectionConfig,
    SWCollectionConfigController
}