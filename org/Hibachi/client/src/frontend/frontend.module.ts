/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
//modules
import {hibachimodule} 	from "../hibachi/hibachi.module";
//controllers
import {FrontendController} from './controllers/frontend';
//directives
import {SWFDirective} 		from "./components/swfdirective";
import {SWShippingCostEstimator} from "./components/swshippingcostestimator";
import {SWFCartItems} from "./components/swfcartitems";
import {SWFPromoBox} from "./components/swfpromobox";
import {SWFNavigation} from "./components/swfnavigation";
import {SWFAddressForm} from "./components/swfaddressform";
import {SWFSaveNotes} from "./components/swfsavenotes";

declare var hibachiConfig:any;
//need to inject the public service into the rootscope for use in the directives.
//Also, we set the initial value for account and cart.

var frontendmodule = angular.module('frontend', [hibachimodule.name])
.config(['hibachiPathBuilder',(hibachiPathBuilder)=>{
    /** set the baseURL */ 
	hibachiPathBuilder.setBaseURL('/');
    if(hibachiConfig && hibachiConfig.basePartialsPath){
        hibachiPathBuilder.setBasePartialsPath(hibachiConfig.basePartialsPath);
    }else{
        hibachiPathBuilder.setBasePartialsPath('custom/client/src/');
    }
    /** Sets the custom public integration point */
    if (hibachiConfig && hibachiConfig.apiSubsystemName){
        hibachiPathBuilder.setApiSubsystemName(hibachiConfig.apiSubsystemName);
    }

}])

.run(['$rootScope', '$hibachi','publicService','hibachiPathBuilder','entityService', '$window', function($rootScope, $hibachi, publicService,hibachiPathBuilder,entityService, $window) {
	$rootScope.slatwall = $rootScope.hibachiScope;
    
    $rootScope.slatwall.getProcessObject = entityService.newProcessObject;
    $rootScope.slatwall.getEntity = entityService.newEntity;
    $rootScope.slatwall.$hibachi.appConfig.apiSubsystemName = hibachiPathBuilder.apiSubsystemName;
}])

//controllers
.controller('frontendController',FrontendController)
//directives
.directive('swfDirective', SWFDirective.Factory())
.directive('swfCartItems', SWFCartItems.Factory())
.directive('swfPromoBox',SWFPromoBox.Factory())
.directive('swfNavigation',SWFNavigation.Factory())
.directive('swfSaveNotes',SWFSaveNotes.Factory())
.directive('swfAddressForm',SWFAddressForm.Factory())

export{
	frontendmodule
}
