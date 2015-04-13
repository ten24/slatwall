"use strict";
angular.module('slatwalladmin').directive('swWorkflowTasks', ['$log', '$location', '$slatwall', 'metadataService', 'collectionService', 'workflowPartialsPath', function($log, $location, $slatwall, metadataService, collectionService, workflowPartialsPath) {
  return {
    restrict: 'A',
    scope: {workflow: "="},
    templateUrl: workflowPartialsPath + "workflowtasks.html",
    link: function(scope, element, attrs) {
      scope.workflowPartialsPath = workflowPartialsPath;
      scope.propertiesList = {};
      function logger(context, message) {
        $log.debug("SwWorkflowTasks :" + context + " : " + message);
      }
      scope.getWorkflowTasks = function() {
        logger("getWorkflowTasks", "Retrieving items");
        logger("getWorkflowTasks", "Workflow Tasks");
        $log.debug(scope.workflowTasks);
        if (angular.isUndefined(scope.workflow.data.workflowTasks)) {
          var workflowTasksPromise = scope.workflow.$$getWorkflowTasks();
          workflowTasksPromise.then(function() {
            scope.workflowTasks = scope.workflow.data.workflowTasks;
          });
        } else {
          logger("getWorkflowTasks", "Retrieving cached Items");
          scope.workflowTasks = scope.workflow.data.workflowTasks;
        }
        if (angular.isUndefined(scope.workflow.data.workflowTasks)) {
          logger("getWorkflowTasks", "workflowTasks is undefined.");
          scope.workflow.data.workflowTasks = [];
          scope.workflowTasks = scope.workflow.data.workflowTasks;
        }
      };
      scope.getWorkflowTasks();
      scope.setHidden = function(task) {
        if (!angular.isObject(task) || angular.isUndefined(task.hidden)) {
          task.hidden = false;
        } else {
          logger("setHidden()", "Setting Hide Value To " + !task.hidden);
          task.hidden = !task.hidden;
        }
      };
      scope.addWorkflowTask = function() {
        logger('addWorkflowTasks', "Calling $$addWorkflowTask");
        var newWorkflowTask = scope.workflow.$$addWorkflowTask();
        logger("var newWorkflowTask", newWorkflowTask);
        scope.selectWorkflowTask(newWorkflowTask);
      };
      scope.$watch('workflowTasks.selectedTask.data.workflow.data.workflowObject', function(newValue, oldValue) {
        logger("scope.$watch", "Change Detected " + newValue + " from " + oldValue);
        if ((newValue !== oldValue && angular.isDefined(scope.workflowTasks.selectedTask))) {
          logger("scope.$watch", "Change to " + newValue);
          scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityAlias = newValue;
          scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityName = newValue;
        }
      });
      scope.saveWorkflowTask = function(task, context) {
        scope.done = true;
        $log.debug("Context: " + context);
        $log.debug("saving task");
        $log.debug(scope.workflowTasks.selectedTask);
        var savePromise = scope.workflowTasks.selectedTask.$$save();
        savePromise.then(function() {
          if (context === 'add') {
            logger("SaveWorkflowTask", "Save and New");
            scope.addWorkflowTask();
            scope.finished = true;
          } else if (context == "finish") {
            scope.finished = false;
          }
        });
        scope.setHidden(scope.workflowTasks.selectedTask);
      };
      scope.selectWorkflowTask = function(workflowTask) {
        scope.done = false;
        logger("selectWorkflowTask", "selecting a workflow task");
        $log.debug(workflowTask);
        scope.finished = false;
        scope.workflowTasks.selectedTask = undefined;
        var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(scope.workflow.data.workflowObject);
        filterPropertiesPromise.then(function(value) {
          scope.filterPropertiesList = {
            baseEntityName: scope.workflow.data.workflowObject,
            baseEntityAlias: "_" + scope.workflow.data.workflowObject
          };
          metadataService.setPropertiesList(value, scope.workflow.data.workflowObject);
          scope.filterPropertiesList[scope.workflow.data.workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(scope.workflow.data.workflowObject);
          metadataService.formatPropertiesList(scope.filterPropertiesList[scope.workflow.data.workflowObject], scope.workflow.data.workflowObject);
          scope.workflowTasks.selectedTask = workflowTask;
        });
      };
      scope.softRemoveTask = function(workflowTask) {
        logger("SoftRemoveTask", "calling delete");
        if (workflowTask === scope.workflowTasks.selectedTask) {
          delete scope.workflowTasks.selectedTask;
        }
        scope.removeIndexFromTasks(workflowTask.$$index);
        scope.reindexTaskList();
      };
      scope.hardRemoveTask = function(workflowTask) {
        logger("HardRemoveTask", "$$delete");
        var deletePromise = workflowTask.$$delete();
        deletePromise.then(function() {
          if (workflowTask === scope.workflowTasks.selectedTask) {
            delete scope.workflowTasks.selectedTask;
          }
          scope.removeIndexFromTasks(workflowTask.$$index);
          scope.reindexTaskList();
        });
      };
      scope.deleteEntity = function(entity) {
        scope.hardRemoveTask(entity);
      };
      scope.reindexTaskList = function() {
        for (var i in scope.workflowTasks) {
          logger("ReIndexing the list", i);
          scope.workflowTasks[i].$$index = i;
        }
      };
      scope.removeIndexFromTasks = function(index) {
        logger("RemoveIndexFromTasks", index);
        scope.workflowTasks.splice(index, 1);
      };
    }
  };
}]);
