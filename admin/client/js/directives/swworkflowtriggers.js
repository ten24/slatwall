angular.module('slatwalladmin')
.directive('swWorkflowTriggers', [
'$log',
'$location',
'$slatwall',
'workflowPartialsPath',
	function(
	$log,
	$location,
	$slatwall,
	workflowPartialsPath
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
					});
					
					if(angular.isUndefined(scope.workflow.data.workflowTriggers)){
						scope.workflow.data.workflowTriggers = [];
						scope.workflowTriggers = scope.workflow.data.workflowTriggers;
					}
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
					               '"value":"Slatwall'+ scope.workflowTriggers.selectedTrigger.data.workflow.workflowObject +'"'+
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
						scope.getEventOptions(scope.workflowTriggers.selectedTrigger.data.workflow.workflowObject);
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
				
				scope.selectEvent = function(eventOption){
					$log.debug('selectEvent');
					scope.workflowTriggers.selectedTrigger.data.triggerEvent = eventOption.value;
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
				
				scope.addWorkflowTrigger = function(){
					$log.debug('addWorkflowTrigger');
					var newWorkflowTrigger = $slatwall.newWorkflowTrigger();
					newWorkflowTrigger.data.workflow = scope.workflow.data;
					scope.workflowTriggers.selectedTrigger = newWorkflowTrigger;
					scope.workflowTriggers.push(newWorkflowTrigger);
					$log.debug(scope.workflowTriggers);
				};
			}
		};
	}
]);
	
