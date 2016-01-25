/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTooltipController {

    // @ngInject
	constructor(){
        
	}
}

class SWTooltip implements ng.IDirective{

	public static $inject=["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
			'hibachiPathBuilder'];
	public templateUrl;
    public transclude=false;
	public restrict = "E";
	public scope = {}

	public bindToController = {
        
	}
	public controller=SWTooltipController;
	public controllerAs="swTooltip";

	constructor(private corePartialsPath,hibachiPathBuilder){
	   this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tooltip.html";
    }

	public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, controller:any, transclude:any) =>{
	}
    
	public static Factory(){
		var directive:ng.IDirectiveFactory = (corePartialsPath,hibachiPathBuilder) => new SWTooltip(corePartialsPath,hibachiPathBuilder);
		directive.$inject = ["corePartialsPath","hibachiPathBuilder"];
		return directive;
	}
}
export{
	SWTooltip,
	SWTooltipController
}
