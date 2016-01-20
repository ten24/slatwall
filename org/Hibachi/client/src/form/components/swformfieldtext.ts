/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormFieldTextController implements ng.IDirective {
	public propertyDisplay:any;
	//@ngInject
	constructor (public formService) {

		if (this.propertyDisplay.isDirty == undefined) this.propertyDisplay.isDirty = false;
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
		this.formService.setPristinePropertyValue(this.propertyDisplay.property,this.propertyDisplay.object.data[this.propertyDisplay.property]);
	}

}

class SWFormFieldText implements ng.IDirective {
	public restrict = 'E';
	public require = "^form";
	public controller = SWFormFieldTextController;
	public controllerAs = "ctrl";
	public scope = true;
	public bindToController = {
		propertyDisplay: "="
	};

	//@ngInject
	public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attr:ng.IAttributes, formController: ng.IFormController) => {

	}

	public templateUrl;
	public static Factory(){
		var directive = (
			coreFormPartialsPath,
			pathBuilderConfig
		)=> new SWFormFieldText(
			coreFormPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'coreFormPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		coreFormPartialsPath,
		pathBuilderConfig
	) {
		this.templateUrl = pathBuilderConfig.buildPartialsPath(coreFormPartialsPath) + "text.html";
	}
}
export{
	SWFormFieldText
}
//     angular.module('slatwalladmin').directive('swFormFieldText', ['$log','$hibachi','formService','partialsPath', ($log, $hibachi, formService, partialsPath) => new SWFormFieldText($log, $hibachi, formService, partialsPath)]);
// }


