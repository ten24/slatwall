/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//components
import {SWValidate} from "./components/swvalidate";
import {SWValidationMinLength} from "./components/swvalidationminlength";
import {SWValidationDataType} from "./components/swvalidationdatatype";
import {SWValidationEq} from "./components/swvalidationeq";
import {SWValidationGte} from "./components/swvalidationgte";
import {SWValidationLte} from "./components/swvalidationlte";
import {SWValidationMaxLength} from "./components/swvalidationmaxlength";
import {SWValidationMaxValue} from "./components/swvalidationmaxvalue";
import {SWValidationMinValue} from "./components/swvalidationminvalue";
import {SWValidationNeq} from "./components/swvalidationneq";
import {SWValidationNumeric} from "./components/swvalidationnumeric";
import {SWValidationRegex} from "./components/swvalidationregex";
import {SWValidationRequired} from "./components/swvalidationrequired";
import {SWValidationUnique} from "./components/swvalidationunique";
import {SWValidationUniqueOrNull} from "./components/swvalidationuniqueornull";
//services
import {ValidationService} from "./services/validationservice";
import {coremodule} from "../core/core.module";
var validationmodule = angular.module('hibachi.validation', [coremodule.name])
.run([function() {
}])
//directives
.directive('swValidate',SWValidate.Factory())
.directive('swvalidationminlength',SWValidationMinLength.Factory())
.directive('swvalidationdatatype',SWValidationDataType.Factory())
.directive('swvalidationeq',SWValidationEq.Factory())
.directive("swvalidationgte", SWValidationGte.Factory())
.directive("swvalidationlte",SWValidationLte.Factory())
.directive('swvalidationmaxlength',SWValidationMaxLength.Factory())
.directive("swvalidationmaxvalue",SWValidationMaxValue.Factory())
.directive("swvalidationminvalue",SWValidationMinValue.Factory())
.directive("swvalidationneq",SWValidationNeq.Factory())
.directive("swvalidationnumeric",SWValidationNumeric.Factory())
.directive("swvalidationregex",SWValidationRegex.Factory())
.directive("swvalidationrequired",SWValidationRequired.Factory())
.directive("swvalidationunique",SWValidationUnique.Factory())
.directive("swvalidationuniqueornull",SWValidationUniqueOrNull.Factory())
//services
.service("validationService",ValidationService)
;

export{
	validationmodule
}