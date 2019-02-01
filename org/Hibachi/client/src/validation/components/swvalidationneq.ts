/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 *  Validates true if the user value != the property value.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationNeq{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationneq =
                    (modelValue)=> {
                        return validationService.validateNeq(modelValue,attributes.swvalidationneq);
                };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=>new SWValidationNeq(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationNeq
}
