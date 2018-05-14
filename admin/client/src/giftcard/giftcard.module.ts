/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {CoreModule} from "../../../../org/Hibachi/client/src/core/core.module";
//controllers
import {OrderItemGiftRecipientControl} from "./controllers/preprocessorderitem_addorderitemgiftrecipient";
//directives
import {SWAddOrderItemGiftRecipient} from "./components/swaddorderitemgiftrecipient";
import {SWGiftCardBalance} from "./components/swgiftcardbalance";
import {SWGiftCardDetail} from "./components/swgiftcarddetail";
import {SWGiftCardHistory} from "./components/swgiftcardhistory";
import {SWGiftCardOverview} from "./components/swgiftcardoverview";
import {SWGiftCardOrderInfo} from "./components/swgiftcardorderinfo";
import {SWGiftCardRecipientInfo} from "./components/swgiftcardrecipientinfo";
import {SWOrderItemGiftRecipientRow} from "./components/sworderitemgiftrecipientrow";
//models
import {GiftCard} from "./models/giftcard";
import {GiftRecipient} from "./models/giftrecipient";

@NgModule({
    declarations :[],
    providers: [],
    imports : [
        CoreModule
    ]
})
export class GiftCardModule{
    constructor() {
        
    }    
}


var giftcardmodule = angular.module('giftcard',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('giftCardPartialsPath','giftcard/components/')
//controllers
.controller('preprocessorderitem_addorderitemgiftrecipient',OrderItemGiftRecipientControl)
//directives
.directive('swAddOrderItemGiftRecipient', SWAddOrderItemGiftRecipient.Factory())
.directive('swGiftCardBalance', SWGiftCardBalance.Factory())
.directive('swGiftCardOverview', SWGiftCardOverview.Factory())
.directive('swGiftCardDetail', SWGiftCardDetail.Factory())
.directive('swGiftCardHistory', SWGiftCardHistory.Factory())
.directive('swGiftCardRecipientInfo', SWGiftCardRecipientInfo.Factory())
.directive('swGiftCardOrderInfo', SWGiftCardOrderInfo.Factory())
.directive('swOrderItemGiftRecipientRow', SWOrderItemGiftRecipientRow.Factory())
;
export{
	giftcardmodule
};