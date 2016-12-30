/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the min value.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationMaxValue{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationmaxvalue =
                function(modelValue, viewValue) {
                    validationService.validateMaxValue(viewValue,attributes.swvalidationmaxvalue);
                };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=>new SWValidationMaxValue(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationMaxValue
}