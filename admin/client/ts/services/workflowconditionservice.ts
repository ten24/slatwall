module slatwalladmin{
	export class workflowCondition{
		public propertyIdentifer:string = "";
		public comparisonOperator:string = "";
		public value:string = "";
		public displayPropertyIdentifier:string="";
		public $$disabled:boolean=false;
		public $$isClosed=true;
		public $$isNew=true;
	}
	
	export class workflowConditionGroupItem{
		public workflowConditionGroup = [];
		
	}
	
	export class WorkflowConditionService extends BaseService{
		public static $inject = ["$log","$slatwall","alertService"];
		public constructor(private $log:ng.ILogService,$slatwall,alertService:slatwalladmin.IAlertService){
			super();
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
	angular.module('slatwalladmin').service('workflowConditionService',WorkflowConditionService);
}
