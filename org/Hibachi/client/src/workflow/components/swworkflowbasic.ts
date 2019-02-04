/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowBasic{
	public static Factory(){
		var directive=(
            workflowPartialsPath,
			hibachiPathBuilder
		)=>new SWWorkflowBasic(
            workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor( workflowPartialsPath, hibachiPathBuilder){

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
