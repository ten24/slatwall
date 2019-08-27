import {frontendmodule} 	     from "../../../../org/Hibachi/client/src/frontend/frontend.module";
//directives
import {SWFReviewListing} from "./components/swfreviewlisting";
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
.directive('swfWishlist', SWFWishlist.Factory());

export{
    monatfrontendmodule
};
