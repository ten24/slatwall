/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * SwValidationGTE: Validates true if the user value >= to the constraint value.
 * @usage <input type='text' swvalidationGte='5' /> will validate false if the user enters
 * value less than OR equal to 5.
 */
class SWValidationGte{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationGte = 
                    function(modelValue, viewValue) {
                        var constraintValue = attributes.swvalidationGte || 0;
                        if (parseInt(modelValue) >= parseInt(constraintValue))
                        {
                            return true; //Passes the validation
                        }
                        return false;
                        
                };//<--end function
            }//<--end link
        };
    }
    public static Factory(){
        var directive = ()=> new SWValidationGte();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationGte
}


