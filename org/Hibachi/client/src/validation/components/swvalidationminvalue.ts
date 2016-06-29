/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the minimum value.
 */
class SWValidationMinValue{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationminvalue = 
                    function(modelValue, viewValue) {
                        //let required handle this case
                        if(modelValue == null){
                            return true;
                        }
                        var constraintValue = attributes.swvalidationminvalue;
                        var userValue = viewValue || 0;
                        if (parseInt(modelValue) >= parseInt(constraintValue))
                        {
                            return true;
                        }
                        return false;
                        
                    };
            }
        };
    }
    public static Factory(){
        var directive = ()=> new SWValidationMinValue();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationMinValue  
}
