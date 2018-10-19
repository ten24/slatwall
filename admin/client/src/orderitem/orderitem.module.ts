/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypescript.d.ts" />

import {coremodule} from '../../../../org/Hibachi/client/src/core/core.module';
import {CoreModule} from '../../../../org/Hibachi/client/src/core/core.module';

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule,downgradeInjectable,downgradeComponent} from '@angular/upgrade/static';

//directives
import {SWChildOrderItem} from "./components/swchildorderitem";
import {SWOrderItem} from "./components/sworderitem";
import {SwOiShippingLabelStamp} from "./components/swoishippinglabelstamp";
import {SWOrderItemDetailStamp, SwOrderItemDetailStamp} from "./components/sworderitemdetailstamp";
import {SWOrderItems} from "./components/sworderitems";
import {SWResizedImage} from "./components/swresizedimage";

@NgModule({
    declarations :[
        SwOrderItemDetailStamp,
        SwOiShippingLabelStamp
    ],
    providers: [],
    imports : [
        CoreModule,
        CommonModule,
        UpgradeModule
    ],
    entryComponents: [
        SwOrderItemDetailStamp,
        SwOiShippingLabelStamp
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
//.directive('swoishippinglabelstamp',SWOiShippingLabelStamp.Factory())
.directive('swoishippinglabelstamp', downgradeComponent({ component: SwOiShippingLabelStamp }) as angular.IDirectiveFactory)    
//.directive('swOrderItemDetailStamp',SWOrderItemDetailStamp.Factory())
.directive('swOrderItemDetailStamp', downgradeComponent({ component: SwOrderItemDetailStamp }) as angular.IDirectiveFactory)    
.directive('swOrderItems',SWOrderItems.Factory())
.directive('swresizedimage',SWResizedImage.Factory())
//constants
.constant('orderItemPartialsPath','orderitem/components/')
;

export{
	orderitemmodule
}




