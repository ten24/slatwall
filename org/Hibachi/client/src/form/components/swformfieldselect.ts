/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldSelect implements ng.IDirective {
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			formService,
			coreFormPartialsPath,
			utilityService,
            observerService,
			hibachiPathBuilder
		)=>new SWFormFieldSelect(
			$log,
			$hibachi,
			formService,
			coreFormPartialsPath,
			utilityService,
            observerService,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'formService',
			'coreFormPartialsPath',
			'utilityService',
            'observerService',
			'hibachiPathBuilder'
		];
		return directive;
	}
	//@ngInject
	constructor(
		$log,
		$hibachi,
		formService,
		coreFormPartialsPath,
		utilityService,
        observerService,
		hibachiPathBuilder
	){
		return{
			templateUrl:hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+'select.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope, element, attr, formController){


					//formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.valueOptions].value[0]);
			}
		};//<--end return
	}

}
export{
	SWFormFieldSelect
}


