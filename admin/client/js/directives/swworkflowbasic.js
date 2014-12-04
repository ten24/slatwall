angular.module('slatwalladmin')
.directive('swWorkflowBasic', [
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
			scope:{
				workflow:"="
			},
			templateUrl:workflowPartialsPath+"workflowbasic.html",
			link: function(scope, element,attrs){
			}
		};
	}
]);
	
