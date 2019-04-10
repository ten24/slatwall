class SWGiftCardOverviewController {

	public giftCard

	//@ngInject
	constructor() {

	}
}

class SWGiftCardOverview implements ng.IDirective {

	public restrict: string;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		giftCard: "=?"
	};
	public controller = SWGiftCardOverviewController;
	public controllerAs = "swGiftCardOverview"

	public static Factory(): ng.IDirectiveFactory {
		var directive: ng.IDirectiveFactory = (
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

	//@ngInject
	constructor(private giftCardPartialsPath, private slatwallPathBuilder) {
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/overview.html";
		this.restrict = "EA";
	}

}

export {
	SWGiftCardOverviewController,
	SWGiftCardOverview
}

