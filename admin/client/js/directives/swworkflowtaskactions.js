angular.module('slatwalladmin')
.directive('swWorkflowTaskActions', [
'$log',
'$slatwall',
'workflowPartialsPath',
	function(
	$log,
	$slatwall,
	workflowPartialsPath
	){
		return {
			restrict: 'AE',
			scope:{
				workflowTask:"="
			},
			templateUrl:workflowPartialsPath+"workflowtaskactions.html",
			link: function(scope, element,attrs){
				$log.debug('workflow task actions init');	
				scope.openActions = false;
				
				scope.getWorkflowTaskActions = function(){
					console.log(scope.workflowTask);
					scope.workflowTaskActions = scope.workflowTask.$$getWorkflowTaskActions();
					$log.debug(scope.workflowTaskActions);
				};
				
				scope.getWorkflowTaskActions();
				
				scope.addWorkflowTaskAction = function(){
					var workflowTaskAction = scope.workflowTask.$$addWorkflowTaskAction();
					scope.selectWorkflowTaskAction(workflowTaskAction);
				};
				
				scope.selectWorkflowTaskAction = function(workflowTaskAction){
					scope.workflowTaskActions.selectedTaskAction = workflowTaskAction;
				};
				
				scope.removeWorkflowTaskAction = function(index){
					scope.workflowTasks.selectedTask.workflowTaskActions.splice(index,1);
					for(var i in scope.workflowTaskActions){
						scope.workflowTasks.selectedTask.workflowTaskActions[i].$$index = i;
					}
				};
			}
		};
	}
]);
	
