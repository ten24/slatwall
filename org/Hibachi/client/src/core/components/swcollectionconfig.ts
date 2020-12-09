/// <reference path='../../../typings/hibachiTypescript.d.ts' />

class SWCollectionConfigController{
    public filters = []; 
    public columns = []; 
    public orderBys = [];
    public keywordColumns = [];
    public collectionConfig:any;
    public collectionConfigProperty:string;
    public multiCollectionConfigProperty:string;
    
    public columnsDeferred;
    public filtersDeferred;
    public orderBysDeferred;
    public columnsPromise;
    public filtersPromise;
    public orderBysPromise;

    
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
        this.orderBysDeferred = this.$q.defer();
        this.orderBysPromise =  this.columnsDeferred.promise;
    }
}

class SWCollectionConfig implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public transclude={
        columns:"?swCollectionColumns",
        filters:"?swCollectionFilters",
        orderBys:"?swCollectionOrderBys"
    };
    public bindToController={
        allRecords:"=?",
        collectionConfigProperty:"@?",
        distinct:"=?",
        entityName:"@",
        filterFlag:"=?",//lets swCollectionConfig know that it needs to wait for 
        inListingDisplay:"=?",
        multiCollectionConfigProperty:"@?",
        pageShow:"@?",
        parentDirectiveControllerAsName:"@?",
        parentDeferredProperty:"@?"
    };
    public controller=SWCollectionConfigController;
    public controllerAs="swCollectionConfig";
    
    public template = ` 
        <div ng-transclude="columns"></div>
        <div ng-transclude="filters"></div>
        <div ng-transclude="orderBys"></div>
    `

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            collectionConfigService,
            listingService, 
            scopeService,
            $q
        )=>new SWCollectionConfig(
            collectionConfigService,
            listingService, 
            scopeService,
            $q
        );
        directive.$inject = [
            'collectionConfigService',
            'listingService',
            'scopeService',
            '$q'
        ];
        return directive;
    }
    
    // @ngInject
    constructor( 
        public collectionConfigService,
        public listingService, 
        public scopeService,
        public $q
    ){

    }

    public link = (scope: any, element: JQuery, attrs: angular.IAttributes) => {
            //some automatic configuration for listing display
            if( angular.isUndefined(scope.swCollectionConfig.inListingDisplay)){
                scope.swCollectionConfig.inListingDisplay = false; 
            }
            if( scope.swCollectionConfig.inListingDisplay ){
                scope.swCollectionConfig.parentDirectiveControllerAsName = "swListingDisplay";
                scope.swCollectionConfig.parentDeferredProperty = "singleCollectionDeferred";
            }   
            if(angular.isUndefined(scope.swCollectionConfig.entityName)){
                throw("You must provide an entityname to swCollectionConfig");
            }
            if(angular.isUndefined(scope.swCollectionConfig.parentDirectiveControllerAsName) && !scope.swCollectionConfig.inListingDisplay){
                throw("You must provide the parent directives Controller-As Name to swCollectionConfig");
            }
            if(angular.isUndefined(scope.swCollectionConfig.collectionConfigProperty)){
                scope.swCollectionConfig.collectionConfigProperty = "collectionConfig"; 
            }
            if(angular.isUndefined(scope.swCollectionConfig.allRecords)){
                scope.swCollectionConfig.allRecords=false;
            }
            if(angular.isUndefined(scope.swCollectionConfig.pageShow)){
                scope.swCollectionConfig.pageShow=10;
            }
            if(angular.isUndefined(scope.swCollectionConfig.distinct)){
                scope.swCollectionConfig.distinct=false;
            }
            if(angular.isUndefined(scope.swCollectionConfig.filterFlag)){
                scope.swCollectionConfig.filterFlag=true;//assume there are filters
            }
            
            var allCollectionConfigPromises = [];
            
            var currentScope = scope; 
            //we want to wait for all sibling scopes before pushing the collection config
            while(angular.isDefined(currentScope)){
                if(angular.isDefined(currentScope.swCollectionConfig)){
                    allCollectionConfigPromises.push(currentScope.swCollectionConfig.columnsPromise);
                    if(scope.swCollectionConfig.filterFlag){
                        allCollectionConfigPromises.push(currentScope.swCollectionConfig.filtersPromise);  
                    }
                }
                currentScope = currentScope.$$nextSibling;  
                if(currentScope == null){
                    break; 
                }
            }

            var newCollectionConfig = this.collectionConfigService.newCollectionConfig(scope.swCollectionConfig.entityName);
            newCollectionConfig.setAllRecords(scope.swCollectionConfig.allRecords);   
            newCollectionConfig.setDistinct(scope.swCollectionConfig.distinct);            
            newCollectionConfig.setPageShow(scope.swCollectionConfig.pageShow);

            var currentScope = this.scopeService.getRootParentScope(scope, scope.swCollectionConfig.parentDirectiveControllerAsName);
            
            if(currentScope[scope.swCollectionConfig.parentDirectiveControllerAsName]){
                var parentDirective = currentScope[scope.swCollectionConfig.parentDirectiveControllerAsName];
            } else {
                throw("swCollectionConfig was unable to find a parent scope");
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

            scope.swCollectionConfig.orderBysPromise.then(()=>{
                angular.forEach(scope.swCollectionConfig.orderBys, (orderBy)=>{

                    newCollectionConfig.addOrderBy(orderBy);
                });
            });

            this.$q.all(allCollectionConfigPromises).then(
                ()=>{
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
                            //throw("SWCollectionConfig cannot resolve rule");
                        }
                    } 
                },(reason)=>{
                    throw("SWCollectionConfig is having some issues.");
                }
                
            );       
        }
    }
   
export{
    SWCollectionConfig,
    SWCollectionConfigController
}
