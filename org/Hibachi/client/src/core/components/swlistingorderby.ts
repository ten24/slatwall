/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingOrderByController{
    //@ngInject
    constructor(

    ){
        this.init();
    }

    public init = () =>{
    }
}

class SWListingOrderBy implements ng.IDirective{

    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        orderBy:"@",
    };
    public controller=SWListingOrderByController;
    public controllerAs="swListingOrderBy";
    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            utilityService
        )=>new SWListingOrderBy(
            utilityService
        );
        directive.$inject = [
            'utilityService'
        ];
        return directive;
    }
    //@ngInject
    constructor(private utilityService){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

        var orderBy = {
            orderBy:scope.swListingOrderBy.orderBy,
        };

        scope.$parent.swListingDisplay.orderBys.push(orderBy);

    }
}
export{
    SWListingOrderBy
}