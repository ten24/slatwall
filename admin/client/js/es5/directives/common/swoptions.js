"use strict";
angular.module('slatwalladmin').directive('swOptions', ['$log', '$slatwall', 'observerService', 'partialsPath', function($log, $slatwall, observerService, partialsPath) {
  return {
    restrict: 'AE',
    scope: {objectName: '@'},
    templateUrl: partialsPath + "options.html",
    link: function(scope, element, attrs) {
      scope.swOptions = {};
      scope.swOptions.objectName = scope.objectName;
      scope.getOptions = function() {
        scope.swOptions.object = $slatwall['new' + scope.swOptions.objectName]();
        var columnsConfig = [{"propertyIdentifier": scope.swOptions.objectName.charAt(0).toLowerCase() + scope.swOptions.objectName.slice(1) + 'Name'}, {"propertyIdentifier": scope.swOptions.object.$$getIDName()}];
        $slatwall.getEntity(scope.swOptions.objectName, {
          allRecords: true,
          columnsConfig: angular.toJson(columnsConfig)
        }).then(function(value) {
          scope.swOptions.options = value.records;
          observerService.notify('optionsLoaded');
        });
      };
      scope.getOptions();
      var selectFirstOption = function() {
        scope.swOptions.selectOption(scope.swOptions.options[0]);
      };
      observerService.attach(selectFirstOption, 'selectFirstOption', 'selectFirstOption');
      scope.swOptions.selectOption = function(selectedOption) {
        scope.swOptions.selectedOption = selectedOption;
        observerService.notify('optionsChanged', selectedOption);
      };
    }
  };
}]);

//# sourceMappingURL=../../directives/common/swoptions.js.map