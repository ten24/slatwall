angular.module('slatwalladmin')
.directive('swFormFieldJson', [
'$log',
'$slatwall',
'formService',
'partialsPath',
	function(
	$log,
	$slatwall,
	formService,
	partialsPath
	){
		return{
			templateUrl:partialsPath+'formfields/json.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				
			}
		};
	}
]);
	
