/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Validates true if the model value (user value) is a numeric value.
 * @event This event fires on every change to an input.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationNumeric{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationnumeric =
                    (modelValue, viewValue)=> {
                        return validationService.validateNumeric(viewValue);
                };
            }
        };
    }
    public static Factory(){
        var directive = (validationService) => new SWValidationNumeric(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationNumeric
}
