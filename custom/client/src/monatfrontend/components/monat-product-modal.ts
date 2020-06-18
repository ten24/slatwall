class MonatProductModalController {
	public product;
	public type: string;
	public orderTemplateID: string;
	public currencyCode:string;
	public siteCode:string;
	public close; // injected from angularModalService
	public productDetails:any;
	public quantityToAdd: number = 1;
	public showFullIngredients = false;
	public loading=false;
	public skuBundles: Array<any> = [];
	public productRating: Number;
	public reviewsCount: number = 0;
	public reviewStars: any = {
		full: 0,
		half: false,
		empty: 0
	};
	public muraContentIngredients:string;
	public muraValues:string;
	public productHowtoSteps: any = {
		rbkey : {
			'step': '',
			'of': ''
		},
		steps : {}
	};
	public trustedVideoURL:string;
	public trustedHowtoVideoURL:string;
	public videoRatio;
	public flexshipHasAccount:boolean;
	public sliderInitialized:boolean = false;
	
	//@ngInject
	constructor(
		public monatService, 
		public observerService, 
		public rbkeyService, 
		private orderTemplateService, 
		private monatAlertService,
		private publicService,
		private $sce
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
			this.productDetails = data.productData;
			this.trustedVideoURL = this.$sce.trustAsResourceUrl(data.productData.videoUrl);
			this.trustedHowtoVideoURL = this.$sce.trustAsResourceUrl(data.productData.productHowVideoUrl);
			this.muraContentIngredients = data.muraIngredients.length ? data.muraIngredients[0] : '';
			this.muraValues = data.muraValues.length ? data.muraValues[0] : '';
			this.productHowtoSteps = data.productData.productHowtoSteps;
			
			if(this.productDetails.videoHeight){
				this.setVideoRatio();
			}
		});
	}
	
	private getReviewStars = ( productRating ) => {
		if(!productRating) return;
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
		let extraProperties = "canPlaceOrderFlag,purchasePlusTotal,appliedPromotionMessagesJson,calculatedOrderTemplateItemsCount";
		if(!this.orderTemplateService.cartTotalThresholdForOFYAndFreeShipping){
			extraProperties += ',cartTotalThresholdForOFYAndFreeShipping';
		}
		
		let data = {
			optionalProperties: extraProperties,
			saveContext: 'upgradeFlow', 
			setIfNullFlag: false, 
			nullAccountFlag: this.flexshipHasAccount ? false : true
		}

		this.orderTemplateService.addOrderTemplateItem(
			this.product.skuID, 
			this.orderTemplateService.currentOrderTemplateID,
			this.quantityToAdd,
			false,
			data
		)
		.then((data) => {
			
			this.monatAlertService.success(
				this.rbkeyService.rbKey("alert.flexship.addProductSuccessful")
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
			this.monatAlertService.success(
				this.rbkeyService.rbKey("alert.cart.addProductSuccessful")
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

	public closeModal = () => {
		console.log('closing modal');
		this.close(null); // close, but give 100ms to animate
	};
	
	public setVideoRatio = ()=>{
    	let ratio = 16 / 9;
        ratio = Math.round( this.productDetails.videoHeight / this.productDetails.videoWidth * 100 * 10000 ) / 10000;
        this.videoRatio = ratio;
	}
	
	public initSlider = () => {
		if (!this.sliderInitialized) {
			this.sliderInitialized = true;
			
			var wordStep = this.productHowtoSteps.rbkey.step;
			var wordOf = this.productHowtoSteps.rbkey.of;
			
			$('.how-to-slider').ready(function(){
				var $sliderElement = $('.how-to-slider');
				
				$sliderElement.on('init reInit afterChange', function (event, slick, currentSlide, nextSlide) {
					var i = (currentSlide ? currentSlide : 0) + 1;
					$('.steps-count').text(wordStep + ' ' + i + ' ' + wordOf + ' ' + slick.slideCount);
				});
				
				$sliderElement.slick({
					infinite: true,
					autoplay: false,
					autoplaySpeed: 5000,
					dots: false,
					arrows: true,
					prevArrow:"<button type='button' class='slick-prev'><i class='fa fa-chevron-left' aria-hidden='true'></i></button>",
					nextArrow:"<button type='button' class='slick-next'><i class='fa fa-chevron-right' aria-hidden='true'></i></button>"
				});
			});		
		}
	}
}


class MonatProductModal {
	public restrict: string;
	public templateUrl: string;

	public scope = {};
	public bindToController = {
		siteCode:'<?',
		currencyCode:'<',
		product: '<',
		type: '<',
		orderTemplateID: '<?',
		flexshipHasAccount:'<?',
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
