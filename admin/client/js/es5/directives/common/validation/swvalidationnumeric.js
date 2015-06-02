"use strict";
angular.module('slatwalladmin').directive("swvalidationnumeric", [function() {
  return {
    restrict: "A",
    require: "^ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$validators.swvalidationnumeric = function(modelValue, viewValue) {
        if (!isNaN(viewValue)) {
          return true;
        } else {
          return false;
        }
      };
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationnumeric.js.map