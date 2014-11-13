'use strict';
angular.module('slatwalladmin')
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
	
	
	var workflowTriggerService = {
		
		formatWorkflowTrigger:function(workflowTriggerObject){
			var workflowTrigger = this.newWorkflowTrigger();
			for(var key in workflowTriggerObject){
				workflowTrigger[key] = workflowTriggerObject[key];
			}
			return workflowTrigger;
		},
		formatWorkflowTriggers:function(workflowTriggers){
			
			for(var i in workflowTriggers){
				workflowTriggers[i] = this.formatWorkflowTrigger(workflowTriggers[i]);
			}
			return workflowTriggers;
		}
	};
	
	return workflowTriggerService;
}]);
