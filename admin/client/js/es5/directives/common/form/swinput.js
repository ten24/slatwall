"use strict";
'use strict';
angular.module('slatwalladmin').directive('swInput', ['$log', '$compile', 'utilityService', function($log, $compile, utilityService) {
  var getValidationDirectives = function(propertyDisplay) {
    var spaceDelimitedList = '';
    var name = propertyDisplay.property;
    var form = propertyDisplay.form.$$swFormInfo;
    $log.debug("Name is:" + name + " and form is: " + form);
    var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
    $log.debug("Validations: ");
    console.dir(validations);
    var validationsForContext = [];
    var formContext = propertyDisplay.form.$$swFormInfo.context;
    var formName = propertyDisplay.form.$$swFormInfo.name;
    $log.debug("Form context is: ");
    $log.debug(formContext);
    $log.debug("Form Name: ");
    $log.debug(formName);
    var propertyValidations = propertyDisplay.object.validations.properties[name];
    if (angular.isObject(propertyValidations)) {
      if (propertyValidations[0].contexts === formContext) {
        $log.debug("Matched");
        for (var prop in propertyValidations[0]) {
          if (prop != "contexts" && prop !== "conditions") {
            spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");
          }
        }
      }
      $log.debug(spaceDelimitedList);
    }
    $log.debug(validations);
    $log.debug(form);
    $log.debug(propertyDisplay);
    angular.forEach(validations, function(validation, key) {
      if (utilityService.listFind(validation.contexts.toLowerCase(), form.context.toLowerCase()) !== -1) {
        $log.debug("Validations for context");
        $log.debug(validation);
        validationsForContext.push(validation);
      }
    });
    return spaceDelimitedList;
  };
  var getTemplate = function(propertyDisplay) {
    var template = '';
    var validations = '';
    if (!propertyDisplay.noValidate) {
      validations = getValidationDirectives(propertyDisplay);
    }
    if (propertyDisplay.fieldType === 'text') {
      template = '<input type="text" class="form-control" ' + 'ng-model="propertyDisplay.object.data[propertyDisplay.property]" ' + 'ng-disabled="!propertyDisplay.editable" ' + 'ng-show="propertyDisplay.editing" ' + 'name="' + propertyDisplay.property + '" ' + validations + 'id="swinput' + utilityService.createID(26) + '"' + ' />';
    }
    return template;
  };
  return {
    require: '^form',
    scope: {propertyDisplay: "="},
    restrict: "E",
    link: function(scope, element, attr, formController) {
      element.html(getTemplate(scope.propertyDisplay));
      $compile(element.contents())(scope);
    }
  };
}]);

//# sourceMappingURL=../../../directives/common/form/swinput.js.map