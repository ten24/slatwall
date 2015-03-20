/**
 * Handles adding, editing, and deleting Workflows Tasks.
 */
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
	workflowPartialsPath){
		return {
			restrict: 'A',
			scope:{
				workflow:"="
			},
			templateUrl:workflowPartialsPath+"workflowtasks.html",
			link: function(scope, element,attrs){
				scope.workflowPartialsPath = workflowPartialsPath;
				scope.propertiesList = {};
				
				function logger(context, message){
					$log.debug("SwWorkflowTasks :" + context + " : " + message);
				}
				/**
				 * Sets workflowTasks on the scope by populating with $$getWorkflowTasks()
				 */
				scope.getWorkflowTasks = function(){
					logger("getWorkflowTasks", "Retrieving items");
					logger("getWorkflowTasks", "Workflow Tasks");
					$log.debug(scope.workflowTasks);
					/***
					   Note:
					   This conditional is checking whether or not we need to be retrieving to
					   items all over again. If we already have them, we won't make another
					   trip to the database. 
					   
					***/
					if(angular.isUndefined(scope.workflow.data.workflowTasks)){
						var workflowTasksPromise = scope.workflow.$$getWorkflowTasks();
						workflowTasksPromise.then(function(){
							scope.workflowTasks = scope.workflow.data.workflowTasks;
							
						});
					}else{
						logger("getWorkflowTasks", "Retrieving cached Items");
						scope.workflowTasks = scope.workflow.data.workflowTasks;
					}
					
					
					if(angular.isUndefined(scope.workflow.data.workflowTasks)){
						//Reset the workflowTasks.
						logger("getWorkflowTasks","workflowTasks is undefined.");
						scope.workflow.data.workflowTasks = [];
						scope.workflowTasks = scope.workflow.data.workflowTasks;
					}
					
				};
				scope.getWorkflowTasks();//call tasks
				
				/**
				 * Sets the state of the pencil to show/hide the edit screen.
				 */
				scope.setHidden = function(task){
					
					if(!angular.isObject(task) || angular.isUndefined(task.hidden)){
						task.hidden=true;
						}else{
							logger("setHidden()", "Setting Hide Value To " + !task.hidden);
						}
					task.hidden = !task.hidden;
				};
				
				/**
				 * Add a workflow task.
				 */
				scope.addWorkflowTask = function(){
					logger('addWorkflowTasks', "Calling $$addWorkflowTask");
					var newWorkflowTask = scope.workflow.$$addWorkflowTask();
					logger("var newWorkflowTask", newWorkflowTask);
					scope.selectWorkflowTask(newWorkflowTask);
				};
				
				/**
				 * Watches the select for changes.
				 */
				scope.$watch('workflowTasks.selectedTask.data.workflow.data.workflowObject',function(newValue,oldValue){
					logger("scope.$watch", "Change Detected " + newValue + " from " + oldValue)
					if((newValue !== oldValue && angular.isDefined(scope.workflowTasks.selectedTask)) ){
						logger("scope.$watch", "Change to " + newValue)
						scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityAlias = newValue;
						scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityName = newValue;
					}	
				});
				  /**
                 * --------------------------------------------------------------------------------------------------------
                 * Saves the workflow task by calling the objects $$save method.
                 * @param task
                 * --------------------------------------------------------------------------------------------------------
                 */
                scope.saveWorkflowTask = function (task, context) {
                	    $log.debug("Context: " + context);
                    $log.debug("saving task");
                    $log.debug(task);
                    var savePromise = scope.workflowTasks.selectedTask.$$save();
                    savePromise.then(function () {
                        //Clear the form by adding a new task if 'save and add another' otherwise, set save and set finished
                        if (context === 'add'){
                    			$log.debug("Save and New");
                    			scope.addWorkflowTask(task);
                    			scope.setHidden(task);
                        }else if (context == "finish"){
                        		scope.addWorkflowTask(task);
                        		scope.setHidden(task);
                        }
                    });
                }//<--end save
				/**
				 * Select a workflow task.
				 */
				scope.selectWorkflowTask = function(workflowTask){
					logger("selectWorkflowTask", "selecting a workflow task");
					$log.debug(workflowTask);
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
				/**
				 * Removes a Workflow task from the list and re-indexes.
				 */
				scope.removeWorkflowTask = function(workflowTask){
					if(workflowTask.$$isPersisted()){
						var deletePromise = workflowTask.$$delete();
			    			deletePromise.then(function(){
			    				if(workflowTask === scope.workflowTasks.selectedTask){
								delete scope.workflowTasks.selectedTask;
							}
							scope.workflowTasks.splice(workflowTask.$$index,1);
							for(var i in scope.workflowTasks){
								logger("deletePromise", i);
								scope.workflowTasks[i].$$index = i;
							}
						});
					}else{
						if(workflowTask === scope.workflowTasks.selectedTask){
							delete scope.workflowTasks.selectedTask;
						}
						scope.workflowTasks.splice(workflowTask.$$index,1);
						for(var i in scope.workflowTasks){
							logger("deletePromise", i);
							scope.workflowTasks[i].$$index = i;
						}
					}
				};//<--end remove function
				
				/* Does a delete of the property using delete */
				scope.softRemoveTask = function(workflowTask){
					logger("SoftRemoveTask", "calling delete");
					if(workflowTask === scope.workflowTasks.selectedTask){
						delete scope.workflowTasks.selectedTask;
					}
					scope.removeIndexFromTasks(workflowTask.$$index);
					scope.reindexTaskList();
				};
				
				/* Does an API call delete using $$delete */
				scope.hardRemoveTask = function(workflowTask){
					logger("HardRemoveTask", "$$delete");
					var deletePromise = workflowTask.$$delete();
    					deletePromise.then(function(){
    						if(workflowTask === scope.workflowTasks.selectedTask){
    							delete scope.workflowTasks.selectedTask;
    						}
    						scope.removeIndexFromTasks(workflowTask.$$index);
    						scope.reindexTaskList();
    					});
				};
				
				/* Re-indexes the task list */
				scope.reindexTaskList = function(){
					for(var i in scope.workflowTasks){
						logger("ReIndexing the list", i);
						scope.workflowTasks[i].$$index = i;
					}
				};
				
				/* Removes the tasks index from the tasks array */
				scope.removeIndexFromTasks = function(index){
					logger("RemoveIndexFromTasks", index);
					scope.workflowTasks.splice(index, 1);
				};
				
			}
		};
	}
]);
	