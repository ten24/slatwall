declare var $;
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
    public urlParams = new URLSearchParams(window.location.search);
    public isEnrollment: boolean = false;
    public currencyCode:string;
    public siteCode:string;

	// @ngInject
	constructor(
		//inject modal service
		public orderTemplateService,
		public monatService,
        public observerService,
        public ModalService,
        public $scope,
        private monatAlertService,
        public rbkeyService
	) { 
        this.observerService.attach(this.closeModals,"createWishlistSuccess"); 
        this.observerService.attach(this.closeModals,"addItemSuccess"); 
        this.observerService.attach(this.closeModals,"deleteOrderTemplateItemSuccess"); 
	}
	
	public $onInit = () => {
		this.$scope.$evalAsync(this.init);
		
		this.setIsEnrollment();
	}
	
	public init = () => {
		if(this.urlParams.get('type')){
			this.type = this.urlParams.get('type');
		}
		
		if(this.urlParams.get('orderTemplateId')){
			this.orderTemplate = this.urlParams.get('orderTemplateId');
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
			return result;
		})
		.catch((error)=>{
		    this.monatAlertService.error(this.rbkeyService.rbKey('define.flaxship.addProducterror'));
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

		
		this.ModalService.showModal({
			component: 'monatProductModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				siteCode:this.siteCode,
				currencyCode:this.currencyCode,
				product: this.product,
				type: this.type,
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
			this.orderTemplateService.addOrderTemplateItem(skuID, orderTemplateID)
			.then( (result) =>{
				 this.monatAlertService.success(this.rbkeyService.rbKey('alert.flaxship.addProductsucessfull'));
			} )
			.catch((error)=>{
			  this.monatAlertService.showErrorsFromResponse(error);  
			})
			.finally(()=>{
			     this.loading=false;
			});
		} else {
			this.monatService.addToCart(skuID, 1).then((result) => {
				this.monatAlertService.success(this.rbkeyService.rbKey('alert.flaxship.addProductsucessfull'));
				
			})
			.catch((error)=>{
			    this.monatAlertService.showErrorFromeResponse(error);
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
        $('.modal').modal('hide')
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

}

class MonatProductCard {
	public restrict: string = 'EA';
	public templateUrl: string;
	public scope: boolean = true;

	public bindToController = {
		product: '=',
		type: '@',
		index: '@',
		allProducts: '<?',
		orderTemplate: '<?',
		currencyCode:'@',
		siteCode:'@'
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
