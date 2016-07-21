/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWFormField{
	public static Factory(){
		var directive = (
			$log,
			$templateCache,
			$window,
			$hibachi,
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		)=>new SWFormField(
			$log,
			$templateCache,
			$window,
			$hibachi,
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$templateCache',
			'$window',
			'$hibachi',
			'formService',
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		 $log,
		 $templateCache,
		 $window,
		 $hibachi,
		 formService,
		 coreFormPartialsPath,
		 hibachiPathBuilder
	){
		return {
			require:"^form",
			restrict: 'AE',
			scope:{
				propertyDisplay:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+'formfield.html',
			link: (scope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) =>{
				if(angular.isUndefined(scope.propertyDisplay.object.$$getID) || scope.propertyDisplay.object.$$getID() === ''){
					scope.propertyDisplay.isDirty = true;
				}

				if(angular.isDefined(formController[scope.propertyDisplay.property])){
					scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
					formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
				}
			}
		};
	}
}
export{
	SWFormField
}
//	angular.module('slatwalladmin').directive('swFormField',['$log','$templateCache', '$window', '$hibachi', 'formService', 'coreFormPartialsPath',($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath) => new swFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath)]);

