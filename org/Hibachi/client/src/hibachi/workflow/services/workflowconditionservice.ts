
class workflowCondition{
	public propertyIdentifer:string = "";
	public comparisonOperator:string = "";
	public value:string = "";
	public displayPropertyIdentifier:string="";
	public $$disabled:boolean=false;
	public $$isClosed=true;
	public $$isNew=true;
}

 class workflowConditionGroupItem{
	public workflowConditionGroup = [];
	
}

 class WorkflowConditionService{
	public static $inject = ["$log","$slatwall","alertService"];
	public constructor(private $log:ng.ILogService,$slatwall,alertService:slatwalladmin.IAlertService){
	}
	public newWorkflowCondition = () =>{
		return new workflowCondition;
	}
	public addWorkflowCondition = (groupItem,condition) =>{
		$log.debug('addWorkflowCondition');
		$log.debug(groupItem);
		$log.debug(condition);
		if(groupItem.length >= 1){
			condition.logicalOperator = 'AND';
		}
		
		groupItem.push(condition);
	}
	public newWorkflowConditionGroupItem = () =>{
		return new workflowConditionGroupItem;
	}
	public addWorkflowConditionGroupItem = (group,groupItem) =>{
		group.push(groupItem);
	}
}
export{
	WorkflowCondition,
	WorkflowConditionService
};

