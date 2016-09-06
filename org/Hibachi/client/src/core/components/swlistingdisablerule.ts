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
            scopeService,
            $q
        )=>new SWListingDisableRule(
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
        var rule = {
            filterPropertyIdentifier:scope.swListingDisableRule.filterPropertyIdentifier,
            filterComparisonOperator:scope.swListingDisableRule.filterComparisonOperator, 
            filterComparisonValue:scope.swListingDisableRule.filterComparisonValue
        };
        
<<<<<<< HEAD
        var listingDisplayScope = this.scopeService.locateParentScope(scope, "swListingDisplay");
=======
        var listingDisplayScope = this.scopeService.getRootParentScope(scope, "swListingDisplay");
>>>>>>> 8752089deaa3a8bd5071e97f8e60c1e1b7ff9486
        if(angular.isDefined(listingDisplayScope.swListingDisplay)){
            listingDisplayScope = listingDisplayScope.swListingDisplay;
        }else {
            throw("listing display scope not available to sw-listing-disable-rule");
        }

        listingDisplayScope.disableRules.push(rule); 
    }
}
export{
    SWListingDisableRule
}