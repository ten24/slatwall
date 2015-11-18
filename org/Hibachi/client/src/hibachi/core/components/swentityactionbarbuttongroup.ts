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
			partialsPath
		) => new SWEntityActionBarButtonGroup(
			partialsPath
		);
		directive.$inject = ['partialsPath'];
		return directive;
	}
	
	constructor(private partialsPath){
		this.templateUrl = partialsPath+'entityactionbarbuttongroup.html';
	}
	
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		
	}
}
export{
	SWEntityActionBarButtonGroup
}    
	//angular.module('slatwalladmin').directive('swEntityActionBarButtonGroup',['partialsPath',(partialsPath) => new SWEntityActionBarButtonGroup(partialsPath)]);


