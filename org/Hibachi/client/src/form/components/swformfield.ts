/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />


class SWFormField{
	public static Factory(){
		var directive = (
			$log,
			$templateCache,
			$window,
			$slatwall,
			formService,
			coreFormPartialsPath,
			pathBuilderConfig
		)=>new SWFormField(
			$log,
			$templateCache,
			$window,
			$slatwall,
			formService,
			coreFormPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'$templateCache',
			'$window',
			'$slatwall',
			'formService',
			'coreFormPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		 $log,
		 $templateCache,
		 $window,
		 $slatwall,
		 formService,
		 coreFormPartialsPath,
		 pathBuilderConfig
	){
		return {
			require:"^form",
			restrict: 'AE',
			scope:{
				propertyDisplay:"="
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(coreFormPartialsPath)+'formfield.html',
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
//	angular.module('slatwalladmin').directive('swFormField',['$log','$templateCache', '$window', '$slatwall', 'formService', 'coreFormPartialsPath',($log, $templateCache, $window, $slatwall, formService, coreFormPartialsPath) => new swFormField($log, $templateCache, $window, $slatwall, formService, coreFormPartialsPath)]);

