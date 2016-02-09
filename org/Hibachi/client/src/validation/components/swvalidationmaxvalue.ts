/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the min value.
 */
class SWValidationMaxValue{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationmaxvalue = 
                    function(modelValue, viewValue) {
    
                            var constraintValue = attributes.swvalidationmaxvalue;
                            var userValue = viewValue || 0;
                            if (parseInt(viewValue) <= parseInt(constraintValue))
                            {
                                return true;
                            }
                        return false;
                        
                    };
            }
        };
    }
    public static Factory(){
        var directive = ()=>new SWValidationMaxValue();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationMaxValue
}