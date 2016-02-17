/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFormFieldDateController implements ng.IDirective {
    public propertyDisplay:any;
    //@ngInject
    constructor (public formService) {

        if (this.propertyDisplay.isDirty == undefined) this.propertyDisplay.isDirty = false;
        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
        this.formService.setPristinePropertyValue(this.propertyDisplay.property,this.propertyDisplay.object.data[this.propertyDisplay.property]);
    }

}

class SWFormFieldDate implements ng.IDirective {
    public restrict = 'E';
    public require = "^form";
    public controller = SWFormFieldDateController;
    public controllerAs = "ctrl";
    public scope = true;
    public bindToController = {
        propertyDisplay: "="
    };

    //@ngInject
    public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attr:ng.IAttributes, formController: ng.IFormController) => {

    };

    public templateUrl;
    public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        )=> new SWFormFieldDate(
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
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "date.html";
    }
}
export{
    SWFormFieldDate
}



