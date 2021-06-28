/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowConditionGroups{
    
    public template = require("./workflowconditiongroups.html");
    public restrict = 'E';
	public scope = {
		workflowConditionGroupItem: "=",
		workflowConditionGroup:"=",
		workflow:"=",
		filterPropertiesList:"="
	};
	
	public static Factory(){
		return /** @ngInject */ ($log,workflowConditionService)=> new this($log,workflowConditionService);
	}
	
	// @ngInject
	constructor(private $log, private workflowConditionService){}
	
	public link: ng.IDirectiveLinkFn = (scope, element,attrs) => {
        this.$log.debug('workflowconditiongroups init');

		scope.addWorkflowCondition = () => {
			this.$log.debug('addWorkflowCondition');
			var workflowCondition = this.workflowConditionService.newWorkflowCondition();

			this.workflowConditionService.addWorkflowCondition(scope.workflowConditionGroupItem,workflowCondition);
		};

		scope.addWorkflowGroupItem = () => {
			this.$log.debug('addWorkflowGrouptItem');
			var workflowConditionGroupItem = this.workflowConditionService.newWorkflowConditionGroupItem();
			this.workflowConditionService.addWorkflowConditionGroupItem(scope.workflowConditionItem,workflowConditionGroupItem);
		};
	}

}
export{
	SWWorkflowConditionGroups
}

