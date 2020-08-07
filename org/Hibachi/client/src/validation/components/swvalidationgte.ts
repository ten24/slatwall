/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * SwValidationGTE: Validates true if the user value >= to the constraint value.
 * @usage <input type='text' swvalidationGte='5' /> will validate false if the user enters
 * value less than OR equal to 5.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationGte{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationGte =
                    function(modelValue, viewValue) {
                        return validationService.validateGte(modelValue,attributes.swvalidationGte);
                };//<--end function
            }//<--end link
        };
    }
    public static Factory(){
        var directive = (validationService)=> new SWValidationGte(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationGte
}


