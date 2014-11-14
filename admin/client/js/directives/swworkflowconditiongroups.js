angular.module('slatwalladmin')
.directive('swWorkflowConditionGroups', [
'$log',
'workflowConditionService',
'workflowPartialsPath',
	function(
	$log,
	workflowConditionService,
	workflowPartialsPath
	){
		return {
			restrict: 'A',
			scope:{
				workflowConditionGroupItem: "=",
				workflowConditionGroup:"="
			},
			templateUrl:workflowPartialsPath+"workflowconditiongroups.html",
			link: function(scope, element,attrs){
				$log.debug('workflowconditiongroups init');
				
				scope.addWorkflowCondition = function(){
					$log.debug('addWorkflowCondition');
					var workflowCondition = workflowConditionService.newWorkflowCondition();
					
					workflowConditionService.addWorkflowCondition(scope.workflowConditionGroupItem,workflowCondition);
				};
				
				scope.addWorkflowGroupItem = function(){
					$log.debug('addWorkflowGrouptItem');
					var workflowConditionGroupItem = workflowConditionService.newWorkflowConditionGroupItem();
					workflowConditionService.addWorkflowConditionGroupItem(scope.workflowConditionItem,workflowConditionGroupItem);
				};
			}
		};
	}
]);
	
