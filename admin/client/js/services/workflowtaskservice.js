
angular.module('slatwalladmin')
.factory('workflowTaskService',
[
	'$log',
	'$slatwall',
	'alertService',
function(
	$log,
	$slatwall,
	alertService
){
	function _workflowTask(){
		this.workflowTaskID = "";
		this.activeFlag = 'Yes ';
		this.taskName = '';
		this.taskConditionsConfig = {
			workflowConditionGroups : [
		
				{
					workflowConditionGroup:[
						
					]
				}
			]
		};
		this.workflowTaskActions = [];
	}
	
	_workflowTask.prototype = {
		isPersisted:function(){
			if(this.workflowTaskID === ''){
				return false;
			}else{
				return true;
			}
		}
	};
	
	function _workflowTaskAction(){
		this.workflowTaskActionID = "";
		this.actionType = 'Print';
		this.updateData = '';
		this.emailTemplateID = '';
		this.printTemplateID = '';
	}
	
	_workflowTaskAction.prototype = {
		isPersisted:function(){
			if(this.workflowTaskActionID === ''){
				return false;
			}else{
				return true;
			}
		}
	};
	
	function _workflowCondition(){
		this.propertyIdentifier = "";
		this.comparisonOperator = "";
		this.value = "";
	}
	
	function _workflowConditionGroupItem(){
		this.workflowConditionGroup = [];
	}
		
	
	return workflowTaskService = {
		newWorkflowTask:function(){
			return new _workflowTask;
		},
		
		newWorkflowTaskAction:function(){
			return new _workflowTaskAction;
		},
		
		addWorkflowTaskAction:function(taskActions,taskAction){
			taskActions.push(taskAction);
		},
		
		newWorkflowCondition:function(){
			return new _workflowCondition;
		},
		
		addWorkflowCondition:function(groupItem,condition){
			$log.debug('addWorkflowCondition');
			$log.debug(groupItem);
			$log.debug(condition);
			groupItem.push(condition);
		},
		newWorkflowConditionGroupItem:function(){
			return new _workflowConditionGroupItem;
		},
		addWorkflowConditionGroupItem:function(group,groupItem){
			group.push(groupItem);
		},
		formatWorkflowTask:function(workflowTaskObject){
			var workflowTask = this.newWorkflowTask();
			for(key in workflowTaskObject){
				workflowTask[key] = workflowTaskObject[key];
			}
			return workflowTask;
		},
		formatWorkflowTasks:function(workflowTasks){
			for(var i in workflowTasks){
				workflowTasks[i] = this.formatWorkflowTask(workflowTasks[i]);
			}
			return workflowTasks;
		}
	};
}]);
