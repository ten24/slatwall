/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />


class SWFormFieldNumberController implements ng.IDirective {
    public propertyDisplay:any;
	constructor () {
        if (this.propertyDisplay.isDirty == undefined) this.propertyDisplay.isDirty = false;
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	}
}

class SWFormFieldNumber implements ng.IDirective {
    public restrict = 'E';
    public require = "^form";
    public scope = true;
    public bindToController = {
        propertyDisplay: "=?"
    };
    public templateUrl = "";
    public controller = SWFormFieldNumberController;
    public controllerAs = "ctrl";

    public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}

    public static Factory(){
        var directive = (
            coreFormPartialsPath,pathBuilderConfig
        )=> new SWFormFieldNumber(
            coreFormPartialsPath,pathBuilderConfig
        );
        directive.$inject = ['coreFormPartialsPath','pathBuilderConfig'];
        return directive;
    }
    constructor(coreFormPartialsPath,pathBuilderConfig) {
        this.templateUrl = pathBuilderConfig.buildPartialsPath(coreFormPartialsPath) + "number.html";
    }
}
export{
    SWFormFieldNumber
}

