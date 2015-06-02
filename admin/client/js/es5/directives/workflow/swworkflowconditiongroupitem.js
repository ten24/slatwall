"use strict";
angular.module('slatwalladmin').directive('swWorkflowConditionGroupItem', ['$log', '$location', '$slatwall', 'formService', 'workflowPartialsPath', function($log, $location, $slatwall, formService, workflowPartialsPath) {
  return {
    restrict: 'E',
    templateUrl: workflowPartialsPath + "workflowconditiongroupitem.html",
    link: function(scope, element, attrs) {}
  };
}]);

//# sourceMappingURL=../../directives/workflow/swworkflowconditiongroupitem.js.map