/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services

//controllers

//directives
import {SWPricingManager} from "./components/swpricingmanager";
//filters


var skumodule = angular.module('hibachi.sku',[coremodule.name]).config(()=>{
})
//constants

//services

//controllers

//directives
.directive('swPricingManager', SWPricingManager.Factory())
//filters

;
export{
	skumodule
}