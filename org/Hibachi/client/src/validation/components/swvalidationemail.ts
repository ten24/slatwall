/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * True if the data type matches the given data type.
 */
/**
 * Validates true if the model value is a numeric value.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationEmail{
    public static Factory(){
        var directive = (
            validationService
        )=> new SWValidationEmail(
            validationService
        );
        directive.$inject = ['validationService'];
        return directive;
    }
    //@ngInject
    constructor(
        validationService:ValidationService
    ){
        return {
            restrict: "A",
            require: "^ngModel",

            link: function(scope, element, attributes, ngModel) {
                var isValidFunction = (modelValue):boolean=> {
                    return validationService.validateEmail(modelValue);
                };
                ngModel.$validators.swvalidationemail = isValidFunction;
                ngModel.$validators['swvalidationemail'] = isValidFunction;
            }
        };
    }
}
export{
    SWValidationEmail
}
