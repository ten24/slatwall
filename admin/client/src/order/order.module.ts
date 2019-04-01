/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

import {SWAccountPaymentMethodModal} from "./components/swaccountpaymentmethodmodal";
import {SWAccountShippingAddressCard} from "./components/swaccountshippingaddresscard";
import {SWAccountShippingMethodModal} from "./components/swaccountshippingmethodmodal";
import {SWCustomerAccountPaymentMethodCard} from "./components/swcustomeraccountpaymentmethodcard";

var ordermodule = angular.module('order',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('orderPartialsPath','order/components/')
//controllers
.directive('swAccountPaymentMethodModal', SWAccountPaymentMethodModal.Factory())
.directive('swAccountShippingAddressCard', SWAccountShippingAddressCard.Factory())
.directive('swAccountShippingMethodModal', SWAccountShippingMethodModal.Factory())
.directive('swCustomerAccountPaymentMethodCard',SWCustomerAccountPaymentMethodCard.Factory())
;
export{
	ordermodule
};