/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services

//controllers

//directives
import {SWSiteAndCurrencySelect} from "./components/swsiteandcurrencyselect";
//filters


var sitemodule = angular.module('hibachi.site',[coremodule.name]).config(()=>{
})
//constants
.constant('sitePartialsPath','site/components/')
//services

//controllers

//directives
.directive('swSiteAndCurrencySelect', SWSiteAndCurrencySelect.Factory())

//filters

;
export{
	sitemodule
}