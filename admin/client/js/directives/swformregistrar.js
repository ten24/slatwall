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
				formService.setForm(formController);
			}
		};
	}
]);
	
