/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Cart} from "../model/entity/cart.ts";
class CartService{
    //@ngInject
    constructor(public $injector:ng.auto.IInjectorService){
        this.$injector = $injector;
    }

    public newCart = ($injector=this.$injector):Cart=>{
        return new Cart($injector);
    }


}
export {
    CartService
}