"use strict";
'use strict';
angular.module('slatwalladmin').directive('swForm', ['formService', function(formService) {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      object: "=",
      context: "@",
      name: "@"
    },
    template: '<ng-form><sw-form-registrar ng-transclude></sw-form-registrar></ng-form>',
    replace: true,
    link: function(scope, element, attrs) {
      scope.context = scope.context || 'save';
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/form/swform.js.map