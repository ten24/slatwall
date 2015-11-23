class SWWorkflowConditionGroupItem{
	public static Factory(){
		var directive = (
			$log,
			$location,
			$slatwall,
			formService,
			workflowPartialsPath,
			pathBuilderConfig
		)=> new (
			$log,
			$location,
			$slatwall,
			formService,
			workflowPartialsPath,
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
	constructor(
		$log,
		$location,
		$slatwall,
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
