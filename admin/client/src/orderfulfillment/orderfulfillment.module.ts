/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {CoreModule} from "../../../../org/Hibachi/client/src/core/core.module";

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule, downgradeInjectable} from '@angular/upgrade/static';

//services
import {OrderFulfillmentService} from "./services/orderfulfillmentservice";

//controllers

//directives
import {SWOrderFulfillmentList} from "./components/sworderfulfillmentlist";
//models 


@NgModule({
	declarations : [],
	providers : [
        OrderFulfillmentService
    ],
	imports : [
		CoreModule,
		CommonModule,
		UpgradeModule
	]
})

export class OrderFulfillmentModule{
	constructor(){
		
	}
}

var orderfulfillmentmodule = angular.module('orderFulfillment',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('orderFulfillmentPartialsPath','orderfulfillment/components/')
//services
.service('orderFulfillmentService', downgradeInjectable(OrderFulfillmentService))
//controllers
//directives
.directive('swOrderFulfillmentList', SWOrderFulfillmentList.Factory());

export{
	orderfulfillmentmodule
};