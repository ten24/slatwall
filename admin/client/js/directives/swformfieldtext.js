angular.module('slatwalladmin')
.directive('swFormFieldText', [
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
			templateUrl:partialsPath+'formfields/text.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
			}
		};
	}
]);
	
