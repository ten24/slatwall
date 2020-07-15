import {slatwalladminmodule} from "../../../../../admin/client/src/slatwall/slatwalladmin.module";
//directives
import {SWFlexshipSurveyModal} from "./components/swflexshipsurveymodal";
import {SWReturnOrderItems} from "./components/swreturnorderitems";
import {SWOrderList} from "./components/sworderlist";
import {OrderService} from "./services/orderservice";


//declare variables out of scope
declare var $:any;

var monatadminmodule = angular.module('monatadmin',[
  slatwalladminmodule.name
])
//constants
.constant('monatBasePath','/Slatwall/custom/admin/client/src')
.service('orderService', OrderService)
//directives
.directive('swFlexshipSurveyModal', SWFlexshipSurveyModal.Factory())
.directive('swReturnOrderItems', SWReturnOrderItems.Factory())
.directive('swOrderList', SWOrderList.Factory())
;

// the __DEBUG_MODE__ is driven by webpack-config and only enabled in debug-builds
if(__DEBUG_MODE__){
    // added here for debugging angular-bootstrapping, and other similar errors
	// this will throw all of the angular-exceptions 
    //   regardless if they're catched-anywhere ( .catch( error => () ) blocks )
    //   and you'll see a lot-more errors in the console
    // this will effect all modules, as $exceptionHandler is part of angular-core
    monatadminmodule.factory('$exceptionHandler', () => {
        return (exception, cause) => {
            exception.message += ` caused by '${cause || "no cause given"}' `;
            throw exception;
        };
    })
}

export{
    monatadminmodule
};
