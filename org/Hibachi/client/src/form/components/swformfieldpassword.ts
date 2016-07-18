/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class swFormFieldPasswordController implements ng.IDirective {
    public propertyDisplay:any;
    public form:ng.IFormController;
    //@ngInject
	public constructor () {


	}

    public $onInit=()=>{
        if(this.propertyDisplay.isDirty){
            this.form.$dirty = this.propertyDisplay.isDirty || this.propertyDisplay.form.$dirty;
        }
    }
}

class SWFormFieldPassword implements ng.IDirective {
    public templateUrl;
    public restrict = 'E';
    public require = {form:"^form"};
    public scope = true;
    public bindToController = {
        propertyDisplay: "=?"
    };
    public controller = swFormFieldPasswordController;
    public controllerAs = "ctrl";

    public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
    public static Factory(){
        var directive = (
            coreFormPartialsPath,hibachiPathBuilder
        )=>new SWFormFieldPassword(
            coreFormPartialsPath,hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }

    //@ngInject
    public constructor(coreFormPartialsPath,hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "password.html";
    }

}

export{
    SWFormFieldPassword
}