/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Cart} from "../model/entity/cart.ts";
import {BaseEntityService} from "./baseentityservice";
class CartService extends BaseEntityService{
    //@ngInject
    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService
    ){
        super($injector,$hibachi,utilityService,'Order','Cart');

    }

}
export {
    CartService
}