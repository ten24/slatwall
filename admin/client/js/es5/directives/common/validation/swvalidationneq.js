"use strict";
angular.module('slatwalladmin').directive("swvalidationneq", [function() {
  return {
    restrict: "A",
    require: "^ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$validators.swvalidationneq = function(modelValue) {
        if (modelValue != attributes.swvalidationneq) {
          return true;
        }
        return false;
      };
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationneq.js.map