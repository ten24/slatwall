'use strict';
angular.module('slatwalladmin')
.directive('swFormRegistrar', 
[
	'formService',
	function(formService){
		return {
			restrict: 'E',
			require:"^form",
			link: function(scope, element,attrs,formController){
				/*add form info at the form level*/
				formController.$$swFormInfo={
					object:scope.object,
					parentForm:scope.parentForm,
					parentObject:scope.parentObject,
					context:scope.context
				};
				scope.form = formController;
				/*register form with service*/
				formService.setForm(formController);
				
				/*register form at object level*/
				if(angular.isUndefined(scope.object.forms)){
					scope.object.forms = {};
				}
				scope.object.forms[formController.$name] = formController;
				
				/*if a context is supplied at the form level, then decorate the inputs with client side validation*/
				if(angular.isDefined(scope.context)){
					
				}
			}
		};
	}
]);
	
