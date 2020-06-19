/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Handles adding, editing, and deleting Workflows Tasks.
 */
class SWWorkflowTasks{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder
		)=>new SWWorkflowTasks(
			$log,
			$hibachi,
			metadataService,
			workflowPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'metadataService',
			'workflowPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		metadataService,
		workflowPartialsPath,
			hibachiPathBuilder
	){
		return {
			restrict: 'A',
			scope:{
				workflow:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowtasks.html",
			link: function(scope, element,attrs){
				scope.workflowPartialsPath = hibachiPathBuilder.buildPartialsPath(workflowPartialsPath);
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

                    if(!scope.workflow.$$isPersisted()){
                        scope.workflow.data.workflowTasks = [];
                        scope.workflowTasks = scope.workflow.data.workflowTasks;
                        return;
                    }

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
				 * Sets the editing state to show/hide the edit screen.
				 */
				scope.setHidden = function(task){
					if(!angular.isObject(task) || angular.isUndefined(task.hidden)){
						task.hidden=false;
					}else{
						logger("setHidden()", "Setting Hide Value To " + !task.hidden);
						task.hidden = !task.hidden;
					}
				};

				/**
				 * Add a workflow task and logs the result.
				 */
				scope.addWorkflowTask = function(){
					var newWorkflowTask = scope.workflow.$$addWorkflowTask();
					logger("var newWorkflowTask", newWorkflowTask);
					scope.selectWorkflowTask(newWorkflowTask);
				};

			   /**
				 * Watches the select for changes.
				 */
				scope.$watch('workflowTasks.selectedTask.data.workflow.data.workflowObject',function(newValue, oldValue){
					logger("scope.$watch", "Change Detected " + newValue + " from " + oldValue)
					if((newValue !== oldValue && angular.isDefined(scope.workflowTasks.selectedTask)) ){
						logger("scope.$watch", "Change to " + newValue)
                        scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityAlias = '_' + newValue.charAt(0).toLowerCase() + newValue.slice(1) ;
						scope.workflowTasks.selectedTask.data.taskConditionsConfig.baseEntityName = newValue;
					}
				});

			  /**
                 * --------------------------------------------------------------------------------------------------------
                 * Saves the workflow task by calling the objects $$save method. In addition to calling save here,
				 * we also refresh the data by calling getWorkflowTasks followed by calling the global entity.$$save.
                 * @param task
                 * --------------------------------------------------------------------------------------------------------
                 */
                scope.saveWorkflowTask = function (task, context) {

                    //scope.workflowTasks.selectedTask.$$setWorkflow(scope.workflow);
                    scope.workflowTasks.selectedTask.$$save().then(function(res){
                        scope.done = true;
                        delete scope.workflowTasks.selectedTask;
                    	if (context === 'add'){
            				scope.addWorkflowTask();
            				scope.finished = true;
                        }else if (context == "finish"){
                			scope.finished = false;
                		}
						//refresh the task information.
						delete scope.workflow.data.workflowTasks;
						scope.getWorkflowTasks();

						//Save the workflow entity automatically.
						scope.workflow.$$save();
                    }, function (err) {
                    })
                }//<--end save*/

                /**
				 * Select a workflow task.
				 */
				scope.selectWorkflowTask = function(workflowTask){
					scope.done = false;
					$log.debug(workflowTask);
					scope.finished = false;
					scope.workflowTasks.selectedTask = undefined;
					
					let workflowObject = scope.workflow.data.workflowObject;
					let workflowObjectAlias = "_" + scope.workflow.data.workflowObject.charAt(0).toLowerCase() + scope.workflow.data.workflowObject.slice(1);
					
					var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(workflowObject, true);
					filterPropertiesPromise.then(function(value){
						scope.filterPropertiesList = {
							baseEntityName:workflowObject,
							baseEntityAlias:workflowObjectAlias
						};
						metadataService.setPropertiesList(value,workflowObject);
						scope.filterPropertiesList[workflowObject] = metadataService.getPropertiesListByBaseEntityAlias(workflowObject);
						metadataService.formatPropertiesList(scope.filterPropertiesList[workflowObject],workflowObject);
						
						metadataService.setPropertiesList(value,workflowObjectAlias);
						scope.filterPropertiesList[workflowObjectAlias] = metadataService.getPropertiesListByBaseEntityAlias(workflowObjectAlias);
						metadataService.formatPropertiesList(scope.filterPropertiesList[workflowObjectAlias],workflowObjectAlias);
						
						scope.workflowTasks.selectedTask = workflowTask;

					});
				};

				/* Does a delete of the property using delete */
				scope.softRemoveTask = function(workflowTask){
					if(workflowTask === scope.workflowTasks.selectedTask){
						delete scope.workflowTasks.selectedTask;
					}
					scope.removeIndexFromTasks(workflowTask.$$index);
					scope.reindexTaskList();
				};

				/* Does an API call delete using $$delete */
				scope.hardRemoveTask = function(workflowTask){
					var deletePromise = workflowTask.$$delete();
    					deletePromise.then(function(){
    						if(workflowTask === scope.workflowTasks.selectedTask){
    							delete scope.workflowTasks.selectedTask;
    						}
    						scope.removeIndexFromTasks(workflowTask.$$index);
    						scope.reindexTaskList();
    					});
				};
                /*Override the delete entity in the confirmation controller*/
				scope.deleteEntity = function(entity){
					scope.hardRemoveTask(entity);
				}
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
}
export{
	SWWorkflowTasks
}

