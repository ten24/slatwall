/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
	
class swGiftCardOverviewController { 
	
	public giftCard
	
	constructor(){ 
		
	}		
}

class GiftCardOverview implements ng.IDirective { 
	
	public static $inject = ["partialsPath"];
	
	public restrict:string; 
	public templateUrl:string;
	public scope = {}; 
	public bindToController = {
		giftCard:"=?"
	}; 
	public controller = swGiftCardOverviewController; 
	public controllerAs = "swGiftCardOverview"
	
	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			collectionConfigService,
			partialsPath
		) => new GiftCardOverview(
			collectionConfigService,
			partialsPath
		);
		directive.$inject = [
			'$slatwall',
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
	swGiftCardOverviewController,
	GiftCardOverview
}

