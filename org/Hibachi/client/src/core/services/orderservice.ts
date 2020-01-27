/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

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
    
    public placeOrderImportBatchOrders = (processObject) => {
        if (processObject) {
            processObject.data.entityName = "OrderImportBatch";
            return this.$hibachi.saveEntity("orderImportBatch",processObject.data.entityID,{}, "process");
        }
    }
    
    public deleteOrderImportBatchItems = (processObject) => {
        if (processObject) {
            processObject.data.entityName = "OrderImportBatchItem";
            return this.$hibachi.saveEntity("orderImportBatch",processObject.data.entityID,processObject.data, "deleteOrderImportBatchItems");
        }
    }
}
export {
    OrderService
}