
//modules
import { coremodule } from "../../../../org/Hibachi/client/src/core/core.module";

//services
import { OrderFulfillmentService } from "./services/orderfulfillmentservice";

//controllers

//directives
import { SWOrderFulfillmentList } from "./components/sworderfulfillmentlist";
import * as angular from "angular";
//models 


var orderfulfillmentmodule = angular.module('orderFulfillment', [coremodule.name])
	.config([() => {

	}]).run([() => {

	}])
	//constants
	.constant('orderFulfillmentPartialsPath', 'orderfulfillment/components/')
	//services
	.service('orderFulfillmentService', OrderFulfillmentService)
	//controllers
	//directives
	.directive('swOrderFulfillmentList', SWOrderFulfillmentList.Factory());

export {
	orderfulfillmentmodule
};