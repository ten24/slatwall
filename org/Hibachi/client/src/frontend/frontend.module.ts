/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
//modules
import {hibachimodule} 	from "../hibachi/hibachi.module";
//controllers
import {FrontendController} from './controllers/frontend';
//directives
import {SWFDirective} 		from "./components/swfdirective";


//need to inject the public service into the rootscope for use in the directives.
//Also, we set the initial value for account and cart.

var frontendmodule = angular.module('frontend', [hibachimodule.name])
.config(['hibachiPathBuilder',(hibachiPathBuilder)=>{
                    /** set the baseURL */ 
					hibachiPathBuilder.setBaseURL('/');
                    hibachiPathBuilder.setBasePartialsPath(hibachiConfig.basePartialsPath);

}])

.run(['$rootScope', '$hibachi','publicService','hibachiPathBuilder', function($rootScope, $hibachi, publicService,hibachiPathBuilder) {


    $rootScope.hibachiScope = publicService;
	$rootScope.hibachiScope.getAccount(); 
	$rootScope.hibachiScope.getCart();
    $rootScope.hibachiScope.getCountries();
    $rootScope.hibachiScope.getStates(); 
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
