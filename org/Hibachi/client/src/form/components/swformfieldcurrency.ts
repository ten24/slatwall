/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldCurrencyController {
    public propertyDisplay:any;
	constructor () {
        if (this.propertyDisplay.isDirty == undefined) this.propertyDisplay.isDirty = false;
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	}
}

class SWFormFieldCurrency implements ng.IDirective {
    public restrict = 'E';
    //public require = "^form";
    public scope = true;
    public bindToController = {
        propertyDisplay: "=?"
    };
    public templateUrl = "";
    public controller = SWFormFieldCurrencyController;
    public controllerAs = "swFormFieldCurrency";

    public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}

    public static Factory(){
        var directive = (
            coreFormPartialsPath,hibachiPathBuilder
        )=> new SWFormFieldCurrency(
            coreFormPartialsPath,hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }
    constructor(coreFormPartialsPath,hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "number.html";
    }
}
export{
    SWFormFieldCurrency,
    SWFormFieldCurrencyController
}

