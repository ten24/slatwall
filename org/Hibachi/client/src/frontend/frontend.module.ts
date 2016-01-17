/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypeScript.d.ts" />
//modules
import {coremodule} 	from "../core/core.module";
//controllers
import {FrontendController} from './controllers/frontend';
//directives
import {SWFDirective} 		from "./components/swfdirective";

//need to inject the public service into the rootscope for use in the directives.
//Also, we set the initial value for account and cart.
var frontendmodule = angular.module('frontend', [coremodule.name])
.config(['pathBuilderConfig',(pathBuilderConfig)=>{
                    /** set the baseURL */ 
					pathBuilderConfig.setBaseURL('/');
                    pathBuilderConfig.setBasePartialsPath('custom/assets/');
}])
.run(['$rootScope', '$hibachi', 'publicService','pathBuilderConfig', function($rootScope, $hibachi, publicService, pathBuilderConfig) {
	console.log($rootScope, $hibachi)
    $rootScope.hibachiScope = publicService;
	$rootScope.hibachiScope.getAccount(); 
	$rootScope.hibachiScope.getCart();
	$rootScope.slatwall = $rootScope.hibachiScope;
    $rootScope.slatwall.getProcessObject = $hibachi.newEntity;
    
}])

//constants
.constant('frontendPartialsPath','frontend/components/')
//controllers
.controller('frontendController',FrontendController)
//directives
.directive('swfDirective', SWFDirective.Factory())

export{
	frontendmodule
}