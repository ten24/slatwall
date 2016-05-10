/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services

//controllers

//directives
import {SWPricingManager} from "./components/swpricingmanager";
import {SWImageDetailModal} from "./components/swimagedetailmodal";
import {SWImageDetailModalLauncher} from "./components/swimagedetailmodallauncher";
//filters


var skumodule = angular.module('hibachi.sku',[coremodule.name]).config(()=>{
})
//constants
.constant('skuPartialsPath','sku/components/')
//services

//controllers

//directives
.directive('swPricingManager', SWPricingManager.Factory())
.directive('swImageDetailModal', SWImageDetailModal.Factory())
.directive('swImageDetailModalLauncher', SWImageDetailModalLauncher.Factory())
//filters

;
export{
	skumodule
}