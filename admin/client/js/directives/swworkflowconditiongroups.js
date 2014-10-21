angular.module('slatwalladmin')
.directive('swWorkflowConditionGroups', 
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
		restrict: 'A',
		
		templateUrl:workflowPartialsPath+"workflowconditiongroups.html",
		link: function(scope, element,attrs,formController){
		}
	};
}]);
	
