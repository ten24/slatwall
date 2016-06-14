/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowBasic{
	public static Factory(){
		var directive=(
			$log, $location, $hibachi, formService, workflowPartialsPath,
			hibachiPathBuilder
		)=>new SWWorkflowBasic(
			$log, $location, $hibachi, formService, workflowPartialsPath,
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
	constructor($log, $location, $hibachi, formService, workflowPartialsPath,
			hibachiPathBuilder){

		return {
			restrict : 'A',
			scope : {
				workflow : "="
			},
			templateUrl : hibachiPathBuilder.buildPartialsPath(workflowPartialsPath) + "workflowbasic.html",
			link : function(scope, element, attrs) {
			}
		};
	}
}
export{
	SWWorkflowBasic
}
