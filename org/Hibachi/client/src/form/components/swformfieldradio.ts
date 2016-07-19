/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormFieldRadio implements ng.IDirective {
	public static Factory(){
		var directive = (
			$log,$timeout,coreFormPartialsPath,hibachiPathBuilder,utilityService
		)=> new SWFormFieldRadio(
			$log,$timeout,coreFormPartialsPath,hibachiPathBuilder,utilityService
		);
		directive.$inject = [
			'$log','$timeout','coreFormPartialsPath','hibachiPathBuilder','utilityService'
		];
		return directive;
	}
	//@ngInject
	constructor($log,$timeout,coreFormPartialsPath,hibachiPathBuilder,utilityService){

		return{
			templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+'radio.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope, element, attr, formController){


			}
		};
	}

}
export{
	SWFormFieldRadio
}
