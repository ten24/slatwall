/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/* SwListingDisableRule
 * defines a filter, by which to determine what rows will be disabled
 */

class SWListingDisableRuleController{

    public filterPropertyIdentifier:string;
    public filterComparisonOperator:string; 
    public filterComparisonValue:string;

    //@ngInject
    constructor(
        public $q
    ){

    }

}

class SWListingDisableRule implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public template=`
        
    `
    public bindToController={
        filterPropertyIdentifier:"@",
        filterComparisonOperator:"@",
        filterComparisonValue:"@"        
    };
    public controller=SWListingDisableRuleController;
    public controllerAs="swListingDisableRule";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $q
        )=>new SWListingDisableRule(
            $q
        );
        directive.$inject = [
            '$q'
        ];
        return directive;
    }
    constructor(private $q){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
         scope.SwListingDisableRule.hasChildrenCollectionConfigPromise.then(()=>{
                var rule = {
                    filterPropertyIdentifier:scope.SwListingDisableRule.filterPropertyIdentifier,
                    filterComparisonOperator:scope.SwListingDisableRule.filterComparisonOperator, 
                    filterComparisonValue:scope.SwListingDisableRule.filterComparisonValue
                };
                
                //TEMP OVERRIDES for TEMP multilisting directive
                if(angular.isDefined(scope.$parent.$parent.swMultiListingDisplay)){
                    var listingDisplayScope = scope.$parent.$parent.swMultiListingDisplay;
                }else if(angular.isDefined(scope.$parent.swListingDisplay)){
                    var listingDisplayScope = scope.$parent.swListingDisplay;
                }
                
                if(angular.isDefined(listingDisplayScope)){
                    listingDisplayScope.disableRules.push(rule); 
                } else {
                    throw("listing display scope not available to sw-listing-expandable-rule");
                }
         });
    }
}
export{
    SWListingDisableRule
}