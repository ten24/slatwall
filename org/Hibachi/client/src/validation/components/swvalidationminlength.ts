/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the min length.
 */
/**
 * Returns true if the user value is greater than the minimum value.
 */
class SWValidationMinLength{
    public static Factory(){
        var directive = ($log)=> new SWValidationMinLength($log);
        directive.$inject = ['$log'];
        return directive;
    }
    constructor($log){
        return {
            restrict: "A",
            require: "^ngModel",
            link: (scope, element, attributes, ngModel) =>{
                    ngModel.$validators.swvalidationminlength = 
                    (modelValue, viewValue)=> {
                            //let required handle this case
                            if(modelValue == null){
                                return true;
                            }
                            var constraintValue = attributes.swvalidationminlength;
                            var userValue = viewValue || 0;
                            if (parseInt(viewValue.length) >= parseInt(constraintValue))
                            {
                                
                                return true;
                            }
                            $log.debug('invalid min length');
                        return false;
                        
                    };
            }
        };
    }
}
export{
    SWValidationMinLength
}