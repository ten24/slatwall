/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWListingAggregateController{
    public editable:boolean;
    constructor(

    ){
        this.init();
    }

    public init = () =>{
        this.editable = this.editable || false;
    }
}

class SWListingAggregate implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public bindToController={
        propertyIdentifier:"@",
        aggregateFunction:"@",
        aggregateAlias:"@?"
    };
    public controller=SWListingAggregateController;
    public controllerAs="swListingAggregate";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(

        )=>new SWListingAggregate(

        );
        directive.$inject = [

        ];
        return directive;
    }
    constructor(){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

        var aggregate = {
            propertyIdentifier:scope.swListingAggregate.propertyIdentifier,
            aggregateFunction:scope.swListingAggregate.aggregateFunction,
            aggregateAlias:scope.swListingAggregate.aggregateAlias,
        };

        scope.$parent.swListingDisplay.aggregates.push(aggregate);

    }
}
export{
    SWListingAggregate
}


