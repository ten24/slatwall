/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />

class swFormFieldPasswordController implements ng.IDirective {
    public propertyDisplay:any;
    //@ngInject
	public constructor () {
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	}
}

class SWFormFieldPassword implements ng.IDirective {
    public templateUrl;
    public restrict = 'E';
    public require = "^form";
    public scope = true;
    public bindToController = {
        propertyDisplay: "=?"
    };
    public controller = swFormFieldPasswordController;
    public controllerAs = "ctrl";

    public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
    public static Factory(){
        var directive = (
            coreFormPartialsPath,pathBuilderConfig
        )=>new SWFormFieldPassword(
            coreFormPartialsPath,pathBuilderConfig
        );
        directive.$inject = ['coreFormPartialsPath','pathBuilderConfig'];
        return directive;
    }

    //@ngInject
    public constructor(coreFormPartialsPath,pathBuilderConfig) {
        this.templateUrl = pathBuilderConfig.buildPartialsPath(coreFormPartialsPath) + "password.html";
    }

}

export{
    SWFormFieldPassword
}