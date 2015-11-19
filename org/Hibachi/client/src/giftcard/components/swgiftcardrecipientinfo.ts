/// <reference path="../../../client/typings/tsd.d.ts" />
/// <reference path="../../../client/typings/slatwallTypeScript.d.ts" />

class swGiftCardRecipientInfoController { 
	
	public giftCard; 
	
	constructor(){ 
		
	}
	
}

class GiftCardRecipientInfo implements ng.IDirective { 
	
	public static $inject = ["partialsPath"];
	public restrict:string; 
	public templateUrl:string;
	public scope = {}; 
	public bindToController = {
		giftCard:"=?"
	}; 
	public controller = swGiftCardRecipientInfoController; 
	public controllerAs = "swGiftCardRecipientInfo";
	
	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			collectionConfigService,
			partialsPath
		) => new GiftCardRecipientInfo(
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
		this.templateUrl = partialsPath + "/entity/giftcard/recipientinfo.html";
		this.restrict = "EA";
	}
	
}

export{
	swGiftCardRecipientInfoController,
	GiftCardRecipientInfo
}
	
