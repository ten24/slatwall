angular.module('slatwalladmin')
.directive('swWorkflowConditionGroupItem', [
	'$log',
	'$location',
	'$slatwall',
	'formService',
	'workflowPartialsPath',
	'workflowService',
	function(
		$log,
		$location,
		$slatwall,
		formService,
		workflowPartialsPath,
		workflowService
	){
		return {
			restrict: 'A',
			
			templateUrl:workflowPartialsPath+"workflowconditiongroupitem.html",
			link: function(scope, element,attrs){
			}
		};
	}
]);
	
