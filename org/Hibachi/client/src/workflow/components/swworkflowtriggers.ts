
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTriggers{
	public static Factory(){
		var directive = (
			$hibachi,
			workflowPartialsPath,
			formService,
            observerService,
			hibachiPathBuilder,
            collectionConfigService,
            scheduleService,
            dialogService,
                $timeout
		)=> new SWWorkflowTriggers(
			$hibachi,
			workflowPartialsPath,
			formService,
            observerService,
			hibachiPathBuilder,
            collectionConfigService,
            scheduleService,
            dialogService,
            $timeout
		);
		directive.$inject = [
			'$hibachi',
			'workflowPartialsPath',
			'formService',
            'observerService',
			'hibachiPathBuilder',
            'collectionConfigService',
            'scheduleService',
            'dialogService',
            '$timeout'
		];
		return directive;
	}
	constructor(
		$hibachi,
		workflowPartialsPath,
		formService,
        observerService,
        hibachiPathBuilder,
        collectionConfigService,
        scheduleService,
        dialogService,
        $timeout
	){
		return {
			restrict: 'E',
			scope:{
				workflow:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowtriggers.html",
			link: function(scope, element,attrs,formController){

                scope.schedule = {};

                scope.$watch('workflowTriggers.selectedTrigger', function(newValue, oldValue){
                    if(newValue !== undefined && newValue !== oldValue){
                        if(newValue.data.triggerType == 'Schedule'){
                            if(angular.isDefined(newValue.data.schedule)){
                                scope.schedule.selectedName = newValue.data.schedule.data.scheduleName;
                                scope.selectSchedule(newValue.data.schedule.data);
                            }
                            if(angular.isDefined(newValue.data.scheduleCollection)){
                                scope.selectedCollection = newValue.data.scheduleCollection.data.collectionName;
                            }
                        }else{
                            scope.searchEvent.name = scope.workflowTriggers.selectedTrigger.triggerEventTitle;
                        }
                    }
                });

                scope.collectionCollectionConfig = collectionConfigService.newCollectionConfig("Collection");
                scope.collectionCollectionConfig.setDisplayProperties("collectionID,collectionName");
                scope.collectionCollectionConfig.addFilter("collectionObject",scope.workflow.data.workflowObject);

                observerService.attach((item) =>{
                    scope.collectionCollectionConfig.clearFilters();
                    scope.collectionCollectionConfig.addFilter("collectionObject",item.value);
                    scope.eventOptions = [];
                },'WorkflowWorkflowObjectOnChange');
                

                scope.scheduleCollectionConfig = collectionConfigService.newCollectionConfig("Schedule");
                scope.scheduleCollectionConfig.setDisplayProperties("scheduleID,scheduleName,daysOfMonthToRun,daysOfWeekToRun,recuringType,frequencyStartTime,frequencyEndTime,frequencyInterval");

                scope.daysOfweek = [];
                scope.daysOfMonth = [];


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
                    if(!scope.workflow.$$isPersisted()){
                        scope.workflow.data.workflowTriggers = [];
                        scope.workflowTriggers = scope.workflow.data.workflowTriggers;
                        return;
                    }
					if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
						var workflowTriggersPromise = scope.workflow.$$getWorkflowTriggers();
						workflowTriggersPromise.then(function(){
									scope.workflowTriggers = scope.workflow.data.workflowTriggers;

									/* resets the workflow trigger */
									if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
										scope.workflow.data.workflowTriggers = [];
										scope.workflowTriggers = scope.workflow.data.workflowTriggers;
									}

								angular.forEach(scope.workflowTriggers, function(workflowTrigger,key){
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
				scope.searchEvent = {
					name:''
				};

				/**
				 * Watches for changes in the event
				 */
				scope.showEventOptions = false;
				scope.eventOptions = [];

				/**
				 * Retrieves the event options for a workflow trigger item.
				 */
				scope.getEventOptions = function(objectName){
					if(!scope.eventOptions.length){
						var eventOptionsPromise = $hibachi.getEventOptions(objectName);

						eventOptionsPromise.then(function(value){
							scope.eventOptions = value.data;

						});
					}
					scope.showEventOptions = !scope.showEventOptions;
				};

				/**
				 * Saves the workflow triggers.
				 */
				scope.saveWorkflowTrigger = function(context){
                    if(!scope.workflowTriggers.selectedTrigger.$$isPersisted()){
                        scope.workflowTriggers.selectedTrigger.$$setWorkflow(scope.workflow);
                    }
					var saveWorkflowTriggerPromise = scope.workflowTriggers.selectedTrigger.$$save();
					saveWorkflowTriggerPromise.then(function(){

                        scope.showEventOptions = true;
                        scope.searchEvent = {
                            name:''
                        };
                        scope.schedule.selectedName = '';
                        scope.schedulePreview = {};
                        //Clear the form by adding a new task action if 'save and add another' otherwise, set save and set finished
                        if (context == 'add'){
                            scope.addWorkflowTrigger();
                        }else if (context == "finish"){

                            scope.workflowTriggers.selectedTrigger = undefined;
                        }
					});
				};

                scope.closeTrigger = function(){
                    console.warn("workflow", scope.workflow);
                    if(!scope.workflowTriggers.selectedTrigger.$$isPersisted()){
                        scope.workflowTriggers.selectedTrigger.$$setWorkflow();
                    }
                    scope.workflowTriggers.selectedTrigger = undefined;
                };

				/**
				 * Changes the selected trigger value.
				 */
				scope.selectEvent = function(eventOption){
                    //Needs to clear old and set new.
                    scope.workflowTriggers.selectedTrigger.data.triggerEventTitle = eventOption.name;
                    scope.workflowTriggers.selectedTrigger.data.triggerEvent = eventOption.value;
                    if(eventOption.entityName == scope.workflow.data.workflowObject){
                        scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = '';

                    }else{
                        scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = eventOption.entityName;
                    }
                    
                    scope.searchEvent.name = eventOption.name;
                    scope.showEventOptions = false;  
                    observerService.notifyById('pullBindings','WorkflowTriggertriggerEventpullBindings').then(function(){
                          
                    });
                    observerService.notifyById('pullBindings','WorkflowTriggertriggerEventTitlepullBindings').then(function(){
                          
                    });
				};

				/**
				 * Selects a new collection.
				 */
				scope.selectCollection = function(collection){
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
                    if(!workflowTrigger.$$isPersisted()){
                        workflowTrigger.data.saveTriggerHistoryFlag = 0;
                    }
					//add event,  clear schedule
				};

				scope.setAsSchedule = function(workflowTrigger){
                    if(!workflowTrigger.$$isPersisted()){
                        workflowTrigger.data.saveTriggerHistoryFlag = 1;
                    }
				};

				/**
				 * Adds a workflow trigger.
				 */
				scope.addWorkflowTrigger = function(){

					var newWorkflowTrigger = $hibachi.newWorkflowTrigger();
					scope.workflowTriggers.selectedTrigger = newWorkflowTrigger;
				};


                scope.addNewSchedule = function(){
                    scope.createSchedule = true;
                    scope.scheduleEntity = $hibachi.newSchedule();
                };

                scope.saveSchedule = function(){
                    if(scope.scheduleEntity.data.recuringType == 'weekly'){
                        scope.scheduleEntity.data.daysOfWeekToRun = scope.daysOfweek.filter(Number).join();
                    }else if(scope.scheduleEntity.data.recuringType == 'monthly'){
                        scope.scheduleEntity.data.daysOfMonthToRun = scope.daysOfMonth.filter(Number).join();
                    }
                    scope.scheduleEntity.$$save().then((res) =>{
                        scope.schedule.selectedName = angular.copy(scope.scheduleEntity.data.scheduleName);
                        scope.selectSchedule(angular.copy(scope.scheduleEntity.data));

                        formService.resetForm(scope.scheduleEntity.forms['scheduleForm']);
                        scope.createSchedule = false;
                    }, ()=>{
                    })
                };

                scope.selectCollection =  (item) => {
                    if(item === undefined){
                        scope.workflowTriggers.selectedTrigger.$$setScheduleCollection();
                        return;
                    }
                    if(angular.isDefined(scope.workflowTriggers.selectedTrigger.data.scheduleCollection)){
                        scope.workflowTriggers.selectedTrigger.data.scheduleCollection.data.collectionID = item.collectionID;
                        scope.workflowTriggers.selectedTrigger.data.scheduleCollection.data.collectionName = item.collectionName;
                    }else{
                        var _collection = $hibachi.newCollection();
                        _collection.data.collectionID = item.collectionID;
                        _collection.data.collectionName = item.collectionName;
                        scope.workflowTriggers.selectedTrigger.$$setScheduleCollection(_collection);
                    }
                };

                scope.viewCollection = () =>{
                    if(angular.isDefined(scope.workflowTriggers.selectedTrigger.data.scheduleCollection)){
                        dialogService.addPageDialog('org/Hibachi/client/src/collection/components/criteriacreatecollection', {
                            entityName: 'Collection',
                            entityId: scope.workflowTriggers.selectedTrigger.data.scheduleCollection.data.collectionID,
                            readOnly:true
                        });
                    }
                };


                scope.selectSchedule =  (item) => {
                    if(item === undefined){
                        scope.schedulePreview = {};
                        scope.workflowTriggers.selectedTrigger.$$setSchedule();
                        return;
                    }
                    scope.schedulePreview = scheduleService.buildSchedulePreview(item,6);
                    if(angular.isDefined(scope.workflowTriggers.selectedTrigger.data.schedule)){
                        scope.workflowTriggers.selectedTrigger.data.schedule.data.scheduleID = item.scheduleID;
                        scope.workflowTriggers.selectedTrigger.data.schedule.data.scheduleName = item.scheduleName;
                    }else{
                        var _schedule = $hibachi.newSchedule();
                        _schedule.data.scheduleID = item.scheduleID;
                        _schedule.data.scheduleName = item.scheduleName;
                        scope.workflowTriggers.selectedTrigger.$$setSchedule(_schedule);
                    }
                };


			}
		};
	}
}
export{
	SWWorkflowTriggers
}