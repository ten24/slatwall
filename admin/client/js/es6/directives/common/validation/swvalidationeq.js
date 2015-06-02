/**
 * SwValidationEQ: Validates true if the user value == the constraint value.
 * @usage <input type='text' swvalidationgte='5' /> will validate false if the user enters
 * value other than 5.
 */
angular.module('slatwalladmin').directive("swvalidationeq", [function () {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function (scope, element, attributes, ngModel) {
            ngModel.$validators.swvalidationeq = function (modelValue, viewValue) {
                var constraintValue = attributes.swvalidationeq;
                if (modelValue === constraintValue) {
                    return true;
                }
                else {
                    return false;
                }
            }; //<--end function
        } //<--end link
    };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationeq.js.map