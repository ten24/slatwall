/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Returns true if the uservalue is empty and false otherwise
 */
class SWValidationRequired{
    constructor(){
        return {
            restrict: "A",
            require: "^ngModel",
            link: function(scope, element, attributes, ngModel) {
                    ngModel.$validators.swvalidationrequired =
                    function(modelValue, viewValue) {
                        var value = modelValue || viewValue;
                        if (value)
                        {
                            return true;
                        }
                        return false;
                    };
            }
        };
    }
    public static Factory(){
        var directive = ()=>new SWValidationRequired();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWValidationRequired
}