/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the user value is greater than the max length.
 */
class SWValidationMaxLength{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationmaxlength =
                    function(modelValue, viewValue) {
                            //let required handle this case
                            if(modelValue == null){
                                return true;
                            }
                            var constraintValue = attributes.swvalidationmaxlength;
                            var userValue = viewValue || 0;
                            if (parseInt(viewValue.length) >= parseInt(constraintValue))
                            {
                                return true;
                            }
                        return false;

                    };
            }
        };
    }
    public static Factory(){
        var directive = ()=>new SWValidationMaxLength();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationMaxLength
}