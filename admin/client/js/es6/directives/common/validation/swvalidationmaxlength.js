/**
 * Returns true if the user value is greater than the max length.
 */
angular.module('slatwalladmin').directive("swvalidationmaxlength", [function () {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function (scope, element, attributes, ngModel) {
            ngModel.$validators.swvalidationmaxlength = function (modelValue, viewValue) {
                var constraintValue = attributes.swvalidationmaxlength;
                var userValue = viewValue || 0;
                if (parseInt(viewValue.length) >= parseInt(constraintValue)) {
                    return true;
                }
                return false;
            };
        }
    };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationmaxlength.js.map