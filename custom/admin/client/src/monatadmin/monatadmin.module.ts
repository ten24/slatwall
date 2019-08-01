import {slatwalladminmodule} from "../../../../../admin/client/src/slatwall/slatwalladmin.module";
//directives
import {SWFlexshipSurveyModal} from "./components/swflexshipsurveymodal";
import {SWReturnOrderItems} from "./components/swreturnorderitems";

//declare variables out of scope
declare var $:any;

var monatadminmodule = angular.module('monatadmin',[
  slatwalladminmodule.name
])
//constants
.constant('monatBasePath','/Slatwall/custom/admin/client/src')
//directives
.directive('swFlexshipSurveyModal', SWFlexshipSurveyModal.Factory())
.directive('swReturnOrderItems', SWReturnOrderItems.Factory())
;

export{
    monatadminmodule
};
