angular.module('slatwalladmin')
.directive('swWorkflowTask', 
[
'$log',
'workflowPartialsPath',
function(
$log,
workflowPartialsPath
){
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			
		},
		templateUrl:workflowPartialsPath+"workflowtask.html",
		link: function(scope, element,attrs,formController){
			$log.debug('workflow task init');		
		}
	};
}]);
	
