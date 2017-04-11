/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

//services
import {SWOrderFulfillmentService} from "./services/orderfulfillmentservice";

//controllers

//directives
import {SWOrderFulfillmentList} from "./components/sworderfulfillmentlist";
//models 


var orderfulfillmentmodule = angular.module('orderFulfillment',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('orderFulfillmentPartialsPath','orderFulfillment/components/')
//services
.service('swOrderFulfillmentService', SWOrderFulfillmentService)
//controllers
//directives
.directive('swOrderFulfillmentList', SWOrderFulfillmentList.Factory());

export{
	orderfulfillmentmodule
};