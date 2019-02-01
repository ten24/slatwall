/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWEntityActionBarButtonGroupController{
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
	public templateUrl;

	public static Factory(){
		var directive:ng.IDirectiveFactory=(
			corePartialsPath,
			hibachiPathBuilder
		) => new SWEntityActionBarButtonGroup(
			corePartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = ['corePartialsPath',
			'hibachiPathBuilder'];
		return directive;
	}
    //@ngInject
	constructor(private corePartialsPath,
			hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'entityactionbarbuttongroup.html';
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}
}
export{
	SWEntityActionBarButtonGroup
}



