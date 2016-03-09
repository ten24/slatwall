/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//controllers
//directives
import {SWFormResponseListing} from "./components/swformresponselisting"
//models


var formbuildermodule = angular.module('formbuilder',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('formBuilderPartialsPath','formbuilder/components/')
//controllers
//directives
.directive('swFormResponseListing',SWFormResponseListing.Factory())
;
export{
	formbuildermodule
};