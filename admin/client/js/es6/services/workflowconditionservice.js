"use strict";
'use strict';
angular.module('slatwalladmin').factory('workflowConditionService', ['$log', '$slatwall', 'alertService', function($log, $slatwall, alertService) {
  function _workflowCondition() {
    this.propertyIdentifier = "";
    this.comparisonOperator = "";
    this.value = "";
    this.displayPropertyIdentifier = "";
    this.$$disabled = false;
    this.$$isClosed = true;
    this.$$isNew = true;
  }
  function _workflowConditionGroupItem() {
    this.workflowConditionGroup = [];
  }
  var workflowConditionService = {
    newWorkflowCondition: function() {
      return new _workflowCondition;
    },
    addWorkflowCondition: function(groupItem, condition) {
      $log.debug('addWorkflowCondition');
      $log.debug(groupItem);
      $log.debug(condition);
      if (groupItem.length >= 1) {
        condition.logicalOperator = 'AND';
      }
      groupItem.push(condition);
    },
    newWorkflowConditionGroupItem: function() {
      return new _workflowConditionGroupItem;
    },
    addWorkflowConditionGroupItem: function(group, groupItem) {
      group.push(groupItem);
    }
  };
  return workflowConditionService;
}]);
