/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionConfigController{
    public filters = []; 
    public columns = []; 
    public collectionConfig:any;
    public collectionConfigProperty:string;
    public multiCollectionConfigProperty:string;
    
    public columnsDeferred; 
    public filtersDeferred; 
    public columnsPromise; 
    public filtersPromise; 
    
    //@ngInject
    constructor(
        public $transclude,
        public $q, 
        public collectionConfigService
    ){
        this.columnsDeferred = this.$q.defer();
        this.columnsPromise =  this.columnsDeferred.promise; 
        this.filtersDeferred = this.$q.defer(); 
        this.filtersPromise =  this.filtersDeferred.promise;
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
        allRecords:"=?",
        distinct:"=?",
        parentDirectiveControllerAsName:"@",
        collectionConfigProperty:"@?",
        multiCollectionConfigProperty:"@?",
        parentDeferredProperty:"@?"
    };
    public controller=SWCollectionConfigController;
    public controllerAs="swCollectionConfig";
    
    public template = ` 
        <div ng-transclude="columns"></div>
        <div ng-transclude="filters"></div>
    `

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            collectionConfigService,
            $q
        )=>new SWCollectionConfig(
            collectionConfigService,
            $q
        );
        directive.$inject = [
            'collectionConfigService',
            '$q'
        ];
        return directive;
    }
    
    // @ngInject
    constructor( 
        public collectionConfigService,
        public $q
    ){

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
            if(angular.isUndefined(scope.swCollectionConfig.distinct)){
                scope.swCollectionConfig.distinct=false;
            }
            
            var allCollectionConfigPromises = [];
            
            var currentScope = scope; 
            //we want to wait for all sibling scopes before pushing the collection config
            while(angular.isDefined(currentScope)){
                if(angular.isDefined(currentScope.swCollectionConfig)){
                    allCollectionConfigPromises.push(currentScope.swCollectionConfig.columnsPromise);
                    allCollectionConfigPromises.push(currentScope.swCollectionConfig.filtersPromise);  
                }
                currentScope = currentScope.$$nextSibling;  
                if(currentScope == null){
                    break; 
                }
            }

            var newCollectionConfig = this.collectionConfigService.newCollectionConfig(scope.swCollectionConfig.entityName);
            newCollectionConfig.setAllRecords(scope.swCollectionConfig.allRecords);   
            newCollectionConfig.setDistinct(scope.swCollectionConfig.distinct);            
            
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
            scope.swCollectionConfig.columnsPromise.then(()=>{
                angular.forEach(scope.swCollectionConfig.columns, (column)=>{
                    newCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
                });
            }); 
            scope.swCollectionConfig.filtersPromise.then(()=>{
                angular.forEach(scope.swCollectionConfig.filters, (filter)=>{
                    newCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
                }); 
            });
            this.$q.all(allCollectionConfigPromises).then(()=>{
                if(angular.isDefined(parentDirective)){
                    if(angular.isDefined(scope.swCollectionConfig.multiCollectionConfigProperty) 
                        && angular.isDefined(parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty])
                    ){
                        parentDirective[scope.swCollectionConfig.multiCollectionConfigProperty].push(newCollectionConfig); 
                    } else if(angular.isDefined(parentDirective[scope.swCollectionConfig.collectionConfigProperty])) {
                        parentDirective[scope.swCollectionConfig.collectionConfigProperty] = newCollectionConfig;
                    } else { 
                        throw("swCollectionConfig could not locate a collection config property to bind it's collection to");
                    } 
                    if(angular.isDefined(parentDirective[scope.swCollectionConfig.parentDeferredProperty])){
                        parentDirective[scope.swCollectionConfig.parentDeferredProperty].resolve();
                    } else {
                        throw("cannot resolve rule")
                    }
                } 
            });       
        }
    }
   
export{
    SWCollectionConfig,
    SWCollectionConfigController
}