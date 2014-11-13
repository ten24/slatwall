angular.module('slatwalladmin')
.directive('swWorkflowConditionGroups', 
[
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
			console.log(scope.workflowConditionGroup);
			console.log(scope.workflowConditionGroupItem);
			
			scope.addWorkflowCondition = function(){
				var workflowCondition = workflowConditionService.newWorkflowCondition();
				console.log(scope.workflowConditionGroupItem);
				workflowConditionService.addWorkflowCondition(workflowCondition,scope.workflowConditionGroupItem);
			};
			
			scope.addWorkflowGroupItem = function(){
				var workflowConditionGroupItem = workflowConditionService.newWorkflowConditionGroupItem();
				workflowConditionService.addWorkflowConditionGroupItem(scope.workflowConditionItem,workflowConditionGroupItem);
			};
		}
	};
}]);
	
