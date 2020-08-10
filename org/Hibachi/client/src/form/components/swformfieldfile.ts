/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldFileController  {
	public propertyDisplay:any;
	//@ngInject
	constructor (public formService) {
		if (this.propertyDisplay.isDirty == undefined) this.propertyDisplay.isDirty = false;
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
		//this.formService.setPristinePropertyValue(this.propertyDisplay.property,this.propertyDisplay.object.data[this.propertyDisplay.property]);
	}

}

class SWFormFieldFile implements ng.IDirective {
	public restrict = 'E';
	public require = "^form";
	public controller = SWFormFieldFileController;
	public controllerAs = "swFormFieldFile";
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
			hibachiPathBuilder
		)=> new SWFormFieldFile(
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		coreFormPartialsPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "file.html";
	}
}
export{
	SWFormFieldFile
}


