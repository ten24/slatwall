/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTestController{

    //@ngInject
    constructor(
    ){
    }

}
class SWTest{

    public restrict:string = 'E';

    //public bindToController=true;
    public controller=SWTestController;
    public controllerAs="swTest";
    public templateUrl;

    public static Factory(){
        var directive = (
            orderFulfillmentPartialsPath,
            observerService,
            slatwallPathBuilder
        )=> new SWTest(
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

        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderFulfillmentPartialsPath)+'test.html';
    }

}
export{
    SWTest
}
