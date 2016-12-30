/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationUniqueOrNull{
    //@ngInject
    constructor($http,$q,$hibachi,$log,validationService:ValidationService){
        return {
            restrict : "A",
            require : "ngModel",
            link : function(scope, element, attributes, ngModel) {
                ngModel.$asyncValidators.swvalidationuniqueornull =  (modelValue, viewValue)=> {
                    var currentValue = modelValue || viewValue;
                    var objectName = scope.propertyDisplay.object.metaData.className;
                    var property = scope.propertyDisplay.property;

                    return validationService.validateUniqueOrNull(currentValue,objectName,property);
                };

            }
        };
    }
    public static Factory(){
        var directive = ($http,$q,$hibachi,$log,validationService)=>new SWValidationUniqueOrNull($http,$q,$hibachi,$log,validationService);
        directive.$inject = ['$http','$q','$hibachi','$log','validationService'];
        return directive;
    }
}
export{
    SWValidationUniqueOrNull
}