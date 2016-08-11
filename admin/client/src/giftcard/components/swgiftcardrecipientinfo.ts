/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
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
			slatwallPathBuilder
		) => new SWGiftCardRecipientInfo(
			giftCardPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
			'giftCardPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}

	constructor(private giftCardPartialsPath, private slatwallPathBuilder){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/recipientinfo.html";
		this.restrict = "EA";
	}

}

export{
	SWGiftCardRecipientInfoController,
	SWGiftCardRecipientInfo
}

