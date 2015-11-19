/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
	
class SWGiftCardOverviewController { 
	
	public giftCard
	
	constructor(){ 
		
	}		
}

class SWGiftCardOverview implements ng.IDirective { 
	
	public static $inject = ["partialsPath"];
	
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
			partialsPath
		) => new SWGiftCardOverview(
			partialsPath
		);
		directive.$inject = [
			'partialsPath'
		];
		return directive;    
	}
		
	constructor(private partialsPath){ 
		this.templateUrl = partialsPath + "/entity/giftcard/overview.html";
		this.restrict = "EA";	
	}
	
}

export {
	SWGiftCardOverviewController,
	SWGiftCardOverview
}

