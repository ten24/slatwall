"use strict";

/**
 * SwValidationLTE: Validates true if the user value <= to the constraint value.
 * @usage <input type='number' swvalidationlte='5000' /> will validate false if the user enters
 * value greater than OR equal to 5,000.
 */
angular.module("slatwalladmin").directive("swvalidationlte", [function () {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function (scope, element, attributes, ngModel) {
            ngModel.$validators.swvalidationlte = function (modelValue, viewValue) {
                var constraintValue = attributes.swvalidationlte;
                var userValue = viewValue || 0;
                if (parseInt(viewValue) <= parseInt(constraintValue)) {
                    return true;
                }
                return false;
            };
        }
    };
}]);