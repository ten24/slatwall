import "angular-modal-service";

import {frontendmodule} from "../../../../org/Hibachi/client/src/frontend/frontend.module";

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
import {MonatFlexshipListing} from "./components/monatflexshiplisting"; 
import {MonatFlexshipMenu} from "./components/monatflexshipmenu";
import {MonatEnrollment} from "./components/monatenrollment";
import {MonatEnrollmentStep} from "./components/monatenrollmentstep";

import {SWFReviewListing} from "./components/swfreviewlisting";
import {SWFWishlist} from "./components/swfwishlist";
import {SWFAccount} from "./components/swfmyaccount";
import {MonatProductCard} from "./components/monatproductcard";
import {MonatEnrollmentMP} from "./components/monatenrollmentmp";


//services
import {MonatService} from "./services/monatservice"; 
import {OrderTemplateService} from "./services/ordertemplateservice"; 

//declare variables out of scope
declare var $:any;

var monatfrontendmodule = angular.module('monatfrontend',[
  frontendmodule.name, 'angularModalService'
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
.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
.directive('monatEnrollment', MonatEnrollment.Factory())
.directive('enrollmentMp', MonatEnrollmentMP.Factory())
.directive('monatEnrollmentStep', MonatEnrollmentStep.Factory())

.directive('swfReviewListing', SWFReviewListing.Factory())
.directive('swfWishlist', SWFWishlist.Factory())
.directive('monatProductCard', MonatProductCard.Factory())
.directive('swfAccount', SWFAccount.Factory())


.service('monatService', MonatService)
.service('orderTemplateService', OrderTemplateService)


.config(["ModalServiceProvider", function(ModalServiceProvider) {

   // to set a default close delay on modals
  ModalServiceProvider.configureOptions({closeDelay:500});

}])

export{
    monatfrontendmodule
};
