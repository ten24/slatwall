/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

//services
import {OrderFulfillmentService} from "../orderfulfillment/services/orderfulfillmentservice";

//controllers

//directives
import {SWFulfillmentBatchDetail} from "./components/swfulfillmentbatchdetail";
//models 


var fulfillmentbatchdetailmodule = angular.module('fulfillmentbatchdetail',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('fulfillmentBatchDetailPartialsPath','fulfillmentbatch/components/')
//services
.service('orderFulfillmentService', OrderFulfillmentService)
//controllers
//directives
.directive('swFulfillmentBatchDetail', SWFulfillmentBatchDetail.Factory());

export{
	fulfillmentbatchdetailmodule
};