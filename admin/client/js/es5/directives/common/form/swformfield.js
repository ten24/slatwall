"use strict";
angular.module('slatwalladmin').directive('swFormField', ['$log', '$templateCache', '$window', '$slatwall', 'formService', 'partialsPath', function($log, $templateCache, $window, $slatwall, formService, partialsPath) {
  return {
    require: "^form",
    restrict: 'AE',
    scope: {propertyDisplay: "="},
    templateUrl: partialsPath + 'formfields/formfield.html',
    link: function(scope, element, attrs, formController) {
      if (scope.propertyDisplay.object.$$getID() === '') {
        scope.propertyDisplay.isDirty = true;
      }
      if (angular.isDefined(formController[scope.propertyDisplay.property])) {
        scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
        formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
      }
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/form/swformfield.js.map