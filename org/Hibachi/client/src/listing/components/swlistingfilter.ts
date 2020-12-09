/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWListingFilterController{
    constructor(

    ){
        this.init();
    }

    public init = () =>{
    }
}

class SWListingFilter implements ng.IDirective{

    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        comparisonOperator:"@",
        comparisonValue:"@",
        logicalOperator:"@",
        hidden:"@?"
    };
    public controller=SWListingFilterController;
    public controllerAs="swListingFilter";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(

        )=>new SWListingFilter(

        );
        directive.$inject = [

        ];
        return directive;
    }
    constructor(){

    }

    public link:ng.IDirectiveLinkFn = (scope: any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

        var filter = {
            propertyIdentifier:scope.swListingFilter.propertyIdentifier,
            comparisonOperator:scope.swListingFilter.comparisonOperator,
            comparisonValue:scope.swListingFilter.comparisonValue,
            logicalOperator:scope.swListingFilter.logicalOperator,
                hidden: false
        };

        if(angular.isDefined(scope.swListingFilter.hidden)){
            filter['hidden'] = scope.swListingFilter.hidden;
        }
        if(angular.isDefined(scope.$parent.swListingFilterGroup)){
            scope.$parent.swListingFilterGroup.filters.push(filter);
        }else{
            scope.$parent.swListingDisplay.filters.push(filter);
        }

    }
}
export{
    SWListingFilter
}
