import {frontendmodule} from "../../../../org/Hibachi/client/src/frontend/frontend.module";

//directives
import {MonatFlexshipCard} from "./components/monatflexshipcard";
import {MonatFlexshipListing} from "./components/monatflexshiplisting"; 
import {MonatFlexshipMenu} from "./components/monatflexshipmenu";
import {SWFWishlist} from "./components/swfwishlist";
import {swfAccount} from "./components/swfmyaccount";
import {MonatEnrollment} from "./components/monatenrollment";
import {MonatEnrollmentStep} from "./components/monatenrollmentstep";

import {MonatEnrollmentVIPController} from "./components/monatenrollmentvip";

import {SWFReviewListing} from "./components/swfreviewlisting";

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
.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
.directive('monatEnrollment', MonatEnrollment.Factory())
.directive('monatEnrollmentStep', MonatEnrollmentStep.Factory())
.directive('vipController', MonatEnrollmentVIPController.Factory())
.directive('swfWishlist', SWFWishlist.Factory())
.directive('swfAccount', swfAccount.Factory())


.directive('swfReviewListing', SWFReviewListing.Factory())


.service('monatService', MonatService)
.service('orderTemplateService', OrderTemplateService);





export{
    monatfrontendmodule
};