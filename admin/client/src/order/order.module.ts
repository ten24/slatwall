/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services
import {OrderTemplateService} from "./services/ordertemplateservice";
//components
import {SWAccountPaymentMethodModal} from "./components/swaccountpaymentmethodmodal";
import {SWAccountShippingAddressCard} from "./components/swaccountshippingaddresscard";
import {SWAccountShippingMethodModal} from "./components/swaccountshippingmethodmodal";
import {SWCustomerAccountPaymentMethodCard} from "./components/swcustomeraccountpaymentmethodcard";
import {SWOrderTemplateAddPromotionModal} from "./components/swordertemplateaddpromotionmodal";
import {SWOrderTemplateAddGiftCardModal} from "./components/swordertemplateaddgiftcardmodal";
import {SWOrderTemplateFrequencyCard} from "./components/swordertemplatefrequencycard";
import {SWOrderTemplateFrequencyModal} from "./components/swordertemplatefrequencymodal";
import {SWOrderTemplateGiftCards} from "./components/swordertemplategiftcards";
import {SWOrderTemplateItems} from "./components/swordertemplateitems";
import {SWOrderTemplatePromotions} from "./components/swordertemplatepromotions";
import {SWOrderTemplatePromotionItems} from "./components/swordertemplatepromotionitems";
import {SWOrderTemplateUpcomingOrdersCard} from "./components/swordertemplateupcomingorderscard";
import {SWOrderTemplateUpdateScheduleModal} from "./components/swordertemplateupdateschedulemodal";
import {SWAddOrderItemsBySku} from "order/components/swaddorderitemsbysku";
import {SWAddPromotionOrderItemsBySku} from "./components/swaddpromotionorderitemsbysku";

var ordermodule = angular.module('order',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('orderPartialsPath','order/components/')
//services
.service('orderTemplateService', OrderTemplateService)
//controllers
.directive('swAccountPaymentMethodModal', SWAccountPaymentMethodModal.Factory())
.directive('swAccountShippingAddressCard', SWAccountShippingAddressCard.Factory())
.directive('swAccountShippingMethodModal', SWAccountShippingMethodModal.Factory())
.directive('swCustomerAccountPaymentMethodCard',SWCustomerAccountPaymentMethodCard.Factory())
.directive('swOrderTemplateAddPromotionModal', SWOrderTemplateAddPromotionModal.Factory())
.directive('swOrderTemplateAddGiftCardModal', SWOrderTemplateAddGiftCardModal.Factory())
.directive('swOrderTemplateFrequencyCard', SWOrderTemplateFrequencyCard.Factory())
.directive('swOrderTemplateFrequencyModal', SWOrderTemplateFrequencyModal.Factory())
.directive('swOrderTemplateGiftCards', SWOrderTemplateGiftCards.Factory())
.directive('swOrderTemplateItems', SWOrderTemplateItems.Factory())
.directive('swOrderTemplatePromotions', SWOrderTemplatePromotions.Factory())
.directive('swOrderTemplatePromotionItems', SWOrderTemplatePromotionItems.Factory())
.directive('swOrderTemplateUpcomingOrdersCard', SWOrderTemplateUpcomingOrdersCard.Factory())
.directive('swOrderTemplateUpdateScheduleModal', SWOrderTemplateUpdateScheduleModal.Factory())
.directive('swAddOrderItemsBySku', SWAddOrderItemsBySku.Factory())
.directive('swAddPromotionOrderItemsBySku', SWAddPromotionOrderItemsBySku.Factory())
;
export{
	ordermodule
};