var slatwalladmin;
(function (slatwalladmin) {
    class workflowCondition {
        constructor() {
            this.propertyIdentifer = "";
            this.comparisonOperator = "";
            this.value = "";
            this.displayPropertyIdentifier = "";
            this.$$disabled = false;
            this.$$isClosed = true;
            this.$$isNew = true;
        }
    }
    slatwalladmin.workflowCondition = workflowCondition;
    class workflowConditionGroupItem {
        constructor() {
            this.workflowConditionGroup = [];
        }
    }
    slatwalladmin.workflowConditionGroupItem = workflowConditionGroupItem;
    class WorkflowConditionService extends slatwalladmin.BaseService {
        constructor($log, $slatwall, alertService) {
            super();
            this.$log = $log;
            this.newWorkflowCondition = () => {
                return new workflowCondition;
            };
            this.addWorkflowCondition = (groupItem, condition) => {
                $log.debug('addWorkflowCondition');
                $log.debug(groupItem);
                $log.debug(condition);
                if (groupItem.length >= 1) {
                    condition.logicalOperator = 'AND';
                }
                groupItem.push(condition);
            };
            this.newWorkflowConditionGroupItem = () => {
                return new workflowConditionGroupItem;
            };
            this.addWorkflowConditionGroupItem = (group, groupItem) => {
                group.push(groupItem);
            };
        }
    }
    WorkflowConditionService.$inject = ["$log", "$slatwall", "alertService"];
    slatwalladmin.WorkflowConditionService = WorkflowConditionService;
    angular.module('slatwalladmin').service('workflowConditionService', WorkflowConditionService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=workflowconditionservice.js.map
