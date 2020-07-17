class MonatFlexshipMenuController {
	public restrict = 'EA'
	public orderTemplate: any;
	public monatFlexshipCard;

	//@ngInject
	constructor(public publicService) {}

	public $onInit = () => {};

	public showCancelFlexshipModal = () => {
		this.monatFlexshipCard.showCancelFlexshipModal();
	};
	
	public showAddGiftCardModal = () => {
		this.monatFlexshipCard.showAddGiftCardModal();
	};
	
	//TODO: remove
	public showDelayOrSkipFlexshipModal = () => {
		this.monatFlexshipCard.showDelayOrSkipFlexshipModal();
	};
	
	//TODO: remove
	public showFlexshipEditFrequencyMethodModal = () => {
		this.monatFlexshipCard.showFlexshipEditFrequencyMethodModal();
	};

	public showFlexshipScheduleModal = () => {
		this.monatFlexshipCard.showFlexshipScheduleModal();
	};

	public showFlexshipEditPaymentMethodModal = () => {
		this.monatFlexshipCard.showFlexshipEditPaymentMethodModal();
	};

	public showFlexshipEditShippingMethodModal = () => {
		this.monatFlexshipCard.showFlexshipEditShippingMethodModal();
	};



	public activateFlexship() {
		this.monatFlexshipCard.activateFlexship();
	}

	public goToProductListingPage() {
		this.monatFlexshipCard.goToProductListingPage();
	}
	
	public goToOFYProductListingPage() {
		this.monatFlexshipCard.goToOFYProductListingPage();
	}
	
	public showDeleteFlexshipModal = () => {
		this.monatFlexshipCard.showDeleteOrderTemplateModal();
	}
	
}

class MonatFlexshipMenu {
	public restrict: string;
	public templateUrl: string;
	public scope = {};
	public require = {
		monatFlexshipCard:"^monatFlexshipCard"
	};
	public bindToController = {
		orderTemplate: '='
	};
	public controller = MonatFlexshipMenuController;
	public controllerAs = 'monatFlexshipMenu';

	public template = require('./monatflexshipmenu.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) => {};
}

export { MonatFlexshipMenu };
