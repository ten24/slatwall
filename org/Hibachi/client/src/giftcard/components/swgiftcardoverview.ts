/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
	
class SWGiftCardOverviewController { 
	
	public giftCard
	
	constructor(){ 
		
	}		
}

class SWGiftCardOverview implements ng.IDirective { 
	
	public restrict:string; 
	public templateUrl:string;
	public scope = {}; 
	public bindToController = {
		giftCard:"=?"
	}; 
	public controller = SWGiftCardOverviewController; 
	public controllerAs = "swGiftCardOverview"
	
	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			giftCardPartialsPath,
			pathBuilderConfig
		) => new SWGiftCardOverview(
			giftCardPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'giftCardPartialsPath',
			'pathBuilderConfig'
		];
		return directive;    
	}
		
	constructor(private giftCardPartialsPath, private pathBuilderConfig){ 
		this.templateUrl = pathBuilderConfig.buildPartialsPath(giftCardPartialsPath) + "/overview.html";
		this.restrict = "EA";	
	}
	
}

export {
	SWGiftCardOverviewController,
	SWGiftCardOverview
}

