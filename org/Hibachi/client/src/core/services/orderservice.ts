
import {BaseEntityService} from "./baseentityservice";
class OrderService extends BaseEntityService{
    public entity:any;

    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService
    ){
        super($injector,$hibachi,utilityService,'Order');
    }

    public newOrder_AddOrderPayment = ()=>{
        return this.newProcessObject('Order_AddOrderPayment');
    }
}
export {
    OrderService
}