angular.module('slatwalladmin')
.directive('swWorkflowCondition', [
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
			
			templateUrl:workflowPartialsPath+"workflowcondition.html",
			link: function(scope, element,attrs){
			}
		};
	}
]);
	
