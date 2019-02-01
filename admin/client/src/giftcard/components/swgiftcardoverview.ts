/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
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
			slatwallPathBuilder
		) => new SWGiftCardOverview(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/overview.html";
		this.restrict = "EA";
	}

}

export {
	SWGiftCardOverviewController,
	SWGiftCardOverview
}

