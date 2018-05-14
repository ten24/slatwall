/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypescript.d.ts" />
import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

import {coremodule} from '../../../../org/Hibachi/client/src/core/core.module';
import {CoreModule} from '../../../../org/Hibachi/client/src/core/core.module';
//directives
import {SWChildOrderItem} from "./components/swchildorderitem";
import {SWOrderItem} from "./components/sworderitem";
import {SWOiShippingLabelStamp} from "./components/swoishippinglabelstamp";
import {SWOrderItemDetailStamp} from "./components/sworderitemdetailstamp";
import {SWOrderItems} from "./components/sworderitems";
 import {SWResizedImage} from "./components/swresizedimage";

@NgModule({
    declarations :[],
    providers: [],
    imports : [
        CoreModule
    ]
})
export class OrderItemModule{
    constructor() {
        
    }    
}

var orderitemmodule = angular.module('hibachi.orderitem', [coremodule.name])
// .config(['$provide','baseURL',($provide,baseURL)=>{
// 	$provide.constant('paginationPartials', baseURL+basePartialsPath+'pagination/components/');
// }])
.run([()=> {
}])
//directives
.directive('swChildOrderItem',SWChildOrderItem.Factory())
.directive('swOrderItem',SWOrderItem.Factory())
.directive('swoishippinglabelstamp',SWOiShippingLabelStamp.Factory())
.directive('swOrderItemDetailStamp',SWOrderItemDetailStamp.Factory())
.directive('swOrderItems',SWOrderItems.Factory())
.directive('swresizedimage',SWResizedImage.Factory())
//constants
.constant('orderItemPartialsPath','orderitem/components/')
;

export{
	orderitemmodule
}




