/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {hibachimodule} from '../hibachi/hibachi.module';
import {ngslatwallmodule} from "../ngslatwall/ngslatwall.module";
//controllers 
//directives
import {SWOrderByPromotionListing} from "./components/sworderbypromotionlisting"; 
//models

var promotionmodule = angular.module('promotion',[hibachimodule.name, ngslatwallmodule.name])
.config([()=>{
	
}]).run([()=>{
	
}])
//constants
.constant('promotionPartialsPath','promotion/components/')
//controllers
//directives
.directive('swOrderByPromotionListing', SWOrderByPromotionListing.Factory())
;
export{
	promotionmodule
};