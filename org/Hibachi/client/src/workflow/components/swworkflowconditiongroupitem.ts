/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowConditionGroupItem{
	public static Factory(){
		var directive = (

			workflowPartialsPath,
			hibachiPathBuilder
		)=> new SWWorkflowConditionGroupItem(

			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [

			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(

		workflowPartialsPath,
			hibachiPathBuilder
	){
		return {
			restrict: 'E',

			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowconditiongroupitem.html",
			link: function(scope:any, element,attrs){
			}
		};
	}
}
export{
	SWWorkflowConditionGroupItem
}
