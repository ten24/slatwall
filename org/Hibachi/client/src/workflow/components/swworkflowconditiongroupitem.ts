/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowConditionGroupItem{
	public static Factory(){
		var directive = (
			$log,
			$location,
			$hibachi,
			formService,
			workflowPartialsPath,
			hibachiPathBuilder
		)=> new (
			$log,
			$location,
			$hibachi,
			formService,
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$location',
			'$hibachi',
			'formService',
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$location,
		$hibachi,
		formService,
		workflowPartialsPath,
			hibachiPathBuilder
	){
		return {
			restrict: 'E',

			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowconditiongroupitem.html",
			link: function(scope, element,attrs){
			}
		};
	}
}
export{
	SWWorkflowConditionGroupItem
}
