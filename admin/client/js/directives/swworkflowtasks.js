angular.module('slatwalladmin')
.directive('swWorkflowTasks', [
'$log',
'$location',
'$slatwall',
'metadataService',
'collectionService',
'workflowPartialsPath',
	function(
	$log,
	$location,
	$slatwall,
	metadataService,
	collectionService,
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
					
					if(angular.isUndefined(scope.workflow.data.workflowTasks)){
						scope.workflow.data.workflowTasks = [];
						scope.workflowTasks = scope.workflow.data.workflowTasks;
					}
					
				};
				scope.getWorkflowTasks();
				/*scope.saveWorkflowTask = function(){
					var savePromise = scope.workflow.workflowTasks.selectedTask.$$save();
					savePromise.then(function(){
						scope.getWorkflowTasks();			
					});
				};*/

				
				
				scope.addWorkflowTask = function(){
					$log.debug('addWorkflowTasks');
					var newWorkflowTask = scope.workflow.$$addWorkflowTask();
					scope.selectWorkflowTask(newWorkflowTask);
				};
				
				scope.$watch('workflowTasks.selectedTask.data.workflow.data.workflowObject',function(newValue,oldValue){
					
					if(newValue !== oldValue && angular.isDefined(scope.workflowTasks.selectedTask)){
						if(angular.isString(scope.workflowTasks.selectedTask.data.taskConditionsConfig)){
							scope.workflowTasks.selectedTask.data.taskConditionsConfig = angular.fromJson(scope.workflowTasks.selectedTask.data.taskConditionsConfig);
						}
						
						scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityAlias = newValue;
						scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityName = newValue;
					}
				});
				
				scope.selectWorkflowTask = function(workflowTask){
					scope.workflowTasks.selectedTask = undefined;
					
					var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(scope.workflow.data.workflowObject);
					filterPropertiesPromise.then(function(value){
						scope.filterPropertiesList = {
							baseEntityName:scope.workflow.data.workflowObject,
							baseEntityAlias:"_"+ scope.workflow.data.workflowObject
						};
						metadataService.setPropertiesList(value,scope.workflow.data.workflowObject);
						scope.filterPropertiesList[scope.workflow.data.workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(scope.workflow.data.workflowObject);
						metadataService.formatPropertiesList(scope.filterPropertiesList[scope.workflow.data.workflowObject],scope.workflow.data.workflowObject);
						scope.workflowTasks.selectedTask = workflowTask;
					});
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
			}
		};
	}
]);
	
