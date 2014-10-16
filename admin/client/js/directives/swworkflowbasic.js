angular.module('slatwalladmin')
.directive('swWorkflowBasic', 
[
'$log',
'$location',
'$slatwall',
'formService',
'workflowPartialsPath',
'workflowService',
function(
$log,
$location,
$slatwall,
formService,
workflowPartialsPath,
workflowService
){
	return {
		require:"^form",
		restrict: 'A',
		
		templateUrl:workflowPartialsPath+"workflowbasic.html",
		link: function(scope, element,attrs,formController){
			$log.debug('workflow basic init');	
			//get workflow item
			
			var workflowID = $location.search().workflowID;
			
			scope.propertyDisplayData = {};
			
			scope.getPropertyDisplayData = function(){
				var propertyDisplayDataPromise = $slatwall.getPropertyDisplayData('workflow',{propertyIdentifiersList:'workflowName,workflowObject,activeFlag'});
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
			scope.getPropertyDisplayData();
			
			
			scope.getWorkflow = function(){
				var workflowPromise = $slatwall.getEntity('workflow',{id:workflowID});
				workflowPromise.then(function(value){
					formService.setForm(scope.form.workflowForm);
					scope.workflow = value;
					workflowService.setWorkflow(scope.workflow);
					$log.debug('workflow loaded');
					$log.debug(scope.workflow);
				},function(reason){
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlers(alerts);
				});
			};
			
			if(angular.isDefined(workflowID)){
				scope.getWorkflow();
			}
			
			
			
			
		}
	};
}]);
	
