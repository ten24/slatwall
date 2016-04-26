/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderFulfillmentListController{

    //@ngInject
    constructor(
    ){
    }

}
class SWOrderFulfillmentList{

    public restrict:string = 'E';

    //public bindToController=true;
    public controller=SWOrderFulfillmentListController;
    public controllerAs="swOrderFulfillmentList";
    public templateUrl;

    public static Factory(){
        var directive = (
            orderFulfillmentPartialsPath,
            observerService,
            slatwallPathBuilder
        )=> new SWOrderFulfillmentList(
            orderFulfillmentPartialsPath,
            observerService,
            slatwallPathBuilder
        );
        directive.$inject = [
            'orderFulfillmentPartialsPath',
            'observerService',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
            orderFulfillmentPartialsPath,
            observerService,
            slatwallPathBuilder
    ){

        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderFulfillmentPartialsPath)+'orderfulfillmentlist.html';
    }

}
export{
    SWOrderFulfillmentList
}
