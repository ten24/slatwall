/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWListingColorFilterController{
    constructor(

    ){
        this.init();
    }

    public init = () =>{
    }
}

class SWListingColorFilter implements ng.IDirective{

    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyToCompare:"@",
        comparisonOperator:"@",
        comparisonValue:"@",
        comparisonProperty:"@",
        colorClass:"@",
        color:"@"
    };
    public controller=SWListingColorFilterController;
    public controllerAs="swListingColorFilter";
    
    public static Factory(){
        return /** @ngInject */ (utilityService) => new this(utilityService);
    }

    // @ngInject
    constructor(private utilityService){}

    public link:ng.IDirectiveLinkFn = (scope: any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

        var colorFilter = {
            propertyToCompare:scope.swListingColorFilter.propertyToCompare,
            comparisonOperator:scope.swListingColorFilter.comparisonOperator,
            comparisonValue:scope.swListingColorFilter.comparisonValue,
            comparisonProperty:scope.swListingColorFilter.comparisonProperty,
            colorClass:scope.swListingColorFilter.colorClass,
            color:scope.swListingColorFilter.color
        };
        if(this.utilityService.ArrayFindByPropertyValue(scope.$parent.swListingDisplay.colorFilters,'propertyToCompare',colorFilter.propertyToCompare) === -1){
            scope.$parent.swListingDisplay.colorFilters.push(colorFilter);
        }
    }
}
export{
    SWListingColorFilter
}
