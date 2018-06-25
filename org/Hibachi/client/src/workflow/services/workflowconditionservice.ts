
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Injectable, Inject} from "@angular/core";
import {$Hibachi} from "../../core/services/hibachiservice";
import {AlertService} from "../../alert/service/alertservice";

export class WorkflowCondition{
	public propertyIdentifer:string = "";
	public comparisonOperator:string = "";
	public value:string = "";
	public displayPropertyIdentifier:string="";
	public $$disabled:boolean=false;
	public $$isClosed=true;
	public $$isNew=true;
}

export class WorkflowConditionGroupItem{
	public workflowConditionGroup = [];

}

@Injectable()
export class WorkflowConditionService{

	public constructor(
		@Inject("$log") public $log:ng.ILogService ,
		$hibachi : $Hibachi ,
		alertService : AlertService
	){

	}
	public newWorkflowCondition () {
		return new WorkflowCondition;
	}
	public addWorkflowCondition (groupItem,condition) {
		this.$log.debug('addWorkflowCondition');
		this.$log.debug(groupItem);
		this.$log.debug(condition);
		if(groupItem.length >= 1){
			condition.logicalOperator = 'AND';
		}

		groupItem.push(condition);
	}
	public newWorkflowConditionGroupItem () {
		return new WorkflowConditionGroupItem;
	}
	public addWorkflowConditionGroupItem (group,groupItem) {
		group.push(groupItem);
	}
}

