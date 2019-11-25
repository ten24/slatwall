class MonatProductModalController {
	public product;
	public type: string;
	public orderTemplateID: string;

	public close; // injected from angularModalService

	public quantityToAdd: number = 1;
	
	public loading=false;

	//@ngInject
	constructor(public monatService, public observerService, public rbkeyService, private orderTemplateService, private monatAlertService) {}

	public $onInit = () => {
		this.makeTranslations();
	};

	public translations = {};
	private makeTranslations = () => {
		if (this.type === 'flexship') {
			this.translations['addButtonText'] = this.rbkeyService.rbKey('frontend.global.addToFlexship');
		} else {
			this.translations['addButtonText'] = this.rbkeyService.rbKey('frontend.global.addToCart');
		}

		//TODO make translations for success/failure alert messages
	};


	public onAddButtonClick = () => {
		if (this.type === 'flexship') {
			this.addToFlexship();
		} else {
			this.addToCart();
		}
	};

	public addToFlexship = () => {
		this.loading = true;
		this.orderTemplateService.addOrderTemplateItem(
			this.product.skuID, 
			this.orderTemplateID,
			this.quantityToAdd
		)
		.then((data) => {
			this.monatAlertService.success("Product added to Flexship successfully");
			this.closeModal();
		})
		.catch( (error) => {
			console.error(error);
            this.monatAlertService.showErrorsFromResponse(error);
		})
		.finally(() => {
			this.loading = false;
		});
	};

	public addToCart = () => {
		this.loading = true;
		this.monatService.addToCart(
			this.product.skuID, 
			this.quantityToAdd
		)
		.then((data) => {
			this.monatAlertService.success("Product added to cart successfully");
			this.closeModal();
		})
		.catch( (error) => {
			console.error(error);
            this.monatAlertService.showErrorsFromResponse(error);
		})
		.finally(() => {
			this.loading = true;
		});
	};

	public closeModal = () => {
		console.log('closing modal');
		this.close(null); // close, but give 100ms to animate
	};
}

class MonatProductModal {
	public restrict: string;
	public templateUrl: string;

	public scope = {};
	public bindToController = {
		product: '<',
		type: '<',
		orderTemplateID: '<',
		close: '=', //injected by angularModalService
	};
	public controller = MonatProductModalController;
	public controllerAs = 'monatProductModal';

	public static Factory() {
		var directive: any = (monatFrontendBasePath, $hibachi, rbkeyService, requestService) =>
			new MonatProductModal(monatFrontendBasePath, $hibachi, rbkeyService, requestService);
		directive.$inject = ['monatFrontendBasePath', '$hibachi', 'rbkeyService', 'requestService'];
		return directive;
	}

	//@ngInject
	constructor(
		private monatFrontendBasePath,
		private slatwallPathBuilder,
		private $hibachi,
		private rbkeyService,
	) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monat-product-modal.html';
		this.restrict = 'E';
	}

	public link = (scope, element, attrs) => {};
}

export { MonatProductModal };
