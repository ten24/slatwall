angular.module('slatwalladmin')
.directive('swWorkflowTasks', 
[
'$log',
'$location',
'$slatwall',
'workflowTaskService',
'metadataService',
'workflowPartialsPath',
function(
$log,
$location,
$slatwall,
workflowTaskService,
metadataService,
workflowPartialsPath
){
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			workflow:"="
		},
		templateUrl:workflowPartialsPath+"workflowtasks.html",
		link: function(scope, element,attrs,formController){
			
			$log.debug('workflow tasks init');	
			
			scope.workflowPartialsPath = workflowPartialsPath;
			
				
			scope.propertiesList = {};
				
			scope.getWorkflowTasks = function(){
				scope.workflowTasks = scope.workflow.$$getWorkflowTasks();
			};
			
			scope.getWorkflowTasks();
			
			scope.addWorkflowTask = function(){
				$log.debug('addWorkflowTasks');
				var newWorkflowTask = $slatwall.newWorkflowTask();
				newWorkflowTask.data.workflow = scope.workflow.data;
				scope.workflowTasks.selectedTask = newWorkflowTask;
				scope.workflowTasks.push(newWorkflowTask);
				$log.debug(scope.workflowTasks);
			};
			
			scope.addWorkflowTaskAction = function(){
				var workflowTaskAction = $slatwall.newWorkflowTaskAction();
				scope.workflowTasks.selectedTask.data.workflowTaskActions.selectedTaskAction = workflowTaskAction;
				workflowTaskService.addWorkflowTaskAction(scope.workflowTasks.selectedTask.workflowTaskActions,workflowTaskAction);
			};
			
			scope.removeWorkflowTaskAction = function(index){
				scope.workflowTasks.selectedTask.workflowTaskActions.splice(index,1);
				for(var i in scope.workflowTasks.selectedTask.workflowTaskActions){
					scope.workflowTasks.selectedTask.workflowTaskActions[i].$$index = i;
				}
			};
			
			scope.removeWorkflowTask = function(workflowTask){
				if(workflowTask === scope.workflowTasks.selectedTask){
					delete scope.workflowTasks.selectedTask;
				}
				scope.workflowTasks.splice(workflowTask.$$index,1);
				for(var i in scope.workflowTasks){
					scope.workflowTasks[i].$$index = i;
				}
			};
		}
	};
}]);
	
