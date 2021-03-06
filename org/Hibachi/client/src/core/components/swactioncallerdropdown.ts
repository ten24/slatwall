/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWActionCallerDropdownController{
    public title:string;
    public type:string;
    public icon:string;
    public dropdownClass:string;
    public dropdownId:string;
    public buttonClass:string;
    
    // @ngInject;
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

    public template = require("./actioncallerdropdown.html");

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}
}
export{
    SWActionCallerDropdownController,
    SWActionCallerDropdown
}


