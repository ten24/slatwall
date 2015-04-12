"use strict";
angular.module('slatwalladmin').directive("swvalidationgte", [function() {
  return {
    restrict: "A",
    require: "^ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$validators.swvalidationgte = function(modelValue, viewValue) {
        var constraintValue = attributes.swvalidationgte || 0;
        if (parseInt(modelValue) >= parseInt(constraintValue)) {
          return true;
        }
        return false;
      };
    }
  };
}]);
