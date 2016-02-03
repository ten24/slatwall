/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWActionCallerDropdownController{
    public title:string;
    public type:string;
    public icon:string;
    public dropdownClass:string;
    public dropdownId:string;
    public buttonClass:string;
    
    constructor(){
        this.title = this.title || '';
        this.icon = this.icon || 'plus';
        this.type = this.type || 'button';
        this.dropdownClass = this.dropdownClass || '';
        this.dropdownId = this.dropdownId || '';
        this.buttonClass = this.buttonClass || 'btn-primary';
    }
}

class SWActionCallerDropdown implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude=true;
    public bindToController={
        title:"@",
        icon:"@",
        type:"=",
        dropdownClass:"@",
        dropdownId:"@",
        buttonClass:"@"
    };
    public controller=SWActionCallerDropdownController
    public controllerAs="swActionCallerDropdown";
    public templateUrl;

    public static Factory(){
        var directive = (corePartialsPath,hibachiPathBuilder) => new SWActionCallerDropdown(corePartialsPath,hibachiPathBuilder);
        directive.$inject = ['corePartialsPath','hibachiPathBuilder'];
        return directive;
    }

    constructor(private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'actioncallerdropdown.html';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWActionCallerDropdownController,
    SWActionCallerDropdown
}


