angular.module('slatwalladmin')
.directive('swWorkflowTask', [
'$log',
'$location',
'$timeout',
'$slatwall',
'metadataService',
'collectionService',
'workflowPartialsPath',
	function(
	$log,
	$location,
	$timeout,
	$slatwall,
	metadataService,
	collectionService,
	workflowPartialsPath
	){
		return {
			restrict: 'E',
			scope:{
				workflowTask:"=",
				workflowTasks:"=",
				
			},
			templateUrl:workflowPartialsPath+"workflowtask.html",
			link: function(scope, element,attrs){
				console.log(scope.workflowTask);
//				scope.selectWorkflowTask = function(workflowTask){
//					$log.debug('select workflow task');
//					$log.debug(workflowTask);
//					scope.workflowTasks.selectedTask = undefined;
//					scope.workflowTasks.selectedTask = workflowTask;
//					var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(scope.workflow.data.workflowObject);
//					filterPropertiesPromise.then(function(value){
//						scope.filterPropertiesList = {
//							baseEntityName:scope.workflow.data.workflowObject,
//							baseEntityAlias:"_"+ scope.workflow.data.workflowObject
//						};
//						metadataService.setPropertiesList(value,scope.workflow.data.workflowObject);
//						scope.filterPropertiesList[scope.workflow.data.workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(scope.workflow.data.workflowObject);
//						metadataService.formatPropertiesList(scope.filterPropertiesList[scope.workflow.data.workflowObject],scope.workflow.data.workflowObject);
//					});
//				};
				
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
	
