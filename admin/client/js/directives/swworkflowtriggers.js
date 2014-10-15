angular.module('slatwalladmin')
.directive('swWorkflowTriggers', 
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
		templateUrl:workflowPartialsPath+"workflowtriggers.html",
		link: function(scope, element,attrs,formController){
						
		}
	};
}]);
	
