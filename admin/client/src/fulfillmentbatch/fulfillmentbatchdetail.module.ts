/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {CoreModule} from "../../../../org/Hibachi/client/src/core/core.module";

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule, downgradeInjectable} from '@angular/upgrade/static';

//services
import {OrderFulfillmentService} from "../orderfulfillment/services/orderfulfillmentservice";

//controllers

//directives
import {SWFulfillmentBatchDetail} from "./components/swfulfillmentbatchdetail";
//models 




@NgModule({
	declarations : [],
	providers : [],
	imports : [
		CoreModule,
		CommonModule,
		UpgradeModule
	]
})

export class FulfillmentBatchDetailModule{
	constructor(){

	}
}

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