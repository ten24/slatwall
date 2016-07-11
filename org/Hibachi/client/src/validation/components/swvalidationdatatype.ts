/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * True if the data type matches the given data type.
 */
/**
 * Validates true if the model value is a numeric value.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationDataType{
    public static Factory(){
        var directive = (
            validationService
        )=> new SWValidationDataType(
            validationService
        );
        directive.$inject = ['validationService'];
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
                var isValidFunction = (modelValue):boolean=> {
                    return validationService.validateDataType(modelValue,attributes.swvalidationdatatype);
                };
                ngModel.$validators.swvalidationdatatype = isValidFunction;
                ngModel.$validators['swvalidation'+attributes.swvalidationdatatype] = isValidFunction;
            }
        };
    }
}
export{
    SWValidationDataType
}
