"use strict";
angular.module('slatwalladmin').directive("swvalidationlte", [function() {
  return {
    restrict: "A",
    require: "^ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$validators.swvalidationlte = function(modelValue, viewValue) {
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

//# sourceMappingURL=../../../directives/common/validation/swvalidationlte.js.map