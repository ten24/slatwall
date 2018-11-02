/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypescript.d.ts" />

import {coremodule} from '../../../../org/Hibachi/client/src/core/core.module';
import {CoreModule} from '../../../../org/Hibachi/client/src/core/core.module';

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule,downgradeInjectable,downgradeComponent} from '@angular/upgrade/static';

//directives
import {SWChildOrderItem, SwChildOrderItem} from "./components/swchildorderitem";
import {SWOrderItem, SwOrderItem} from "./components/sworderitem";
import {SwOiShippingLabelStamp} from "./components/swoishippinglabelstamp";
import {SWOrderItemDetailStamp, SwOrderItemDetailStamp} from "./components/sworderitemdetailstamp";
import {SWOrderItems, SwOrderItems} from "./components/sworderitems";
import {SwResizedImage} from "./components/swresizedimage";
import { SwCurrency } from '../slatwall/filters/swcurrency';
import { PaginationModule } from '../../../../org/Hibachi/client/src/pagination/pagination.module';

@NgModule({
    declarations :[
        SwOrderItems,
        SwChildOrderItem,
        SwCurrency,
        SwOrderItem,
        SwOrderItemDetailStamp,
        SwOiShippingLabelStamp,
        SwResizedImage
    ],
    providers: [],
    imports : [
        CoreModule,
        CommonModule,
        UpgradeModule,
        PaginationModule
    ],
    entryComponents: [
        SwOrderItems,
        SwChildOrderItem,
        SwOrderItem,
        SwOrderItemDetailStamp,
        SwOiShippingLabelStamp,
        SwResizedImage
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
//.directive('swOrderItems',SWOrderItems.Factory())
.directive('swOrderItems', downgradeComponent({ component: SwOrderItems }) as angular.IDirectiveFactory)   
//.directive('swChildOrderItem',SWChildOrderItem.Factory())
.directive('swChildOrderItem', downgradeComponent({ component: SwChildOrderItem }) as angular.IDirectiveFactory)        
//.directive('swOrderItem',SWOrderItem.Factory())
.directive('swOrderItem',downgradeComponent({ component: SwOrderItem }) as angular.IDirectiveFactory)
//.directive('swoishippinglabelstamp',SWOiShippingLabelStamp.Factory())
.directive('swoishippinglabelstamp', downgradeComponent({ component: SwOiShippingLabelStamp }) as angular.IDirectiveFactory)    
//.directive('swOrderItemDetailStamp',SWOrderItemDetailStamp.Factory())
.directive('swOrderItemDetailStamp', downgradeComponent({ component: SwOrderItemDetailStamp }) as angular.IDirectiveFactory)    
//.directive('swresizedimage',SWResizedImage.Factory())
.directive('swresizedimage',downgradeComponent({ component: SwResizedImage }) as angular.IDirectiveFactory)
//constants
.constant('orderItemPartialsPath','orderitem/components/')
;

export{
	orderitemmodule
}




