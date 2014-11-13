angular.module('slatwalladmin')
.directive('swWorkflowBasic', 
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
		require:"^form",
		restrict: 'A',
		scope:{
			workflow:"="
		},
		templateUrl:workflowPartialsPath+"workflowbasic.html",
		link: function(scope, element,attrs,formController){
			//formService.setForm(scope.form.workflowForm);
		}
	};
}]);
	
