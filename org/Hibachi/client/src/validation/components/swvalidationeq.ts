/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * SwValidationEQ: Validates true if the user value == the constraint value.
 * @usage <input type='text' swvalidationgte='5' /> will validate false if the user enters
 * value other than 5.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationEq{
    public static Factory(){
        var directive = (
            validationService
        )=> new SWValidationEq(
            validationService
        );
        directive.$inject=[
            'validationService'
        ];
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
                    ngModel.$validators.swvalidationeq =
                    function(modelValue, viewValue) {
                        return validationService.validateEq(modelValue,attributes.swvalidationeq);
                };//<--end function
            }//<--end link
        };
    }

}
export{
    SWValidationEq
}
