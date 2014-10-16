//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('workflowTriggerService',
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
	function _workflowTrigger(){
		this.workflowTriggerID = "";
		this.triggerType = 'Event';
		this.objectPropertyIdentifier = '';
		this.triggerEvent = '';
	}
		
	_workflowTrigger.prototype = {
		isPersisted:function(){
			if(this.workflowTriggerID === ''){
				return false;
			}else{
				return true;
			}
		}
	};
	
	return workflowTriggerService = {
		newWorkflowTrigger:function(){
			return new _workflowTrigger;
		},
		formatWorkflowTrigger:function(workflowTriggerObject){
			var workflowTrigger = this.newWorkflowTrigger();
			for(key in workflowTriggerObject){
				workflowTrigger[key] = workflowTriggerObject[key];
			}
			return workflowTrigger;
		},
		formatWorkflowTriggers:function(workflowTriggers){
			for(var i in workflowTriggers){
				workflowTriggers[i] = formatWorkflowTrigger(workflowTriggers[i]);
			}
			return workflowTriggers;
		}
	};
}]);
