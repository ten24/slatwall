
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class WorkflowCondition{
	public propertyIdentifer:string = "";
	public comparisonOperator:string = "";
	public value:string = "";
	public displayPropertyIdentifier:string="";
	public $$disabled:boolean=false;
	public $$isClosed=true;
	public $$isNew=true;
}

 class WorkflowConditionGroupItem{
	public workflowConditionGroup = [];

}

 class WorkflowConditionService{
	public static $inject = ["$log","$hibachi","alertService"];
	public constructor(public $log:ng.ILogService,$hibachi,alertService){

	}
	public newWorkflowCondition = () =>{
		return new WorkflowCondition;
	}
	public addWorkflowCondition = (groupItem,condition) =>{
		this.$log.debug('addWorkflowCondition');
		this.$log.debug(groupItem);
		this.$log.debug(condition);
		if(groupItem.length >= 1){
			condition.logicalOperator = 'AND';
		}

		groupItem.push(condition);
	}
	public newWorkflowConditionGroupItem = () =>{
		return new WorkflowConditionGroupItem;
	}
	public addWorkflowConditionGroupItem = (group,groupItem) =>{
		group.push(groupItem);
	}
}
export{
	WorkflowCondition,
	WorkflowConditionService,
	WorkflowConditionGroupItem
};

