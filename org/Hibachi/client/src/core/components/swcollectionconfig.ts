/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionConfigController{
    public filters = []; 
    public columns = []; 
    public collectionConfig:any;
    public collectionConfigProperty:string;
    public multiCollectionConfigProperty:string;
    
    //@ngInject
    constructor(
        public $transclude,
        public collectionConfigService
    ){
        console.log("multiccCONST2")
    }
}

class SWCollectionConfig implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public transclude={
        columns:"?swCollectionColumns",
        filters:"?swCollectionFilters"
    };
    public priority=1000;
    public bindToController={
        entityName:"@",
        allRecords:"@?",
        parentDirectiveControllerAsName:"@",
        collectionConfigProperty:"@?",
        multiCollectionConfigProperty:"@?"
    };
    public controller=SWCollectionConfigController;
    public controllerAs="swCollectionConfig";
    
    public template = ` 
        <div ng-transclude="columns"></div>
        <div ng-transclude="filters"></div>
    `

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
    
    // @ngInject
    constructor( 
        public collectionConfigService
    ){
        console.log("multiccCONST1")
    }

    public link = (scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
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
            
            for(var tries = 0; tries < 6; tries++){
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
            //this.$transclude(scope,()=>{});
            
            angular.forEach(scope.swCollectionConfig.columns, (column)=>{
                    newCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
            });
            angular.forEach(scope.swCollectionConfig.filters, (filter)=>{
                    newCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
            }); 
            if(angular.isDefined(parentDirective)){
                console.log("multicc?", (angular.isDefined(scope.swCollectionConfig.multiCollectionConfigProperty) 
                    && angular.isDefined(parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty])
                ));
                if(angular.isDefined(scope.swCollectionConfig.multiCollectionConfigProperty) 
                    && angular.isDefined(parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty])
                ){
                    console.log("multicc pushing to", parentDirective)
                    parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty].push(newCollectionConfig); 
                } else if(angular.isDefined(parentDirective[scope.swCollectionConfig.collectionConfigProperty])) {
                    parentDirective[scope.swCollectionConfig.collectionConfigProperty] = newCollectionConfig;
                } else { 
                    throw("swCollectionConfig could not locate a collection config property to bind it's collection to");
                }
            }
            
        }
    }
   
export{
    SWCollectionConfig,
    SWCollectionConfigController
}