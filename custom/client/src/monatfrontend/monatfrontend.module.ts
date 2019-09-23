import {frontendmodule} 	     from "../../../../org/Hibachi/client/src/frontend/frontend.module";
//directives
import {MonatFlexshipCard} from "./components/monatflexshipcard";
import {MonatFlexshipDetail} from "./components/monatflexshipdetail";
import {MonatFlexshipOrderItem} from "./components/monatflexship-orderitem";
import {MonatFlexshipShippingAndBillingCard} from "./components/monatflexship-shippingandbillingcard";
import {MonatFlexshipOrderTotalCard} from "./components/monatflexship-ordertotalcard";
import {MonatFlexshipPaymentMethodModal} from "./components/monatflexship-modal-paymentmethod"; 
import {MonatFlexshipShippingMethodModal} from "./components/monatflexship-modal-shippingmethod";
import {MonatFlexshipChangeOrSkipOrderModal} from "./components/monatflexship-modal-changeorskiporder";
import {MonatFlexshipCancelModal} from "./components/monatflexship-modal-cancel";
import {MonatFlexshipCartContainer} from "./components/monatflexship-cart-container";
import {MonatFlexshipListing} from "./components/monatflexshiplisting"; 
import {MonatFlexshipMenu} from "./components/monatflexshipmenu";
import {MonatEnrollment} from "./components/monatenrollment";
import {MonatEnrollmentStep} from "./components/monatenrollmentstep";

import {SWFReviewListing} from "./components/swfreviewlisting";
import {SWFWishlist} from "./components/swfwishlist";
//services
import {MonatService} from "./services/monatservice"; 
import {OrderTemplateService} from "./services/ordertemplateservice"; 

//declare variables out of scope
declare var $:any;

var monatfrontendmodule = angular.module('monatfrontend',[
  frontendmodule.name
])
//constants
.constant('monatFrontendBasePath','/Slatwall/custom/client/src')
//directives
.directive('monatFlexshipListing', MonatFlexshipListing.Factory())
.directive('monatFlexshipCard', MonatFlexshipCard.Factory())
.directive('monatFlexshipDetail', MonatFlexshipDetail.Factory())
.directive('monatFlexshipOrderItem', MonatFlexshipOrderItem.Factory())
.directive('monatFlexshipShippingAndBillingCard', MonatFlexshipShippingAndBillingCard.Factory())
.directive('monatFlexshipOrderTotalCard', MonatFlexshipOrderTotalCard.Factory())
.directive('monatFlexshipPaymentMethodModal',MonatFlexshipPaymentMethodModal.Factory())
.directive('monatFlexshipShippingMethodModal',MonatFlexshipShippingMethodModal.Factory())
.directive('monatFlexshipChangeOrSkipOrderModal',MonatFlexshipChangeOrSkipOrderModal.Factory())
.directive('monatFlexshipCancelModal',MonatFlexshipCancelModal.Factory())
.directive('monatFlexshipCartContainer',MonatFlexshipCartContainer.Factory())
.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
.directive('monatEnrollment', MonatEnrollment.Factory())
.directive('monatEnrollmentStep', MonatEnrollmentStep.Factory())

.directive('swfReviewListing', SWFReviewListing.Factory())
.directive('swfWishlist', SWFWishlist.Factory())

.service('monatService', MonatService)
.service('orderTemplateService', OrderTemplateService)

export{
    monatfrontendmodule
};
