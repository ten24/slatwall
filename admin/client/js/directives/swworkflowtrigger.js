angular.module('slatwalladmin')
.directive('swWorkflowTrigger', [
	'$log',
	'$slatwall',
	'workflowPartialsPath',
	function(
		$log,
		$slatwall,
		workflowPartialsPath
	){
		return {
			require:"^form",
			restrict: 'A',
			scope:{
				workflowTrigger:"=",
				workflowTriggers:"="
			},
			templateUrl:workflowPartialsPath+"workflowtrigger.html",
			link: function(scope, element,attrs,formController){
				$log.debug('workflow trigger init');
				
				scope.deleteTrigger = function(workflowTrigger){
					var deleteTriggerPromise = $slatwall.saveEntity('WorkflowTrigger',workflowTrigger.workflowTriggerID,{},'Delete');
					deleteTriggerPromise.then(function(value){
						$log.debug('deleteTrigger');
						scope.workflowTriggers.splice(workflowTrigger.$$index,1);
					});
				};
			}
		};
	}
]);
	
