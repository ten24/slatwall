angular.module('slatwalladmin')
.directive('swWorkflowConditionGroupItem', 
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
		
		templateUrl:workflowPartialsPath+"workflowconditiongroupitem.html",
		link: function(scope, element,attrs){
		}
	};
}]);
	
