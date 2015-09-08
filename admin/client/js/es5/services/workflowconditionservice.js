var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var slatwalladmin;
(function (slatwalladmin) {
    var workflowCondition = (function () {
        function workflowCondition() {
            this.propertyIdentifer = "";
            this.comparisonOperator = "";
            this.value = "";
            this.displayPropertyIdentifier = "";
            this.$$disabled = false;
            this.$$isClosed = true;
            this.$$isNew = true;
        }
        return workflowCondition;
    })();
    slatwalladmin.workflowCondition = workflowCondition;
    var workflowConditionGroupItem = (function () {
        function workflowConditionGroupItem() {
            this.workflowConditionGroup = [];
        }
        return workflowConditionGroupItem;
    })();
    slatwalladmin.workflowConditionGroupItem = workflowConditionGroupItem;
    var WorkflowConditionService = (function (_super) {
        __extends(WorkflowConditionService, _super);
        function WorkflowConditionService($log, $slatwall, alertService) {
            _super.call(this);
            this.$log = $log;
            this.newWorkflowCondition = function () {
                return new workflowCondition;
            };
            this.addWorkflowCondition = function (groupItem, condition) {
                $log.debug('addWorkflowCondition');
                $log.debug(groupItem);
                $log.debug(condition);
                if (groupItem.length >= 1) {
                    condition.logicalOperator = 'AND';
                }
                groupItem.push(condition);
            };
            this.newWorkflowConditionGroupItem = function () {
                return new workflowConditionGroupItem;
            };
            this.addWorkflowConditionGroupItem = function (group, groupItem) {
                group.push(groupItem);
            };
        }
        WorkflowConditionService.$inject = ["$log", "$slatwall", "alertService"];
        return WorkflowConditionService;
    })(slatwalladmin.BaseService);
    slatwalladmin.WorkflowConditionService = WorkflowConditionService;
    angular.module('slatwalladmin').service('workflowConditionService', WorkflowConditionService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/workflowconditionservice.js.map