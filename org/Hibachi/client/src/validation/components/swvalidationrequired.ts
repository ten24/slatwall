/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the uservalue is empty and false otherwise
 */
import {ValidationService} from "../services/validationservice";
class SWValidationRequired{
    //@ngInject
    constructor(validationService:ValidationService){

        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {

                ngModel.$validators.swvalidationrequired =
                function (modelValue, viewValue) {

                    var value = modelValue || viewValue;
                    return validationService.validateRequired(value);
                };
            }
        };
    }
    public static Factory(){
        var directive = (validationService)=>new SWValidationRequired(validationService);
        directive.$inject = ['validationService'];
        return directive;
    }
}
export{
    SWValidationRequired
}