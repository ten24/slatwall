declare var $;
declare var hibachiConfig;

class MonatProductCardController {
	public product;
	public type: string;
	public loading: boolean;
	public lastAddedSkuID: string; 
	public newTemplateID: string;
	public orderTemplates: Array<any>;
	public pageRecordsShow: number = 5;
	public currentPage: number = 1;
	private wishlistTypeID: string = '2c9280846b712d47016b75464e800014';
	public allProducts: Array<any>;
	private wishlistTemplateID: string;
	private wishlistTemplateName: string;
	public orderTemplate;
    public isEnrollment: boolean = false;
    public accountWishlistItems;
    public isAccountWishlistItem: boolean = false;
    public currencyCode:string;
    public siteCode:string;
	public flexshipType:string;
	
	// @ngInject
	constructor(
		//inject modal service
		public orderTemplateService,
		public monatService,
        public observerService,
        public ModalService,
        public $scope,
        private monatAlertService,
        public rbkeyService,
        public $location
	) { 
        this.observerService.attach(this.closeModals,"createWishlistSuccess"); 
        this.observerService.attach(this.closeModals,"addOrderTemplateItemSuccess"); 
        this.observerService.attach(this.closeModals,"deleteOrderTemplateItemSuccess"); 
	}
	
	public $onInit = () => {
		this.$scope.$evalAsync(this.init);
		
		if ( 'undefined' === typeof this.currencyCode ) {
			this.currencyCode = hibachiConfig.currencyCode
		}
		
		this.setIsEnrollment();
		
		// We want to run this on init AND attach to the "accountWishlistItemsSuccess" 
		// because this directive could load before or after that trigger happens
		this.setIsAccountWishlistItem();
	}
	
	public init = () => {
		if(this.$location.search().type){
			this.type = this.$location.search().type;
		}
		
		if(this.$location.search().orderTemplateId){
			this.orderTemplate = this.$location.search().orderTemplateId;
		}
	}
	
	public getAllWishlists = (
		pageRecordsToShow: number = this.pageRecordsShow,
		setNewTemplates: boolean = true,
		setNewTemplateID: boolean = false,
	) => {
		this.loading = true;

		this.orderTemplateService
			.getOrderTemplates(this.wishlistTypeID, pageRecordsToShow, this.currentPage)
			.then((result) => {
				if (setNewTemplates) {
					this.orderTemplates = result['orderTemplates'];
				} else if (setNewTemplateID) {
					this.newTemplateID = result.orderTemplates[0].orderTemplateID;
				}
			})
			.catch((error)=>{
			    this.monatAlertService.showErrorsFromResponse(error)
			})
			.finally(()=>{
			    this.loading=false;
			});
	};

	public deleteItem = (index) => {
		this.loading = true;
		const item = this.allProducts[index];
		this.orderTemplateService.deleteOrderTemplateItem(item.orderItemID).then((result) => {
			this.allProducts.splice(index, 1);
			document.body.classList.remove('modal-open'); // If it's the last item, the modal will be deleted and not properly closed.
			return result;
		})
		.catch((error)=>{
		    this.monatAlertService.error(this.rbkeyService.rbKey('alert.flexship.addProducterror'));
		})
		.finally(()=>{
		    this.loading =false;
		});
	};

	public addItemAndCreateWishlist = (orderTemplateName: string, skuID, quantity: number = 1) => {
		this.loading = true;
		this.orderTemplateService
			.addOrderTemplateItemAndCreateWishlist(orderTemplateName, skuID, quantity)
			.then((result) => {
				this.getAllWishlists();
				this.isAccountWishlistItem = true;
				return result;
			})
			.catch((error)=>{
			 this.monatAlertService.showErrorsFromResponse(error);   
			})
			.finally(()=>{
			  this.loading = false;  
			});
	};

