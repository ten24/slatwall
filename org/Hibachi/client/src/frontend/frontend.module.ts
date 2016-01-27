/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
//modules
import {coremodule} 	from "../core/core.module";
//controllers
import {FrontendController} from './controllers/frontend';
//directives
import {SWFDirective} 		from "./components/swfdirective";
import {SWFCart} 			from "./components/swfcart";
import {SWFCreateAccount} 	from "./components/swfcreateaccount";
import {SWFLogin} 			from "./components/swflogin";
import {SWFLogout} 			from "./components/swflogout";
import {SWFPromo} 			from "./components/swfpromo";

//need to inject the public service into the rootscope for use in the directives.
//Also, we set the initial value for account and cart.
var frontendmodule = angular.module('frontend', [coremodule.name])
.config(['hibachiPathBuilder',(hibachiPathBuilder)=>{
                    /** set the baseURL */ 
					hibachiPathBuilder.setBaseURL('/');
                    hibachiPathBuilder.setBasePartialsPath('custom/assets/');
}])
.run(['$rootScope', 'publicService','hibachiPathBuilder', function($rootScope, publicService,hibachiPathBuilder) {

	$rootScope.hibachiScope = publicService;
	$rootScope.hibachiScope.getAccount();
	$rootScope.hibachiScope.getCart();
	$rootScope.slatwall = $rootScope.hibachiScope;
}])

//constants
.constant('frontendPartialsPath','frontend/components/')
//controllers
.controller('frontendController',FrontendController)
//directives
.directive('swfDirective', SWFDirective.Factory())
.directive('swfCart', SWFCart.Factory())
.directive('swfCreateAccount', SWFCreateAccount.Factory())
.directive('swfLogin', SWFLogin.Factory())
.directive('swfLogout', SWFLogout.Factory())
.directive('swfPromo', 	SWFPromo.Factory());

export{
	frontendmodule
}