/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/* SWListingExpandableRule
 * defines a filter, by which to determine what will be expanded
 * supplies the collection config and any other necessary rules for what will be loaded and displayed
 */

class SWListingExpandableRuleController{

    public filterPropertyIdentifier:string;
    public filterComparisonOperator:string; 
    public filterComparisonValue:string;
    public refreshChildrenEvent:string; 
    
    public hasChildrenCollectionConfigDeferred;
    public hasChildrenCollectionConfigPromise; 
    public childrenCollectionConfig;

    //@ngInject
    constructor(
        public $q
    ){
        this.hasChildrenCollectionConfigDeferred = $q.defer(); 
        this.hasChildrenCollectionConfigPromise = this.hasChildrenCollectionConfigDeferred.promise;
        //why did I need this? 
        this.childrenCollectionConfig = null;
    }

}

class SWListingExpandableRule implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public transclude={
        collectionConfig:"?swConfig"    
    };
    public template=`
        <div ng-transclude="collectionConfig"></div> 
    `
    public bindToController={
        childrenCollectionConfig:"=?",
        filterPropertyIdentifier:"@",
        filterComparisonOperator:"@",
        filterComparisonValue:"@",
        refreshChildrenEvent:"@?"    
    };
    public controller=SWListingExpandableRuleController;
    public controllerAs="swListingExpandableRule";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            scopeService,
            $q
        )=>new SWListingExpandableRule(
            scopeService,
            $q
        );
        directive.$inject = [
            'scopeService',
            '$q'
        ];
        return directive;
    }
    constructor(private scopeService, private $q){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
         scope.swListingExpandableRule.hasChildrenCollectionConfigPromise.then(()=>{
                var rule = {
                    filterPropertyIdentifier:scope.swListingExpandableRule.filterPropertyIdentifier,
                    filterComparisonOperator:scope.swListingExpandableRule.filterComparisonOperator, 
                    filterComparisonValue:scope.swListingExpandableRule.filterComparisonValue,
                    childrenCollectionConfig:scope.swListingExpandableRule.childrenCollectionConfig,
                    refreshChildrenEvent:scope.swListingExpandableRule.refreshChildrenEvent
                };
                
                var listingDisplayScope = this.scopeService.getRootParentScope(scope,"swListingDisplay");
                if(angular.isDefined(listingDisplayScope.swListingDisplay)){
                    listingDisplayScope = listingDisplayScope.swListingDisplay;
                }else {
                    throw("listing display scope not available to sw-listing-expandable-rule");
                }
                
                listingDisplayScope.expandableRules.push(rule); 
         });
    }
}
export{
    SWListingExpandableRule
}
