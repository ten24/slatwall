/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the min length.
 */
/**
 * Returns true if the user value is greater than the minimum value.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationMinLength{
    public static Factory(){
        var directive = ($log,validationService)=> new SWValidationMinLength($log,validationService);
        directive.$inject = ['$log','validationService'];
        return directive;
    }
    constructor($log,validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: (scope, element, attributes, ngModel) =>{
                ngModel.$validators.swvalidationminlength =
                (modelValue, viewValue)=> {
                    return validationService.validateMinLength(viewValue.length,attributes.swvalidationminlength);
                };
            }
        };
    }
}
export{
    SWValidationMinLength
}