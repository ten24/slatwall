/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowConditionGroupItem{
	public static Factory(){
		var directive = (
			$log,
			$location,
			$hibachi,
			formService,
			workflowPartialsPath,
			pathBuilderConfig
		)=> new (
			$log,
			$location,
			$hibachi,
			formService,
			workflowPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'$location',
			'$hibachi',
			'formService',
			'workflowPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$log,
		$location,
		$hibachi,
		formService,
		workflowPartialsPath,
			pathBuilderConfig
	){
		return {
			restrict: 'E',

			templateUrl:pathBuilderConfig.buildPartialsPath(workflowPartialsPath)+"workflowconditiongroupitem.html",
			link: function(scope, element,attrs){
			}
		};
	}
}
export{
	SWWorkflowConditionGroupItem
}
