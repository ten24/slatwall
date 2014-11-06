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
			
			/*scope.propertyDisplayData = {};
			
			scope.getPropertyDisplayData = function(){
				var propertyDisplayDataPromise = $slatwall.getPropertyDisplayData('workflow',{propertyIdentifiersList:'workflowName,workflowObject,activeFlag'});
				propertyDisplayDataPromise.then(function(value){
					scope.propertyDisplayData = value.data;
					$log.debug('getting property Display meta data');
					$log.debug(scope.propertyDisplayData);
				});
			};
			scope.getPropertyDisplayData();
			
			*/
			scope.getWorkflow = function(){
				scope.workflow = $slatwall.getWorkflow({id:workflowID});
				formService.setForm(scope.form.workflowForm);
				$log.debug('workflow loaded');
				$log.debug(scope.workflow);
				/*workflowPromise.then(function(value){
					
					scope.workflow = value;
					workflowService.setWorkflow(scope.workflow);
					
				});*/
			};
			
			if(angular.isDefined(workflowID)){
				scope.getWorkflow();
			}
		}
	};
}]);
	
