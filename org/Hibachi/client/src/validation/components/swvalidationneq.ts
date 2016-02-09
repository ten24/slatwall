/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 *  Validates true if the user value != the property value.
 */
class SWValidationNeq{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationneq = 
                    function(modelValue) {
                        if (modelValue != attributes.swvalidationneq){return true;}
                        return false;
                };
            }
        };
    }
    public static Factory(){
        var directive = ()=>new SWValidationNeq();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationNeq
}
