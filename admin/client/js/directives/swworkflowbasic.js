angular.module('slatwalladmin')
.directive('swWorkflowBasic', 
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
		templateUrl:workflowPartialsPath+"workflowbasic.html",
		link: function(scope, element,attrs,formController){
						
		}
	};
}]);
	
