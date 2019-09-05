import {frontendmodule} 	     from "../../../../org/Hibachi/client/src/frontend/frontend.module";
//directives
import {SWFReviewListing} from "./components/swfreviewlisting";
import {MonatFlexshipCard} from "./components/monatflexshipcard";
import {MonatFlexshipDetail} from "./components/monatflexshipdetail";
import {MonatFlexshipOrderItem} from "./components/monatflexship-orderitem";
import {MonatFlexshipShippingAndBillingCard} from "./components/monatflexship-shippingandbillingcard";
import {MonatFlexshipOrderTotalCard} from "./components/monatflexship-ordertotalcard";
import {MonatFlexshipPaymentMethodModal} from "./components/monatflexship-modal-paymentmethod"; 
import {MonatFlexshipShippingMethodModal} from "./components/monatflexship-modal-shippingmethod";
import {MonatFlexshipChangeOrSkipOrderModal} from "./components/monatflexship-modal-changeorskiporder";
import {MonatFlexshipListing} from "./components/monatflexshiplisting"; 
import {MonatFlexshipMenu} from "./components/monatflexshipmenu";
//services
import {OrderTemplateService} from "./services/ordertemplateservice"; 
import {SWFWishlist} from "./components/swfwishlist";

//declare variables out of scope
declare var $:any;

var monatfrontendmodule = angular.module('monatfrontend',[
  frontendmodule.name
])
//constants
.constant('monatFrontendBasePath','/Slatwall/custom/client/src')
//directives
.directive('swfReviewListing', SWFReviewListing.Factory())
.directive('monatFlexshipListing', MonatFlexshipListing.Factory())
.directive('monatFlexshipCard', MonatFlexshipCard.Factory())
.directive('monatFlexshipDetail', MonatFlexshipDetail.Factory())
.directive('monatFlexshipOrderItem', MonatFlexshipOrderItem.Factory())
.directive('monatFlexshipShippingAndBillingCard', MonatFlexshipShippingAndBillingCard.Factory())
.directive('monatFlexshipOrderTotalCard', MonatFlexshipOrderTotalCard.Factory())
.directive('monatFlexshipPaymentMethodModal',MonatFlexshipPaymentMethodModal.Factory())
.directive('monatFlexshipShippingMethodModal',MonatFlexshipShippingMethodModal.Factory())
.directive('monatFlexshipChangeOrSkipOrderModal',MonatFlexshipChangeOrSkipOrderModal.Factory())
.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
.service('orderTemplateService', OrderTemplateService)
.directive('swfWishlist', SWFWishlist.Factory());

export{
    monatfrontendmodule
};
