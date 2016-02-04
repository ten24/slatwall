
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowTriggers{
	public static Factory(){
		var directive = (
			$log,
			$location,
			$hibachi,
			workflowPartialsPath,
			formService,
			hibachiPathBuilder,
            collectionConfigService
		)=> new SWWorkflowTriggers(
			$log,
			$location,
			$hibachi,
			workflowPartialsPath,
			formService,
			hibachiPathBuilder,
            collectionConfigService
		);
		directive.$inject = [
			'$log',
			'$location',
			'$hibachi',
			'workflowPartialsPath',
			'formService',
			'hibachiPathBuilder',
            'collectionConfigService'
		];
		return directive;
	}
	constructor(
		$log,
		$location,
		$hibachi,
		workflowPartialsPath,
		formService,
        hibachiPathBuilder,
        collectionConfigService
	){
		return {
			restrict: 'E',
			scope:{
				workflow:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(workflowPartialsPath)+"workflowtriggers.html",
			link: function(scope, element,attrs,formController){

                scope.collectionCollectionConfig = collectionConfigService.newCollectionConfig("Collection");
                scope.collectionCollectionConfig.setDisplayProperties("collectionID,collectionName");
                scope.collectionCollectionConfig.addFilter("collectionObject",scope.workflow.data.workflowObject);


                scope.scheduleCollectionConfig = collectionConfigService.newCollectionConfig("Schedule");
                scope.scheduleCollectionConfig.setDisplayProperties("scheduleID,scheduleName");

                scope.daysOfweek = [];
                scope.daysOfMonth = [];

                scope.selectedSchedule = '';


				console.warn('Workflow triggers init');
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
									console.warn('workflowtriggers');
									console.warn(scope.workflowTriggers);

									/* resets the workflow trigger */
									if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
										scope.workflow.data.workflowTriggers = [];
										scope.workflowTriggers = scope.workflow.data.workflowTriggers;
									}

								angular.forEach(scope.workflowTriggers, function(workflowTrigger,key){
									console.warn('trigger');
									console.warn(workflowTrigger);
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
					var collectionsPromise = $hibachi.getEntity('Collection',{filterGroupsConfig:filterGroupsConfig});

					collectionsPromise.then(function(value){
						console.warn('getcollections');
						scope.collections = value.pageRecords;
						console.warn(scope.collections);

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
						var eventOptionsPromise = $hibachi.getEventOptions(objectName);

						eventOptionsPromise.then(function(value){
							console.warn('getEventOptions');
							scope.eventOptions = value.data;
							console.warn(scope.eventOptions.name);

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
                            console.warn("Save and New");
                            scope.addWorkflowTrigger();
                            scope.finished = false;
                        }else if (context == "finish"){
                            scope.finished = true;
                            scope.workflowTriggers.selectedTrigger.hidden = true;
                        }
					});
				};

				/**
				 * Changes the selected trigger value.
				 */
				scope.selectEvent = function(eventOption){
					console.warn("SelectEvent");
					console.warn(eventOption);
					//Needs to clear old and set new.
					scope.workflowTriggers.selectedTrigger.data.triggerEvent = eventOption.value;
					if(eventOption.entityName == scope.workflow.data.workflowObject){
						scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = '';

                    }else{
						scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = eventOption.entityName;
					}

					scope.searchEvent.name = eventOption.name;
					console.warn(eventOption);
					console.warn(scope.workflowTriggers);
				};

				/**
				 * Selects a new collection.
				 */
				scope.selectCollection = function(collection){
					console.warn('selectCollection');
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
					console.warn('addWorkflowTrigger');
					var newWorkflowTrigger = scope.workflow.$$addWorkflowTrigger();
					scope.workflowTriggers.selectedTrigger = newWorkflowTrigger;
					console.warn(scope.workflowTriggers);
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
                    scope.scheduleEntity.$$save().then(function (res) {
                        formService.resetForm(scope.scheduleEntity.forms['scheduleForm']);
                        scope.createSchedule = false;
                    }, function(){
                        console.warn('ERROR');
                    })
                };

                scope.selectCollection =  (item) => {
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


                scope.selectSchedule =  (item) => {
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