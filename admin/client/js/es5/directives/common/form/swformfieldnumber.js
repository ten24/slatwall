"use strict";
angular.module('slatwalladmin').directive('swFormFieldNumber', ['$log', '$slatwall', 'formService', 'partialsPath', function($log, $slatwall, formService, partialsPath) {
  return {
    templateUrl: partialsPath + 'formfields/number.html',
    require: "^form",
    restrict: 'E',
    scope: {propertyDisplay: "="},
    link: function(scope, element, attr, formController) {
      scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/form/swformfieldnumber.js.map