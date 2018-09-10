/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {CoreModule} from "../../../../org/Hibachi/client/src/core/core.module";

import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

//services

//controllers
import {ProductCreateController} from "./controllers/preprocessproduct_create";

//filters

//directives
import {SWProductListingPages} from "./components/swproductlistingpages"; 
import {SWRelatedProducts} from "./components/swrelatedproducts";
import {SWProductDeliveryScheduleDates} from "./components/swproductdeliveryscheduledates";

@NgModule({
    declarations :[],
    providers: [],
    imports : [
        CoreModule,
        CommonModule,
        UpgradeModule
    ]
})
export class ProductModule{
    constructor() {
        
    }    
}


var productmodule = angular.module('hibachi.product',[coremodule.name]).config(()=>{

})
.constant('productPartialsPath','product/components/')
//services

//controllers
.controller('preprocessproduct_create',ProductCreateController)
//filters

//directives
.directive('swProductListingPages', SWProductListingPages.Factory())
.directive('swProductDeliveryScheduleDates',SWProductDeliveryScheduleDates.Factory())

.directive('swRelatedProducts', SWRelatedProducts.Factory())
;
export{
	productmodule
}