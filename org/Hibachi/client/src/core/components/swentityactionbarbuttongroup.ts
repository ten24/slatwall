/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWEntityActionBarButtonGroupController{
	// @ngInject;
	constructor(){

	}
}

class SWEntityActionBarButtonGroup implements ng.IDirective{

	public restrict:string = 'E';
	public scope = {};
	public transclude=true;
	public bindToController={

	};
	public controller=SWEntityActionBarButtonGroupController
	public controllerAs="swEntityActionBarButtonGroup";

	public template = require("./entityactionbarbuttongroup.html");

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}
}
export{
	SWEntityActionBarButtonGroup
}



