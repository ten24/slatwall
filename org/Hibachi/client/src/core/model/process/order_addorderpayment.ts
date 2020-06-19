/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseProcess} from "./baseprocess";

class Order_AddOrderPayment extends BaseProcess{

    constructor(public $injector){
        super($injector);
    }

}
export {
    Order_AddOrderPayment
}