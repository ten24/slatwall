/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services
//controllers
//directives
import {SWOrderFulfillmentList} from "./components/sworderfulfillmentlist";
import {SWTest} from "./components/swtest";
//filters


var orderfulfillmentmodule = angular.module('hibachi.orderfulfillment',[coremodule.name]).config(()=>{
})
//constants
.constant('orderFulfillmentPartialsPath','orderfulfillment/components/')
//services
//controllers
//directives
.directive('swOrderFulfillmentList',SWOrderFulfillmentList.Factory())
.directive('swTest',SWTest.Factory())
//filters

;
export{
	orderfulfillmentmodule
}