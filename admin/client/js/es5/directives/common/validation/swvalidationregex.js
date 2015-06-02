"use strict";
angular.module('slatwalladmin').directive("swvalidationregex", [function() {
  return {
    restrict: "A",
    require: "^ngModel",
    link: function(scope, element, attributes, ngModel) {
      ngModel.$validators.swvalidationregex = function(modelValue) {
        var pattern = attributes.swvalidationregex;
        var regex = new RegExp(pattern);
        if (regex.test(modelValue)) {
          return true;
        } else {
          return false;
        }
      };
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationregex.js.map