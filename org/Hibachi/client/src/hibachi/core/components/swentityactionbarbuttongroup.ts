/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../..//typings/tsd.d.ts' />
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
			pathBuilderConfig
		) => new SWEntityActionBarButtonGroup(
			corePartialsPath,
			pathBuilderConfig
		);
		directive.$inject = ['corePartialsPath',
			'pathBuilderConfig'];
		return directive;
	}
	
	constructor(private corePartialsPath,
			pathBuilderConfig){
		this.templateUrl = pathBuilderConfig.buildPartialsPath(corePartialsPath)+'entityactionbarbuttongroup.html';
	}
	
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		
	}
}
export{
	SWEntityActionBarButtonGroup
}    
	


