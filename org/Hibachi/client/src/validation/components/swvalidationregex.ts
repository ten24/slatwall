/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Validates true if the model value matches a regex string.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationRegex{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationregex =
                (modelValue)=> {
                    //Returns true if this user value (model value) does match the pattern
                    return validationService.validateRegex(modelValue,attributes.swvalidationregex);
                };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=>new SWValidationRegex(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationRegex
}
