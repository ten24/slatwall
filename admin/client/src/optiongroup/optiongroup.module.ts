
//modules
import { coremodule } from "../../../../org/Hibachi/client/src/core/core.module";
//controllers
//directives
import { SWAddOptionGroup } from "./components/swaddoptiongroup";
import { SWOptionsForOptionGroup } from "./components/swoptionsforoptiongroup";
//models
import { optionWithGroup } from "./components/swaddoptiongroup";
import * as angular from "angular";

var optiongroupmodule = angular.module('optiongroup', [coremodule.name])
	.config([() => {

	}]).run([() => {

	}])
	//constants
	.constant('optionGroupPartialsPath', 'optiongroup/components/')
	//controllers
	//directives
	.directive('swAddOptionGroup', SWAddOptionGroup.Factory())
	.directive('swOptionsForOptionGroup', SWOptionsForOptionGroup.Factory())
	;
export {
	optiongroupmodule
};