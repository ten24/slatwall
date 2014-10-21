//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
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
	//properties
	function _workflowTask(){
		this.workflowTaskID = "";
		this.activeFlag = 'Yes ';
		this.taskName = '';
		this.taskConditionsConfig.workflowConditionGroups = [
			{
				workflowConditionGroup:[
					
				]
			}
		];
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
	
	return workflowTaskService = {
		newWorkflowTask:function(){
			return new _workflowTask;
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
				workflowTasks[i] = formatWorkflowTask(workflowTasks[i]);
			}
			return workflowTasks;
		}
	};
}]);
