/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the max length.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationMaxLength{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationmaxlength =
                    function(modelValue, viewValue) {
                        return validationService.validateMaxLength(viewValue.length,attributes.swvalidationmaxlength);
                    };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=>new SWValidationMaxLength(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationMaxLength
}