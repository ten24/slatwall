angular.module('slatwalladmin')
.directive('swWorkflowTasks', 
[
'$log',
'$location',
'$slatwall',
'workflowService',
'workflowTaskService',
'workflowPartialsPath',
function(
$log,
$location,
$slatwall,
workflowService,
workflowTaskService,
workflowPartialsPath
){
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			
		},
		templateUrl:workflowPartialsPath+"workflowtasks.html",
		link: function(scope, element,attrs,formController){
			
			
			$log.debug('workflow tasks init');	
			
			scope.workflowPartialsPath = workflowPartialsPath;
			
			scope.workflowID = $location.search().workflowID;
			scope.$id = 'swWorkflowTasks'
				
			/*scope.getPropertyDisplayData = function(){
				var propertyDisplayDataPromise = $slatwall.getPropertyDisplayData('workflowTrigger',{propertyIdentifiersList:'triggerType'});
				propertyDisplayDataPromise.then(function(value){
					scope.propertyDisplayData = value.data;
					$log.debug('getting property Display meta data');
					$log.debug(scope.propertyDisplayData);
				},function(reason){
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlers(alerts);
				});
			};
			scope.getPropertyDisplayData();*/
				
			scope.getWorkflowTasks = function(){
				var filterGroupsConfig ='['+  
					'{'+
                     	'"filterGroup":['+  
				            '{'+
				               '"propertyIdentifier":"workflow.workflowID",'+
				               '"comparisonOperator":"=",'+
				               '"value":"'+scope.workflowID+'"'+
				           '}'+ 
				         ']'+
					'}'+
				']';
				var workflowTasksPromise = $slatwall.getEntity('workflowTask',{filterGroupsConfig:filterGroupsConfig});
				
				workflowTasksPromise.then(function(value){
					$log.debug('getWorkflowTasks');
					scope.workflowTasks = workflowTaskService.formatWorkflowTasks(value.pageRecords);
					$log.debug(scope.workflowTasks);
					
				});
			};
			
			scope.getWorkflowTasks();
			
			scope.addWorkflowTask = function(){
				$log.debug('addWorkflowTasks');
				var newWorkflowTask = workflowTaskService.newWorkflowTask();
				newWorkflowTask.workflow = workflowService.getWorkflow(scope.workflowID);
				scope.workflowTasks.selectedTask = newWorkflowTask;
				scope.workflowTasks.push(newWorkflowTask);
				$log.debug(scope.workflowTasks);
			};
			
			scope.addWorkflowTaskAction = function(){
				var workflowTaskAction = workflowTaskService.newWorkflowTaskAction();
				scope.workflowTasks.selectedTask.workflowTaskActions.selectedTaskAction = workflowTaskAction;
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
	
