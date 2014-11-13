angular.module('slatwalladmin')
.directive('swWorkflowTriggers', 
[
'$log',
'$location',
'$slatwall',
'workflowService',
'workflowTriggerService',
'workflowPartialsPath',
function(
$log,
$location,
$slatwall,
workflowService,
workflowTriggerService,
workflowPartialsPath
){
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			workflow:"="
		},
		templateUrl:workflowPartialsPath+"workflowtriggers.html",
		link: function(scope, element,attrs,formController){
			$log.debug('workflow triggers init');	
			
			scope.$id = 'swWorkflowTriggers';
				
			scope.getWorkflowTriggers = function(){
				
				scope.workflowTriggers = scope.workflow.$$getWorkflowTriggers();
				console.log(scope.workflowTriggers);
				/*var filterGroupsConfig ='['+  
					'{'+
                     	'"filterGroup":['+  
				            '{'+
				               '"propertyIdentifier":"_workflow.workflowID",'+
				               '"comparisonOperator":"=",'+
				               '"value":"'+scope.workflowID+'"'+
				           '}'+ 
				         ']'+
					'}'+
				']';
				scope.workflowTriggers = $slatwall.getWorkflowTrigger({filterGroupsConfig:filterGroupsConfig});
				
				workflowTriggerPromise.then(function(value){
					$log.debug('getWorkflowTriggers');
					//scope.workflowTriggers = workflowTriggerService.formatWorkflowTriggers(value.pageRecords);
					$log.debug(scope.workflowTriggers);
					
				});
				console.log('workflowTriggers');
				console.log(scope.workflowTriggers);*/
			};
			
			scope.getWorkflowTriggers();
			/*
			scope.showCollections = false;
			scope.collections = [];
			
			scope.getCollectionByWorkflowObject = function(){
				var filterGroupsConfig ='['+  
					'{'+
	                 	'"filterGroup":['+  
				            '{'+
				               '"propertyIdentifier":"_collection.collectionObject",'+
				               '"comparisonOperator":"=",'+
				               '"value":"Slatwall'+ scope.workflowTriggers.selectedTrigger.workflow.workflowObject +'"'+
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
					scope.getEventOptions(scope.workflowTriggers.selectedTrigger.workflow.workflowObject);
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
				scope.workflowTriggers.selectedTrigger.triggerEvent = eventOption.value;
				scope.searchEvent.name = eventOption.name;
				$log.debug(eventOption);
				$log.debug(scope.workflowTriggers);
			};
			
			scope.selectCollection = function(collection){
				$log.debug('selectCollection');
				scope.workflowTriggers.selectedTrigger.scheduleCollection = collection;
				scope.showCollections = false;
			};
			
			scope.addWorkflowTrigger = function(){
				$log.debug('addWorkflowTrigger');
				var newWorkflowTrigger = workflowTriggerService.newWorkflowTrigger();
				newWorkflowTrigger.workflow = workflowService.getWorkflow(scope.workflowID);
				scope.workflowTriggers.selectedTrigger = newWorkflowTrigger;
				scope.workflowTriggers.push(newWorkflowTrigger);
				$log.debug(scope.workflowTriggers);
			};
			
			scope.removeWorkflowTrigger = function(workflowTrigger){
				if(workflowTrigger === scope.workflowTriggers.selectedTrigger){
					delete scope.workflowTriggers.selectedTrigger;
				}
				scope.workflowTriggers.splice(workflowTrigger.$$index,1);
			};
			
			scope.saveTrigger = function(){
				var params = {
					'objectPropertyIdentifier':scope.workflowTriggers.selectedTrigger.objectPropertyIdentifier,
					'triggerEvent':scope.workflowTriggers.selectedTrigger.triggerEvent,
					'triggerType':scope.workflowTriggers.selectedTrigger.triggerType,
					'workflow.workflowID':scope.workflowTriggers.selectedTrigger.workflow.workflowID,
					'workflowTriggerID':'',
					'propertyIdentifiersList':'workflowTriggerID'
				};
				var saveTriggerPromise = $slatwall.saveEntity('WorkflowTrigger',null,params,'Save');
				
				saveTriggerPromise.then(function(value){
					$log.debug('saveTrigger');
					scope.workflowTriggers.selectedTrigger.workflowTriggerID = value.data.workflowTriggerID;
					delete scope.workflowTriggers.selectedTrigger;
				},function(reason){
					
				});
			};
			*/
			
		}
	};
}]);
	
