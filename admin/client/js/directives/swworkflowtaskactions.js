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
						scope.workflowTaskActions = scope.workflowTask.data.workflowTaskActions;
						$log.debug(scope.workflowTaskActions);
					});
					if(angular.isUndefined(scope.workflowTask.data.workflowTaskActions)){
						scope.workflowTask.data.workflowTaskActions = [];
						scope.workflowTaskActions = scope.workflowTask.data.workflowTaskActions;
					}
				};

				scope.saveWorkflowTaskAction = function(){
					var savePromise = scope.workflowTaskActions.selectedTaskAction.$$save();
					savePromise.then(function(){
					});
				}
				
				scope.getWorkflowTaskActions();
				
				scope.addWorkflowTaskAction = function(){
					var workflowTaskAction = scope.workflowTask.$$addWorkflowTaskAction();
					scope.selectWorkflowTaskAction(workflowTaskAction);
					console.log(scope.workflow);
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
	
