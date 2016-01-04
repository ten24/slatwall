/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />

class SWFormFieldJsonController implements ng.IDirective {
    public propertyDisplay:any;
	//@ngInject
    constructor (formService) {
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	}
}

class SWFormFieldJson implements ng.IDirective {
    public restrict = 'E';
    public require = "^form";
    public scope = true;
    public controller = SWFormFieldJsonController;
    public bindToController = {
        propertyDisplay: "=?"
    };
    public controllerAs = "ctrl";
    public templateUrl = "";
    public formController: ng.IFormController;

    public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
    public static Factory(){
        var directive = (
            coreFormPartialsPath,
        pathBuilderConfig
        )=> new SWFormFieldJson(
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
        this.templateUrl = pathBuilderConfig.buildPartialsPath(coreFormPartialsPath) + "json.html";
    }

}

export{
    SWFormFieldJson
}

