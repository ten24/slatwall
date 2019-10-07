class MonatMiniCartController {
	public cart: any; // orderTemplateDetails
	public type:any;
	
	//@ngInject
	constructor(public monatService, public rbkeyService, public ModalService) {}

	public $onInit = () => {
		this.makeTranslations();

		if (this.cart == null) {
			this.fetchCart();
		}
	};

	public translations = {};
	private makeTranslations = () => {
		//TODO make translations for success/failure alert messages
		this.makeCurrentStepTranslation();
	};

	private makeCurrentStepTranslation = (currentStep: number = 1, totalSteps: number = 2) => {
		//TODO BL?
		let stepsPlaceHolderData = {
			currentStep: currentStep,
			totalSteps: totalSteps,
		};
		this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey(
			'frontend.miniCart.currentStepOfTtotalSteps',
			stepsPlaceHolderData,
		);
	};

	private fetchCart = () => {
		this.monatService
			.getCart()
			.then((data) => {
				if (data) {
					this.cart = data;
				}
			})
			.catch((error) => {
				//TODO deal with the error
				throw error;
			})
			.finally(() => {
				//TODO deal with the loader
			});
	};

	public removeItem = (item) => {
		this.monatService
			.removeFromCart(item.orderItemID)
			.then((data) => {
				this.cart = data;
			})
			.catch((reason) => {
				throw reason;
				//TODO handle errors / success
			})
			.finally(() => {
				//TODO hide loader...
			});
	};

	public increaseItemQuantity = (item) => {
		this.monatService
			.updateCartItemQuantity(item.orderItemID, item.quantity + 1)
			.then((data) => {
				this.cart = data;
			})
			.catch((reason) => {
				throw reason; //TODO handle errors / success alerts
			})
			.finally(() => {
				//TODO hide loader...
			});
	};

	public decreaseItemQuantity = (item) => {
		if (item.quantity <= 1) return;

		this.monatService
			.updateCartItemQuantity(item.orderItemID, item.quantity - 1)
			.then((data) => {
				this.cart = data;
			})
			.catch((reason) => {
				throw reason; //TODO handle errors / success
			})
			.finally(() => {
				//TODO hide loader...
			});
	};
}

class MonatMiniCart {
	public restrict: string;
	public templateUrl: string;

	public scope = {};
	public bindToController = {
		orderTemplateId: '@',
		orderTemplate: '<?',
		type: '@?',
		style:'@?'
	};
	public controller = MonatMiniCartController;
	public controllerAs = 'monatMiniCart';

	public static Factory() {
		var directive: any = (monatFrontendBasePath, $hibachi, rbkeyService, requestService) =>
			new MonatMiniCart(monatFrontendBasePath, $hibachi, rbkeyService, requestService);
		directive.$inject = ['monatFrontendBasePath', '$hibachi', 'rbkeyService', 'requestService'];
		return directive;
	}

	constructor(
		private monatFrontendBasePath,
		private slatwallPathBuilder,
		private $hibachi,
		private rbkeyService,
	) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/minicart/monat-minicart.html';
		this.restrict = 'EA';
	}

	public link = (scope, element, attrs) => {};
}

export { MonatMiniCart };
