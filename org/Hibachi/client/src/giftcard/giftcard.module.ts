/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {hibachimodule} from "../hibachi/hibachi.module";
//controllers
import {OrderItemGiftRecipientControl} from "./controllers/preprocessorderitem_addorderitemgiftrecipient"; 
//directives
import {SWAddOrderItemGiftRecipient} from "./components/swaddorderitemgiftrecipient"; 
import {SWGiftCardBalance} from "./components/swgiftcardbalance"; 
import {SWGiftCardDetail} from "./components/swgiftcarddetail"; 
import {SWGiftCardHistory} from "./components/swgiftcardhistory"; 
import {SWGiftCardOrderInfo} from "./components/swgiftcardoverview"; 
import {SWGiftCardRecipientInfo} from "./components/swgiftcardrecipientinfo"; 
import {SWOrderItemGiftRecipientRow} from "./components/sworderitemgiftrecipientrow";
//models
import {GiftCard} from "./models/giftCard";
import {GiftRecipient} from "./models/giftRecipient";

var giftcardmodule = angular.module('giftcard',[hibachimodule.name])
.config([()=>{
	
}]).run([()=>{
	
}])
//constants
.constant('giftcardPartialsPath','components')
//controllers
.controller('preprocessorderitem_addorderitemgiftrecipient',OrderItemGiftRecipientControl)
//directives
.directive('swAddOrderItemGiftRecipient', SWAddOrderItemGiftRecipient.Factory())
.directive('swGiftCardBalance', SWGiftCardBalance.Factory())
.directive('swGiftCardDetail', SWGiftCardDetail.Factory())
.directive('swGiftCardHistory', SWGiftCardHistory.Factory())
.directive('swGiftCardRecipientInfo', SWGiftCardOrderInfo.Factory())
.directive('swOrderItemGiftRecipientRow', SWOrderItemGiftRecipientRow.Factory())
;
export{
	giftcardmodule
};