class SWWorkflowConditionGroupItem{
	public static Factory(){
		var directive = (
			$log,
			$location,
			$slatwall,
			formService,
			workflowPartialsPath
		)=> new (
			$log,
			$location,
			$slatwall,
			formService,
			workflowPartialsPath
		);
		directive.$inject = [
			'$log',
			'$location',
			'$slatwall',
			'formService',
			'workflowPartialsPath'
		];
		return directive;
	}
	constructor(
		$log,
		$location,
		$slatwall,
		formService,
		workflowPartialsPath
	){
		return {
			restrict: 'E',
			
			templateUrl:workflowPartialsPath+"workflowconditiongroupitem.html",
			link: function(scope, element,attrs){
			}
		};
	}
}
export{
	SWWorkflowConditionGroupItem
}
