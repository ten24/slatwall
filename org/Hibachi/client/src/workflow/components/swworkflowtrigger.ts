
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


import { Component, Inject, Input} from "@angular/core";
import {$Hibachi} from "../../core/services/hibachiservice";
import {AlertService} from "../../alert/service/alertservice";
import {MetaDataService} from "../../core/services/metadataservice";
import {HibachiPathBuilder} from "../../core/services/hibachipathbuilder";
import {UtilityService} from "../../core/services/utilityservice";



@Component({
	selector : "sw-workflow-trigger",
	templateUrl : "/slatwall/org/Hibachi/client/src/workflow/components/workflowtrigger.html",
	providers : [$Hibachi, AlertService,MetaDataService,HibachiPathBuilder,UtilityService]
})
export class  SWWorkflowTrigger {
	@Input() workflowtrigger;
	@Input() workflowtriggers;
	private done;
	private finished;
	private executingTrigger;

	constructor(
		@Inject("$http") public $http:any,
		private $hibachi : $Hibachi,
		private alertService : AlertService,
		private metadataService : MetaDataService,
		private hibachiPathBuilder : HibachiPathBuilder,
		private utilityService : UtilityService,
	){	
		this.done = false;
		this.finished = false;
		this.executingTrigger = false;
	}
	
	selectWorkflowTrigger = function(workflowTrigger){	
		this.workflowtriggers.selectedTrigger = undefined;
		var filterPropertiesPromise = this.$hibachi.getFilterPropertiesByBaseEntityName(workflowTrigger.data.workflow.data.workflowObject, true);
		filterPropertiesPromise.then((value)=>{
			var filterPropertiesList = {
				baseEntityName:		workflowTrigger.data.workflow.data.workflowObject,
				baseEntityAlias:"_"+ workflowTrigger.data.workflow.data.workflowObject
			};
			this.metadataService.setPropertiesList(value, workflowTrigger.data.workflow.data.workflowObject);
			filterPropertiesList[workflowTrigger.data.workflow.data.workflowObject] = this.metadataService.getPropertiesListByBaseEntityAlias(workflowTrigger.data.workflow.data.workflowObject);
			this.metadataService.formatPropertiesList(filterPropertiesList[workflowTrigger.data.workflow.data.workflowObject], workflowTrigger.data.workflow.data.workflowObject);
			this.workflowtriggers.selectedTrigger = workflowTrigger ;
		});
	};
	

	
	executeWorkflowTrigger = function(workflowTrigger){
		if(this.executingTrigger) return;

		if(!workflowTrigger.data.workflow.data.workflowTasks || !workflowTrigger.data.workflow.data.workflowTasks.length) {
			var alert = this.alertService.newAlert();
			alert.msg =  "You don't have any Task yet!";
			alert.type = "error";
			alert.fade = true;
			this.alertService.addAlert(alert);
			return;
		}
		this.executingTrigger = true;
		var appConfig = this.$hibachi.getConfig();
		var urlString = appConfig.baseURL+'/index.cfm/?'+appConfig.action+'=api:workflow.executeScheduleWorkflowTrigger&workflowTriggerID='+workflowTrigger.data.workflowTriggerID+'&x='+this.utilityService.createID();
		this.$http.get(urlString).success(()=>{
			this.executingTrigger = false;
			var alert = this.alertService.newAlert(); 
			alert.msg =  "Task Triggered Successfully. Check History for Status";
			alert.type = "success";
			alert.fade = true;
			this.alertService.addAlert(alert);
		})
		.error(()=>{
			var alert = this.alertService.newAlert(); 
			alert.msg =  "Something went wrong. Please Try Again";
			alert.type = "error";
			alert.fade = true;
			this.alertService.addAlert(alert);
		})
	};
	/**
	 * Overrides the delete function for the confirmation modal. Delegates to the normal delete method.
	 */
	
	deleteEntity(entity, index){
		this.deleteTrigger(entity, index);
	};

	/**
	 * Hard deletes a workflow trigger
	 */
	deleteTrigger(workflowTrigger, index){ 
		var deleteTriggerPromise = this.$hibachi.saveEntity('WorkflowTrigger',workflowTrigger.data.workflowTriggerID,{},'Delete');
		deleteTriggerPromise.then((value)=>{
			this.workflowtriggers.splice(index,1);
		});
	};



}