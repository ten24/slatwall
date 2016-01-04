/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
class SWWorkflowBasic{
	public static Factory(){
		var directive=(
			$log, $location, $slatwall, formService, workflowPartialsPath,
			pathBuilderConfig
		)=>new SWWorkflowBasic(
			$log, $location, $slatwall, formService, workflowPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'$location',
			'$slatwall',
			'formService',
			'workflowPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor($log, $location, $slatwall, formService, workflowPartialsPath,
			pathBuilderConfig){

		return {
			restrict : 'A',
			scope : {
				workflow : "="
			},
			templateUrl : pathBuilderConfig.buildPartialsPath(workflowPartialsPath)
					+ "workflowbasic.html",
			link : function(scope, element, attrs) {
				console.log('workflowtest');
				console.log(scope.workflow);
			}
		};
	}
}
export{
	SWWorkflowBasic
}
