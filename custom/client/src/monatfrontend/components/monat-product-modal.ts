class MonatProductModalController {
	public product;
	public type: string;
	public orderTemplateID: string;
	public currencyCode:string;
	public siteCode:string;
	public close; // injected from angularModalService

	public quantityToAdd: number = 1;
	
	public loading=false;
	public skuBundles: Array<any> = [];
	public productRating: Number;
	public reviewsCount: number = 0;
	public reviewStars: any = {
		full: 0,
		half: false,
		empty: 0
	};

	//@ngInject
	constructor(
		public monatService, 
		public observerService, 
		public rbkeyService, 
		private orderTemplateService, 
		private monatAlertService,
		private publicService
	) {}

	public $onInit = () => {
		this.makeTranslations();
		
		this.getModalInfo();
	};
	
	private getModalInfo = () => {
		this.publicService.doAction( 'getQuickShopModalBySkuID', { skuID: this.product.skuID } ).then( data => {
			this.skuBundles = data.skuBundles;
			this.productRating = data.productRating.product_calculatedProductRating;
			this.reviewsCount = data.reviewsCount;
			this.getReviewStars( this.productRating );
		});
	}
	
	private getReviewStars = ( productRating ) => {
	
		let rating = productRating.toFixed(1).split('.');
		
		let full = +rating[0];
		let remainder = +rating[1];
		
		if ( remainder > 2 && remainder < 8 ) {
			this.reviewStars.full = new Array( full );
			this.reviewStars.half = true;
			this.reviewStars.empty = new Array( 5 - full - 1 )
		} else {
			this.reviewStars.full = new Array( this.productRating.toFixed(0) );
			this.reviewStars.empty = 5 - this.reviewStars.full.length;
		}
	
	}

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
			
			this.monatAlertService.success(
				this.rbkeyService.rbKey("alert.flaxship.addProductsucessfull")
			);
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
		siteCode:'<',
		currencyCode:'<',
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
