/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * SwValidationLTE: Validates true if the user value <= to the constraint value.
 * @usage <input type='number' swvalidationlte='5000' /> will validate false if the user enters
 * value greater than OR equal to 5,000.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationLte{
    constructor(validationService:ValidationService){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationlte =
                    function(modelValue, viewValue) {
                        return validationService.validateLte(modelValue,attributes.swvalidationlte);

                    };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=>new SWValidationLte(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationLte
}