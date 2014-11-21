angular.module('slatwalladmin')
.directive('swWorkflowTasks', [
'$log',
'$location',
'$slatwall',
'metadataService',
'workflowPartialsPath',
	function(
	$log,
	$location,
	$slatwall,
	metadataService,
	workflowPartialsPath
	){
		return {
			restrict: 'A',
			scope:{
				workflow:"="
			},
			templateUrl:workflowPartialsPath+"workflowtasks.html",
			link: function(scope, element,attrs){
				
				$log.debug('workflow tasks init');	
				scope.workflowPartialsPath = workflowPartialsPath;
				
				scope.propertiesList = {};
					
				scope.getWorkflowTasks = function(){
					var workflowTasksPromise = scope.workflow.$$getWorkflowTasks();
					workflowTasksPromise.then(function(){
						scope.workflowTasks = scope.workflow.data.workflowTasks;
					});
					$log.debug(scope.workflowTasks);
				};
				
				scope.getWorkflowTasks();
				
				scope.addWorkflowTask = function(){
					$log.debug('addWorkflowTasks');
					var newWorkflowTask = scope.workflow.$$addWorkflowTask();
					scope.selectWorkflowTask(newWorkflowTask);
					$log.debug(scope.workflowTasks);
				};
				
				scope.selectWorkflowTask = function(workflowTask){
					scope.workflowTasks.selectedTask = workflowTask;
					if(angular.isString(workflowTask.data.taskConditionsConfig)){
						workflowTask.data.taskConditionsConfig = angular.fromJson(workflowTask.data.taskConditionsConfig);
					}
				};
				
				scope.removeWorkflowTask = function(workflowTask){
					var deletePromise = workflowTask.$$delete();
		    		deletePromise.then(function(){
						if(workflowTask === scope.workflowTasks.selectedTask){
							delete scope.workflowTasks.selectedTask;
						}
						scope.workflowTasks.splice(workflowTask.$$index,1);
						for(var i in scope.workflowTasks){
							scope.workflowTasks[i].$$index = i;
						}
					});
				};
				
				scope.filterPropertiesList = {};
				var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(scope.workflow.data.workflowObject);
				filterPropertiesPromise.then(function(value){
					metadataService.setPropertiesList(value,scope.workflow.data.workflowObject);
					scope.filterPropertiesList[scope.workflow.data.workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(scope.workflow.data.workflowObject);
					metadataService.formatPropertiesList(scope.filterPropertiesList[scope.workflow.data.workflowObject],scope.workflow.data.workflowObject);
					
				});
			}
		};
	}
]);
	
