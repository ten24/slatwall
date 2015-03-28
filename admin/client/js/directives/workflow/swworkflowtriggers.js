angular.module('slatwalladmin')
.directive('swWorkflowTriggers', [
'$log',
'$location',
'$slatwall',
'workflowPartialsPath',
'formService',
	function(
	$log,
	$location,
	$slatwall,
	workflowPartialsPath,
	formService
	){
		return {
			restrict: 'E',
			scope:{
				workflow:"="
			},
			templateUrl:workflowPartialsPath+"workflowtriggers.html",
			link: function(scope, element,attrs,formController){
				$log.debug('Workflow triggers init');	
				scope.$id = 'swWorkflowTriggers';
				/**
				 * Retrieves the workflow triggers.
				 */	
				scope.getWorkflowTriggers = function(){

					/***
					   Note:
					   This conditional is checking whether or not we need to be retrieving to
					   items all over again. If we already have them, we won't make another
					   trip to the database. 
					   
					***/
					if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
						var workflowTriggersPromise = scope.workflow.$$getWorkflowTriggers();
						workflowTriggersPromise.then(function(){
									scope.workflowTriggers = scope.workflow.data.workflowTriggers;
									$log.debug('workflowtriggers');
									$log.debug(scope.workflowTriggers);
								
									/* resets the workflow trigger */
									if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
										scope.workflow.data.workflowTriggers = [];
										scope.workflowTriggers = scope.workflow.data.workflowTriggers;
									}
								
								angular.forEach(scope.workflowTriggers, function(workflowTrigger,key){
									$log.debug('trigger');
									$log.debug(workflowTrigger);
									if(workflowTrigger.data.triggerType === 'Schedule'){
										workflowTrigger.$$getSchedule();
										workflowTrigger.$$getScheduleCollection();
									}//<---end if
								});//<---end forEach
							});//<---end workflow triggers promise
					}else{
						//Use the cached versions.
						scope.workflowTriggers = scope.workflow.data.workflowTriggers;
					}//<---end else
				};
				scope.getWorkflowTriggers();//call triggers
				
				scope.showCollections = false;
				scope.collections = [];
				scope.getCollectionByWorkflowObject = function(){
					var filterGroupsConfig ='['+  
						'{'+
		                 	'"filterGroup":['+  
					            '{'+
					               '"propertyIdentifier":"_collection.collectionObject",'+
					               '"comparisonOperator":"=",'+
					               '"value":"'+ scope.workflow.data.workflowObject +'"'+
					           '}'+ 
					         ']'+
						'}'+
					']';
					var collectionsPromise = $slatwall.getEntity('Collection',{filterGroupsConfig:filterGroupsConfig});
					
					collectionsPromise.then(function(value){
						$log.debug('getcollections');
						scope.collections = value.pageRecords;
						$log.debug(scope.collections);
						
					});
				};
				scope.searchEvent = {
					name:''	
				};
				
				/**
				 * Watches for changes in the event
				 */
				scope.showEventOptions = false;
				scope.eventOptions = [];
				scope.$watch('searchEvent.name', function(newValue, oldValue){
					if(newValue !== oldValue){
						scope.getEventOptions(scope.workflow.data.workflowObject);
					}
				});
				/**
				 * Retrieves the event options for a workflow trigger item.
				 */
				scope.getEventOptions = function(objectName){
					if(!scope.eventOptions.length){
						var eventOptionsPromise = $slatwall.getEventOptions(objectName);
						
						eventOptionsPromise.then(function(value){
							$log.debug('getEventOptions');
							scope.eventOptions = value.data;
							$log.debug(scope.eventOptions.name);
							
						});
					}
					scope.showEventOptions = !scope.showEventOptions;
				};
				
				/**
				 * Saves the workflow triggers.
				 */
				scope.saveWorkflowTrigger = function(context){
					var saveWorkflowTriggerPromise = scope.workflowTriggers.selectedTrigger.$$save();
					saveWorkflowTriggerPromise.then(function(){
                        //Clear the form by adding a new task action if 'save and add another' otherwise, set save and set finished
                        if (context == 'add'){
                    			$log.debug("Save and New");
                    			scope.addWorkflowTrigger();
                    			scope.finished = false;
                        }else if (context == "finish"){
                        		scope.finished = true;
                        }
					});
				};
				
				/**
				 * Changes the selected trigger value.
				 */
				scope.selectEvent = function(eventOption){
					$log.debug("SelectEvent");
					$log.debug(eventOption);
					//Needs to clear old and set new.
					scope.workflowTriggers.selectedTrigger.data.triggerEvent = eventOption.value;
					if(eventOption.entityName == scope.workflow.data.workflowObject){
						scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = '';
					}else{
						scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = eventOption.entityName;
					}
					
					scope.searchEvent.name = eventOption.name;
					$log.debug(eventOption);
					$log.debug(scope.workflowTriggers);
				};
				
				/**
				 * Selects a new collection.
				 */
				scope.selectCollection = function(collection){
					$log.debug('selectCollection');
					scope.workflowTriggers.selectedTrigger.data.scheduleCollection = collection;
					scope.showCollections = false;
				};
				
				/**
				 * Removes a workflow trigger
				 */
				scope.removeWorkflowTrigger = function(workflowTrigger){
					if(workflowTrigger === scope.workflowTriggers.selectedTrigger){
						delete scope.workflowTriggers.selectedTrigger;
					}
					scope.workflowTriggers.splice(workflowTrigger.$$index,1);
				};
				
				scope.setAsEvent = function(workflowTrigger){
					//add event,  clear schedule
				};
				
				scope.setAsSchedule = function(workflowTrigger){
				
				};
				/**
				 * Adds a workflow trigger.
				 */
				scope.addWorkflowTrigger = function(){
					$log.debug('addWorkflowTrigger');
					var newWorkflowTrigger = scope.workflow.$$addWorkflowTrigger();
					scope.workflowTriggers.selectedTrigger = newWorkflowTrigger;
					$log.debug(scope.workflowTriggers);
				};
			}
		};
	}
]);
	
