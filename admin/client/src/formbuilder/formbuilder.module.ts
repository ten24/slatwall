
//modules
import { coremodule } from "../../../../org/Hibachi/client/src/core/core.module";
//controllers
//directives
import { SWFormResponseListing } from "./components/swformresponselisting"
import * as angular from "angular";
//models


var formbuildermodule = angular.module('formbuilder', [coremodule.name])
	.config([() => {

	}]).run([() => {

	}])
	//constants
	.constant('formBuilderPartialsPath', 'formbuilder/components/')
	//controllers
	//directives
	.directive('swFormResponseListing', SWFormResponseListing.Factory())
	;
export {
	formbuildermodule
};