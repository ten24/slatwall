
import {BaseEntityService} from "./baseentityservice";
class OrderPaymentService extends BaseEntityService{
    public entity:any;

    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService
    ){
        super($injector,$hibachi,utilityService,'OrderPayment');
    }


}
export {
    OrderPaymentService
}