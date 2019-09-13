import {frontendmodule} 	     from "../../../../org/Hibachi/client/src/frontend/frontend.module";
//directives
import {SWFReviewListing} from "./components/swfreviewlisting";
import {MonatFlexshipCard} from "./components/monatflexshipcard";
import {MonatFlexshipListing} from "./components/monatflexshiplisting"; 
import {MonatFlexshipMenu} from "./components/monatflexshipmenu";
//services
import {OrderTemplateService} from "./services/ordertemplateservice"; 
import {SWFWishlist} from "./components/swfwishlist";
import {swfAccount} from "./components/swfmyaccount";


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
.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
.service('orderTemplateService', OrderTemplateService)
.directive('swfWishlist', SWFWishlist.Factory())
.directive('swfAccount', swfAccount.Factory());


export{
    monatfrontendmodule
};
