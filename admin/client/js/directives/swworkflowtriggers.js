angular.module('slatwalladmin')
.directive('swWorkflowTriggers', 
[
'$log',
'$location',
'$slatwall',
'alertService',
'workflowTriggerService',
'workflowPartialsPath',
function(
$log,
$location,
$slatwall,
alertService,
workflowTriggerService,
workflowPartialsPath
){
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			
		},
		templateUrl:workflowPartialsPath+"workflowtriggers.html",
		link: function(scope, element,attrs,formController){
			$log.debug('workflow triggers init');	
			
			scope.workflowID = $location.search().workflowID;
			scope.$id = 'swWorkflowTriggers'
				
			/*scope.getPropertyDisplayData = function(){
				var propertyDisplayDataPromise = $slatwall.getPropertyDisplayData('workflowTrigger',{propertyIdentifiersList:'triggerType'});
				propertyDisplayDataPromise.then(function(value){
					scope.propertyDisplayData = value.data;
					$log.debug('getting property Display meta data');
					$log.debug(scope.propertyDisplayData);
				},function(reason){
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlers(alerts);
				});
			};
			scope.getPropertyDisplayData();*/
				
			scope.getWorkflowTriggers = function(){
				var filterGroupsConfig ='['+  
					'{'+
                     	'"filterGroup":['+  
				            '{'+
				               '"propertyIdentifier":"workflow.workflowID",'+
				               '"comparisonOperator":"=",'+
				               '"value":"'+scope.workflowID+'"'+
				           '}'+ 
				         ']'+
					'}'+
				']';
				var workflowTriggerPromise = $slatwall.getEntity('workflowTrigger',{filterGroupsConfig:filterGroupsConfig});
				
				workflowTriggerPromise.then(function(value){
					$log.debug('getWorkflowTriggers');
					scope.workflowTriggers = workflowTriggerService.formatWorkflowTriggers(value.pageRecords);
					$log.debug(scope.workflowTriggers);
					
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
			};
			
			scope.getWorkflowTriggers();
			
			scope.addWorkflowTrigger = function(){
				$log.debug('addWorkflowTrigger');
				var newWorkflowTrigger = workflowTriggerService.newWorkflowTrigger();
				newWorkflowTrigger.workflow = {};
				newWorkflowTrigger.workflow.workflowID = scope.workflowID;
				scope.workflowTriggers.selectedTrigger = newWorkflowTrigger;
				scope.workflowTriggers.push(newWorkflowTrigger);
				$log.debug(scope.workflowTriggers);
			}
		}
	};
}]);
	
