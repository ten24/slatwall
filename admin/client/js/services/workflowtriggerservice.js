'use strict';
angular.module('slatwalladmin')
.factory('workflowTriggerService', [
	'$log',
	'$slatwall',
	'alertService',
	function(
		$log,
		$slatwall,
		alertService
	){
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
		
		var workflowTriggerService = {
			newWorkflowTrigger:function(){
				return new _workflowTrigger;
			},
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
	}
]);
