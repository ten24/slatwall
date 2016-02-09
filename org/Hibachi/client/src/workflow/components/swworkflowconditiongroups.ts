/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowConditionGroups{
	public static Factory(){
		var directive = (
			$log,
			workflowConditionService,
			workflowPartialsPath,
			hibachiPathBuilder
		)=> new SWWorkflowConditionGroups(
			$log,
			workflowConditionService,
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'workflowConditionService',
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		workflowConditionService,
		workflowPartialsPath,
		hibachiPathBuilder
	){
		return {
			restrict: 'E',
			scope:{
				workflowConditionGroupItem: "=",
				workflowConditionGroup:"=",
				workflow:"=",
				filterPropertiesList:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowconditiongroups.html",
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

