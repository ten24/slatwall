angular.module('slatwalladmin')
.directive('swWorkflowConditionGroups', [
	'$log',
	'workflowTaskService',
	'workflowPartialsPath',
	function(
		$log,
		workflowTaskService,
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
				scope.addWorkflowCondition = function(){
					var workflowCondition = workflowTaskService.newWorkflowCondition();
					workflowTaskService.addWorkflowCondition(scope.workflowConditionGroupItem,workflowCondition);
				};
				
				scope.addWorkflowGroupItem = function(){
					var workflowConditionGroupItem = workflowTaskService.newWorkflowConditionGroupItem();
					workflowTaskService.addWorkflowConditionGroupItem(scope.workflowConditionItem,workflowConditionGroupItem);
				};
			}
		};
	}
]);
	
