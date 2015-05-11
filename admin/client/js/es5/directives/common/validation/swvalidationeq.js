"use strict";
angular.module('slatwalladmin').directive("swvalidationeq", [function() {
  return {
    restrict: "A",
    require: "^ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$validators.swvalidationeq = function(modelValue, viewValue) {
        var constraintValue = attributes.swvalidationeq;
        if (modelValue === constraintValue) {
          return true;
        } else {
          return false;
        }
      };
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationeq.js.map