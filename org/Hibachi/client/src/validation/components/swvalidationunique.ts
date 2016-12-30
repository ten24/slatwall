/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
import {ValidationService} from "../services/validationservice";
class SWValidationUnique{
    //@ngInject
    constructor($http,$q,$hibachi,$log,validationService:ValidationService){
        return {
            restrict : "A",
            require : ["ngModel","^?swFormField"],
            link : function(scope, element, attributes, controllers) {
                var ngModel = controllers[0];

                ngModel.$asyncValidators.swvalidationunique = (modelValue, viewValue)=> {

                    var currentValue = modelValue || viewValue;
                    var objectName = controllers[1].object.metaData.className;
                    var property = controllers[1].property;
                    return validationService.validateUnique(currentValue,objectName,property);
                };

            }
        };
    }
    public static Factory(){
        var directive = ($http,$q,$hibachi,$log,validationService)=>new SWValidationUnique($http,$q,$hibachi,$log,validationService);
        directive.$inject = ['$http','$q','$hibachi','$log','validationService'];
        return directive;
    }
}
export{
    SWValidationUnique
}
