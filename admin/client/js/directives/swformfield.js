angular.module('slatwalladmin')
.directive('swFormField', [
'$log',
'$templateCache',
'$window',
'$slatwall',
'formService',
'partialsPath',
	function(
	$log,
	$templateCache,
	$window,
	$slatwall,
	formService,
	partialsPath
	){
		return {
			require:"^form",
			restrict: 'AE',
			replace:true,
			scope:{
				propertyDisplay:"="
			},
			templateUrl:partialsPath+'formfields/formfield.html',
			link: function(scope, element,attrs,formController){
				console.log('editingformm');
				console.log(scope.propertyDisplay.editable);
				if(scope.propertyDisplay.object.$$getID() === ''){
					scope.propertyDisplay.isDirty = true;
				}
				
				if(angular.isDefined(formController[scope.propertyDisplay.property])){
					scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
					formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
				}
				
			}
		};
	}
]);
	
