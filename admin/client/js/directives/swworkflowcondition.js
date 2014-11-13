angular.module('slatwalladmin')
.directive('swWorkflowCondition', 
[
'$log',
'$location',
'$slatwall',
'formService',
'workflowPartialsPath',
function(
$log,
$location,
$slatwall,
formService,
workflowPartialsPath
){
	return {
		restrict: 'A',
		
		templateUrl:workflowPartialsPath+"workflowcondition.html",
		link: function(scope, element,attrs){
		}
	};
}]);
	
