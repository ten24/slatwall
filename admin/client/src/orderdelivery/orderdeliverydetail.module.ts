/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

//services
//import {OrderFulfillmentService} from "../orderfulfillment/services/orderfulfillmentservice";

//controllers

//directives
import {SWOrderDeliveryDetail} from "./components/sworderdeliverydetail";


var orderdeliverydetailmodule = angular.module('orderdeliverydetail',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('orderDeliveryDetailPartialsPath','orderdelivery/components/')

//services

//controllers

//directives
.directive('swOrderDeliveryDetail', SWOrderDeliveryDetail.Factory());

export{
	orderdeliverydetailmodule
};