	public addWishlistItem = (skuID) => {
		this.loading = true;
		this.orderTemplateService.addOrderTemplateItem(skuID, this.wishlistTemplateID).then((result) => {
			this.isAccountWishlistItem = true;
			return result;
		})
		.catch((error)=>{
		    this.monatAlertService.showErrorsFromResponse(error);
		})
		.finally(()=>{
		    this.loading = false;
		});
	};

	
	public launchQuickShopModal = () => {
		let type = '';
		
		if(this.type=='flexship' || (this.type.indexOf('VIP') >-1 && this.type != 'VIPenrollmentOrder' ) ){
			type = 'flexship';
		};
	
		this.ModalService.showModal({
			component: 'monatProductModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				siteCode:this.siteCode,
				currencyCode:this.currencyCode,
				product: this.product,
				type: type,
				isEnrollment: this.isEnrollment,
				orderTemplateID: this.orderTemplate,
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		}).then((modal) => {
			modal.element.modal(); //it's a bootstrap element, using '.modal()' to show it
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	
	};

	public addToCart = (skuID, skuCode) => {
		this.loading = true;
		this.lastAddedSkuID = skuID;
		let orderTemplateID = this.orderTemplate;
		if (this.type === 'flexship' || this.type==='VIPenrollment') {
			let extraProperties = "canPlaceOrderFlag,purchasePlusTotal,appliedPromotionMessagesJson,calculatedOrderTemplateItemsCount";

			if(this.flexshipType == 'flexshipHasAccount'){
				extraProperties += ',qualifiesForOFYProducts,vatTotal,taxTotal';
			}
			
			if(!this.orderTemplateService.cartTotalThresholdForOFYAndFreeShipping){
				extraProperties += ',cartTotalThresholdForOFYAndFreeShipping';
			}
	
			let data = {
				optionalProperties: extraProperties,
				saveContext: 'upgradeFlow', 
				setIfNullFlag: false, 
				nullAccountFlag: this.flexshipType == 'flexshipHasAccount' ? false : true
			}
	
			this.orderTemplateService.addOrderTemplateItem(skuID, orderTemplateID, 1, false, data)
			.then( (result) =>{
			    if(result.successfulActions &&
					result.successfulActions.indexOf('public:order.addOrderTemplateItem') > -1) {
					//	this.orderTemplateService.getSetOrderTemplateOnSession('qualifiesForOFYProducts', 'save', false, false);
					}
				 else{
				     throw (result);
				 }
			} )
			.catch((error)=>{
			  this.monatAlertService.showErrorsFromResponse(error);  
			})
			.finally(()=>{
			     this.loading=false;
			});
		} else {
			this.monatService.addToCart(skuID, 1).then((result) => {
			    if(result.successfulActions &&
					result.successfulActions.indexOf('public:cart.addOrderItem') > -1) {
				this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.addProductSuccessful')); 
			    }
				else{
				    throw(result);
				}
			})
			.catch((error)=>{
			    this.monatAlertService.showErrorsFromResponse(error);
			})
			.finally(()=>{
			 this.loading=false;
			});
		}
	};

	public setWishlistID = (newID) => {
		this.wishlistTemplateID = newID;
	};

	public setWishlistName = (newName) => {
		this.wishlistTemplateName = newName;
	};
	
    public closeModals = () =>{
        $('.modal').modal('hide');
        $('.modal-backdrop').remove() 
    }
    
	public launchWishlistModal = (skuID, productName) => {
		let newSkuID = skuID

		this.ModalService.showModal({
			component: 'swfWishlist',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				sku: newSkuID,
				productName: productName
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
			.then((modal) => {
				//it's a bootstrap element, use 'modal' to show it
				modal.element.modal();
				modal.close.then((result) => {});
			})
			.catch((error) => {
				console.error('unable to open model :', error);
			});
	};
	
	private setIsEnrollment = (): void => {
		this.isEnrollment = (
			this.type === 'enrollment'
			|| this.type === 'VIPenrollmentOrder'
			|| this.type === 'VIPenrollment'
		);
	}
	
	public setIsAccountWishlistItem = () => {
		if ( 
			'undefined' !== typeof this.accountWishlistItems 
			&& this.accountWishlistItems.length
		) {
			this.isAccountWishlistItem = this.accountWishlistItems.indexOf(this.product.productID) > -1;
		}
	}

}

class MonatProductCard {
	public restrict: string = 'EA';
	public templateUrl: string;
	public scope: boolean = true;

	public bindToController = {
		product: '=',
		type: '@',
		index: '@',
		accountWishlistItems: '<?',
		allProducts: '<?',
		orderTemplate: '<?',
		currencyCode:'@',
		siteCode:'@',
		flexshipType:"<?"
	};

	public controller = MonatProductCardController;
	public controllerAs = 'monatProductCard';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monatproductcard.html';
	}
}

export { MonatProductCardController, MonatProductCard };
