/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
class SWWorkflowConditionGroups{
	public static Factory(){
		var directive = (
			$log,
			workflowConditionService,
			workflowPartialsPath,
			pathBuilderConfig
		)=> new SWWorkflowConditionGroups(
			$log,
			workflowConditionService,
			workflowPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'workflowConditionService',
			'workflowPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$log,
		workflowConditionService,
		workflowPartialsPath,
		pathBuilderConfig
	){
		return {
			restrict: 'E',
			scope:{
				workflowConditionGroupItem: "=",
				workflowConditionGroup:"=",
				workflow:"=",
				filterPropertiesList:"="
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(workflowPartialsPath)+"workflowconditiongroups.html",
			link: function(scope, element,attrs){
				$log.debug('workflowconditiongroups init');

				scope.addWorkflowCondition = function(){
					$log.debug('addWorkflowCondition');
					var workflowCondition = workflowConditionService.newWorkflowCondition();

					workflowConditionService.addWorkflowCondition(scope.workflowConditionGroupItem,workflowCondition);
				};

				scope.addWorkflowGroupItem = function(){
					$log.debug('addWorkflowGrouptItem');
					var workflowConditionGroupItem = workflowConditionService.newWorkflowConditionGroupItem();
					workflowConditionService.addWorkflowConditionGroupItem(scope.workflowConditionItem,workflowConditionGroupItem);
				};
			}
		};
	}
}
export{
	SWWorkflowConditionGroups
}

