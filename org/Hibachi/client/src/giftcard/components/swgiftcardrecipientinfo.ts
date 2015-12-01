/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />

class SWGiftCardRecipientInfoController { 
	
	public giftCard; 
	
	constructor(){ 
		
	}
	
}

class SWGiftCardRecipientInfo implements ng.IDirective { 
	
	public restrict:string; 
	public templateUrl:string;
	public scope = {}; 
	public bindToController = {
		giftCard:"=?"
	}; 
	public controller = SWGiftCardRecipientInfoController; 
	public controllerAs = "swGiftCardRecipientInfo";
	
	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			giftCardPartialsPath,
			pathBuilderConfig
		) => new SWGiftCardRecipientInfo(
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
		this.templateUrl = pathBuilderConfig.buildPartialsPath(giftCardPartialsPath) + "/recipientinfo.html";
		this.restrict = "EA";
	}
	
}

export{
	SWGiftCardRecipientInfoController,
	SWGiftCardRecipientInfo
}
	
