"use strict";
'use strict';
angular.module('slatwalladmin').directive('swFormRegistrar', ['formService', function(formService) {
  return {
    restrict: 'E',
    require: "^form",
    link: function(scope, element, attrs, formController) {
      formController.$$swFormInfo = {
        object: scope.object,
        context: scope.context || 'save',
        name: scope.name
      };
      var makeRandomID = function makeid(count) {
        var text = "";
        var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        for (var i = 0; i < count; i++)
          text += possible.charAt(Math.floor(Math.random() * possible.length));
        return text;
      };
      scope.form = formController;
      formController.name = scope.name;
      formService.setForm(formController);
      if (angular.isUndefined(scope.object.forms)) {
        scope.object.forms = {};
      }
      scope.object.forms[scope.name] = formController;
      if (angular.isDefined(scope.context)) {}
    }
  };
}]);
