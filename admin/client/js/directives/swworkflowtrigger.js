angular.module('slatwalladmin')
.directive('swWorkflowTrigger', 
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
			workflowTrigger:"="
		},
		templateUrl:workflowPartialsPath+"workflowtrigger.html",
		link: function(scope, element,attrs,formController){
			$log.debug('workflow trigger init');			
		}
	};
}]);
	
