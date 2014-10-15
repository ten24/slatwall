angular.module('slatwalladmin')
.directive('swWorkflowTasks', 
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
		templateUrl:workflowPartialsPath+"workflowtasks.html",
		link: function(scope, element,attrs,formController){
						
		}
	};
}]);
	
