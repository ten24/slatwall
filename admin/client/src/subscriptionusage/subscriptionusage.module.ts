/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services

//controllers
//filters

//directives
import {SWScheduledDeliveriesCard} from "./components/swscheduleddeliveriescard";


var subscriptionusagemodule = angular.module('hibachi.subscriptionusage',[coremodule.name]).config(()=>{

})
.constant('subscriptionUsagePartialsPath','subscriptionusage/components/')
//services

//controllers
//filters

//directives
.directive('swScheduledDeliveriesCard', SWScheduledDeliveriesCard.Factory())
;
export{
	subscriptionusagemodule
}