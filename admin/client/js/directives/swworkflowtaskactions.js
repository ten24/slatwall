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
					var workflowTaskPromise = scope.workflowTask.$$getWorkflowTaskActions();
					workflowTaskPromise.then(function(){
						scope.workflowTaskActions = scope.workflowTask.workflowTaskActions;
						$log.debug(scope.workflowTaskActions);
					});
				};
				
				scope.getWorkflowTaskActions();
				
				scope.addWorkflowTaskAction = function(){
					var workflowTaskAction = scope.workflowTask.$$addWorkflowTaskAction();
					scope.selectWorkflowTaskAction(workflowTaskAction);
				};
				
				scope.selectWorkflowTaskAction = function(workflowTaskAction){
					scope.workflowTaskActions.selectedTaskAction = workflowTaskAction;
				};
				
				scope.removeWorkflowTaskAction = function(workflowTaskAction){
					var deletePromise = workflowTaskAction.$$delete();
		    		deletePromise.then(function(){
						if(workflowTaskAction === scope.workflowTaskActions.selectedTaskAction){
							delete scope.workflowTaskActions.selectedTaskAction;
						}
						scope.workflowTaskActions.splice(workflowTaskAction.$$index,1);
						for(var i in scope.workflowTaskActions){
							scope.workflowTaskActions[i].$$index = i;
						}
					});
					
					scope.workflowTask.workflowTaskActions.splice(index,1);
					for(var i in scope.workflowTaskActions){
						scope.workflowTasks.selectedTask.workflowTaskActions[i].$$index = i;
					}
				};
			}
		};
	}
]);
	
