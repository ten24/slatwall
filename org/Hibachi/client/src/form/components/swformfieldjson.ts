/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

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
        hibachiPathBuilder
        )=> new SWFormFieldJson(
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
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "json.html";
    }

}

export{
    SWFormFieldJson
}

