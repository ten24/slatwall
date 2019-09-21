import {frontendmodule} from "../../../../org/Hibachi/client/src/frontend/frontend.module";

//directives
import {MonatFlexshipCard} from "./components/monatflexshipcard";
import {MonatFlexshipListing} from "./components/monatflexshiplisting"; 
import {MonatFlexshipMenu} from "./components/monatflexshipmenu";
import {MonatEnrollment} from "./components/monatenrollment";
import {MonatEnrollmentStep} from "./components/monatenrollmentstep";
import {MonatEnrollmentVIP} from "./components/monatenrollmentvip";

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
.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
.directive('monatEnrollment', MonatEnrollment.Factory())
.directive('monatEnrollmentStep', MonatEnrollmentStep.Factory())
.directive('vipController', MonatEnrollmentVIP.Factory())




.directive('swfReviewListing', SWFReviewListing.Factory())
.directive('swfWishlist', SWFWishlist.Factory())

.service('monatService', MonatService)
.service('orderTemplateService', OrderTemplateService)

export{
    monatfrontendmodule
};
