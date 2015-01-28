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
				$log.debug('workflow triggers init');	
				
				scope.$id = 'swWorkflowTriggers';
					
				scope.getWorkflowTriggers = function(){
					var workflowTriggersPromise = scope.workflow.$$getWorkflowTriggers();
					workflowTriggersPromise.then(function(){
						scope.workflowTriggers = scope.workflow.data.workflowTriggers;
						console.log('workflowtriggers');
						console.log(scope.workflowTriggers);
						if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
							scope.workflow.data.workflowTriggers = [];
							scope.workflowTriggers = scope.workflow.data.workflowTriggers;
						}
						
						angular.forEach(scope.workflowTriggers,function(workflowTrigger,key){
							console.log('trigger');
							console.log(workflowTrigger);
							if(workflowTrigger.data.triggerType === 'Schedule'){
								workflowTrigger.$$getSchedule();
								workflowTrigger.$$getScheduleCollection();
							}
						});
					});
				};
				
				scope.getWorkflowTriggers();
				
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
				scope.showEventOptions = false;
				scope.eventOptions = [];
				var unBindSearchEventWatch = scope.$watch('searchEvent.name',function(newValue,oldValue){
					if(newValue !== oldValue){
						scope.getEventOptions(scope.workflow.data.workflowObject);
						unBindSearchEventWatch();
					}
				});
				
				scope.getEventOptions = function(objectName){
					if(!scope.eventOptions.length){
						var eventOptionsPromise = $slatwall.getEventOptions(objectName);
						
						eventOptionsPromise.then(function(value){
							$log.debug('geteventOptions');
							scope.eventOptions = value.data;
							$log.debug(scope.eventOptions);
							
						});
					}
					scope.showEventOptions = !scope.showEventOptions;
				};
				
				scope.saveWorkflowTrigger = function(){
					var saveWorkflowTriggerPromise = scope.workflowTriggers.selectedTrigger.$$save();
					saveWorkflowTriggerPromise.then(function(){
						
					});
				};
				
				scope.selectEvent = function(eventOption){
					$log.debug('selectEvent');
					scope.workflowTriggers.selectedTrigger.data.triggerEvent = eventOption.value;
					scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier = eventOption.entityName;
					scope.searchEvent.name = eventOption.name;
					$log.debug(eventOption);
					$log.debug(scope.workflowTriggers);
				};
				
				scope.selectCollection = function(collection){
					$log.debug('selectCollection');
					scope.workflowTriggers.selectedTrigger.data.scheduleCollection = collection;
					scope.showCollections = false;
				};
				
				scope.removeWorkflowTrigger = function(workflowTrigger){
					if(workflowTrigger === scope.workflowTriggers.selectedTrigger){
						delete scope.workflowTriggers.selectedTrigger;
					}
					scope.workflowTriggers.splice(workflowTrigger.$$index,1);
				};
				
				/*scope.saveTrigger = function(){
					var params = {
						'objectPropertyIdentifier':scope.workflowTriggers.selectedTrigger.data.objectPropertyIdentifier,
						'triggerEvent':scope.workflowTriggers.selectedTrigger.data.triggerEvent,
						'triggerType':scope.workflowTriggers.selectedTrigger.data.triggerType,
						'workflow.workflowID':scope.workflowTriggers.selectedTrigger.data.workflow.workflowID,
						'workflowTriggerID':'',
						'propertyIdentifiersList':'workflowTriggerID'
					};
					var saveTriggerPromise = $slatwall.saveEntity('WorkflowTrigger',null,params,'Save');
					
					saveTriggerPromise.then(function(value){
						$log.debug('saveTrigger');
						scope.workflowTriggers.selectedTrigger.data.workflowTriggerID = value.data.workflowTriggerID;
						delete scope.workflowTriggers.selectedTrigger;
					},function(reason){
						
					});
				};*/
				
				scope.setAsEvent = function(workflowTrigger){
					//add event,  clear schedule
				};
				
				scope.setAsSchedule = function(workflowTrigger){
					//add schedule object, may need to clear event data if changed
//					if(angular.isUndefined(workflowTrigger.data.schedule)){
//						workflowTrigger.addSchedule();
//					}
					
					
				};
				
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
	
