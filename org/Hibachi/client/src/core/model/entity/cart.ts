/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseEntity} from "./baseentity";

class Cart extends BaseEntity{
    public orderRequirementsList:string="";
    public orderPayments:any=[];
    public orderItems:Array<any>=[];
    public fulfillmentTotal;
    public orderFulfillments:Array<any>=[];
    public account:any;
    public assignedAccount:any;
    public calculatedTotal:number;
    public orderID;
    //deprecated

    constructor($injector){
        super($injector);
    }

    public hasShippingAddressAndMethod = () => {
        if (this.orderRequirementsList.indexOf('fulfillment') == -1) {
             return true;
        }
        return false;
    };


    public orderRequiresAccount = ()=> {
        if ( this.orderRequirementsList.indexOf('account') != -1 || !this.account.accountID ) {
            return true;
        }
        return false;
    };

    public getOrderItemQuantitySum = ()=>{
        var totalQuantity = 0;
        if (angular.isDefined(this.orderItems)){
            for (var orderItem in this.orderItems){
                totalQuantity = totalQuantity + this.orderItems[orderItem].quantity;
            }
            return totalQuantity;
        }
        return totalQuantity;
    }

}
export {
    Cart
}
