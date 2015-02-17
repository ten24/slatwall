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
			restrict: 'A',
			scope:{
				workflowTrigger:"=",
				workflowTriggers:"="
			},
			templateUrl:workflowPartialsPath+"workflowtrigger.html",
			link: function(scope, element,attrs){
				$log.debug('workflow trigger init');
				
				scope.selectWorkflowTrigger = function(workflowTrigger){
					$log.debug('selectWorkflowTrigger');
					scope.workflowTriggers.selectedTrigger = workflowTrigger;
					$log.debug(scope.workflowTriggers.selectedTrigger);
				};
				
				scope.deleteTrigger = function(workflowTrigger){
					var deleteTriggerPromise = $slatwall.saveEntity('WorkflowTrigger',workflowTrigger.data.workflowTriggerID,{},'Delete');
					deleteTriggerPromise.then(function(value){
						$log.debug('deleteTrigger');
						scope.workflowTriggers.splice(workflowTrigger.$$index,1);
					});
				};
			}
		};
	}
]);
	
