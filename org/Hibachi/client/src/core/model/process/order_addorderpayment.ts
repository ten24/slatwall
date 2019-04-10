
import { BaseProcess } from "./baseprocess";

class Order_AddOrderPayment extends BaseProcess {
    //@ngInject
    constructor(public $injector) {
        super($injector);
    }

}
export {
    Order_AddOrderPayment
}