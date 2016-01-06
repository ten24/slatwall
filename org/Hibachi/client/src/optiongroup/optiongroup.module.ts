/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {hibachimodule} from '../hibachi/hibachi.module';
import {ngslatwallmodule} from "../ngslatwall/ngslatwall.module";
//controllers
//directives
import {SWAddOptionGroup} from "./components/swaddoptiongroup";
import {SWOptionsForOptionGroup} from "./components/swoptionsforoptiongroup";
//models
import {optionWithGroup} from "./components/swaddoptiongroup";

var optiongroupmodule = angular.module('optiongroup',[hibachimodule.name, ngslatwallmodule.name])
.config([()=>{
	
}]).run([()=>{
	
}])
//constants
.constant('optionGroupPartialsPath','optiongroup/components/')
//controllers
//directives
.directive('swAddOptionGroup', SWAddOptionGroup.Factory())
.directive('swOptionsForOptionGroup', SWOptionsForOptionGroup.Factory())
;
export{
	optiongroupmodule
};