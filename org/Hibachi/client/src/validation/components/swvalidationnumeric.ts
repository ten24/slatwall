/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Validates true if the model value (user value) is a numeric value.
 * @event This event fires on every change to an input.
 */
class SWValidationNumeric{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                ngModel.$validators.swvalidationnumeric = 
                    function(modelValue, viewValue) {
                        //Returns true if this is not a number.
                        if (!isNaN(viewValue)){
                            return true;
                        }else{
                            return false;
                        }
                };
            }
        };
    }
    public static Factory(){
        var directive = () => new SWValidationNumeric();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationNumeric
}
