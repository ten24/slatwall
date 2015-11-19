class SWWorkflowBasic{
	public static Factory(){
		var directive=(
			$log, $location, $slatwall, formService, workflowPartialsPath
		)=>new SWWorkflowBasic(
			$log, $location, $slatwall, formService, workflowPartialsPath
		);
		directive.$inject = [
			'$log',
			'$location',
			'$slatwall',
			'formService',
			'workflowPartialsPath',
		];
		return directive;
	}
	constructor($log, $location, $slatwall, formService, workflowPartialsPath){
		return {
			restrict : 'A',
			scope : {
				workflow : "="
			},
			templateUrl : workflowPartialsPath
					+ "workflowbasic.html",
			link : function(scope, element, attrs) {
			}
		}; 
	}
}
export{
	SWWorkflowBasic
}
