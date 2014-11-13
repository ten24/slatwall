angular.module('slatwalladmin')
.directive('swWorkflowTasks', 
[
'$log',
'$location',
'$slatwall',
'workflowService',
'workflowTaskService',
'metadataService',
'workflowPartialsPath',
function(
$log,
$location,
$slatwall,
workflowService,
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
				/*var filterGroupsConfig ='['+  
					'{'+
                     	'"filterGroup":['+  
				            '{'+
				               '"propertyIdentifier":"_workflow.workflowID",'+
				               '"comparisonOperator":"=",'+
				               '"value":"'+scope.workflowID+'"'+
				           '}'+ 
				         ']'+
					'}'+
				']';
				var workflowTasksPromise = $slatwall.getEntity('workflowTask',{filterGroupsConfig:filterGroupsConfig});*/
				//console.log(scope.workflow);
				scope.workflowTasks = scope.workflow.$$getWorkflowTasks();
				console.log(scope.workflowTasks);
				
				/*workflowTasksPromise.then(function(value){
					$log.debug('getWorkflowTasks');
					scope.workflowTasks = workflowTaskService.formatWorkflowTasks(value.pageRecords);
					$log.debug(scope.workflowTasks);
					
					var workflow = workflowService.getWorkflow(scope.workflowID);
					if(angular.isUndefined(metadataService.getPropertiesListByBaseEntityAlias(workflow.workflowObject))){
						var propertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(workflow.workflowObject);
						propertiesPromise.then(function(value){
							metadataService.setPropertiesList(value,workflow.workflowObject);
							scope.propertiesList[workflow.workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(workflow.workflowObject);
							metadataService.formatPropertiesList(scope.propertiesList[workflow.workflowObject],workflow.workflowObject);
							
						});
					}else{
						scope.propertiesList = metadataService.getPropertiesListByBaseEntityAlias(workflow.workflowObject);
					}
					
				});*/
			};
			
			scope.getWorkflowTasks();
			
			scope.addWorkflowTask = function(){
				$log.debug('addWorkflowTasks');
				var newWorkflowTask = $slatwall.newWorkflowTask();
				newWorkflowTask.workflow = scope.workflow;
				scope.workflowTasks.selectedTask = newWorkflowTask;
				scope.workflowTasks.push(newWorkflowTask);
				$log.debug(scope.workflowTasks);
			};
			
			scope.addWorkflowTaskAction = function(){
				var workflowTaskAction = $slatwall.newWorkflowTaskAction();
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
	
