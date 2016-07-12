/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the minimum value.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationMinValue{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationminvalue =
                (modelValue, viewValue)=> {
                    return validationService.validateMinValue(viewValue,attributes.swvalidationminvalue);
                };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=> new SWValidationMinValue(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationMinValue
}
