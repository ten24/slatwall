class MonatFlexshipMenuController {
	public orderTemplate: any;
	public monatFlexshipCard;

	//@ngInject
	constructor() {}

	public $onInit = () => {};

	public showCancelFlexshipModal = () => {
		this.monatFlexshipCard.showCancelFlexshipModal();
	};

	public showDelayOrSkipFlexshipModal = () => {
		this.monatFlexshipCard.showDelayOrSkipFlexshipModal();
	};

	public showFlexshipEditPaymentMethodModal = () => {
		this.monatFlexshipCard.showFlexshipEditPaymentMethodModal();
	};

	public showFlexshipEditShippingMethodModal = () => {
		this.monatFlexshipCard.showFlexshipEditShippingMethodModal();
	};

	public showFlexshipEditFrequencyMethodModal = () => {
		this.monatFlexshipCard.showFlexshipEditFrequencyMethodModal();
	};

	public activateFlexship() {
		this.monatFlexshipCard.activateFlexship();
	}

	public setAsCurrentFlexship() {
		this.monatFlexshipCard.setAsCurrentFlexship();
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

	public static Factory() {
		var directive: any = (monatFrontendBasePath, $hibachi, rbkeyService, requestService) =>
			new MonatFlexshipMenu(monatFrontendBasePath, $hibachi, rbkeyService, requestService);
		directive.$inject = ['monatFrontendBasePath', '$hibachi', 'rbkeyService', 'requestService'];
		return directive;
	}

	constructor(
		private monatFrontendBasePath,
		private slatwallPathBuilder,
		private $hibachi,
		private rbkeyService,
	) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monatflexshipmenu.html';
		this.restrict = 'EA';
	}

	public link = (scope, element, attrs) => {};
}

export { MonatFlexshipMenu };
