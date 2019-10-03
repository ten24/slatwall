class MonatMiniCartController {
	public cart: any; // orderTemplateDetails

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
			'frontend.MiniCart.currentStepOfTtotalSteps',
			stepsPlaceHolderData,
		);
	};

	private fetchCart = () => {
		this.monatService
			.getCart()
			.then((data) => {
				if (data.cart) {
					this.cart = data.cart;
					//TODO handle errors / success
				} else {
					throw data;
				}
			})
			.catch((error) => {
				//TODO deal with the error
				throw error;
			})
			.finally(() => {
				//TODO deal with the loader ui
			});
	};

	private getCartItemIndexByID = (cartItemID: string) => {
		return this.cart.items.findIndex((it) => it.cartItemID === cartItemID);
	};

	public removeCartItem = (item) => {
		this.monatService.removeOrderTemplateItem(item.cartItemID).then(
			(data) => {
				if (data.successfulActions && data.successfulActions.indexOf('public:cart.removeItem') > -1) {
					this.cart = data.cart;
				} else {
					console.log('removeCartItem res: ', data);
				}
				//TODO handle errors / success
			},
			(reason) => {
				throw reason;
			},
		);
	};

	public increaseCartItemQuantity = (item) => {
		this.monatService.editCartItem(item.cartID, item.quantity + 1).then(
			(data) => {
				if (data.cart) {
					this.cart = data.cart;
				} else {
					console.error('increaseCartItemQuantity res: ', data);
				}
				//TODO handle errors / success
			},
			(reason) => {
				throw reason;
			},
		);
	};

	public decreaseOrderTemplateItemQuantity = (item) => {
		this.monatService.editCartItem(item.cartID, item.quantity - 1).then(
			(data) => {
				if (data.cart) {
					this.cart = data.cart;
				} else {
					console.error('decreaseOrderTemplateItemQuantity res: ', data);
				}
				//TODO handle errors / success
			},
			(reason) => {
				throw reason;
			},
		);
	};
}

class MonatMiniCart {
	public restrict: string;
	public templateUrl: string;

	public scope = {};
	public bindToController = {
		orderTemplateId: '@',
		orderTemplate: '<?',
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
