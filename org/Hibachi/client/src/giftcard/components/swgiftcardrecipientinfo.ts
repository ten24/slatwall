/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

class SWGiftCardRecipientInfoController { 
	
	public giftCard; 
	
	constructor(){ 
		
	}
	
}

class SWGiftCardRecipientInfo implements ng.IDirective { 
	
	public static $inject = ["partialsPath"];
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
			partialsPath
		) => new SWGiftCardRecipientInfo(
			partialsPath
		);
		directive.$inject = [
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
	SWGiftCardRecipientInfoController,
	SWGiftCardRecipientInfo
}
	
