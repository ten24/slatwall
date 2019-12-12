declare var $;
class MonatProductCardController {
	public product;
	public type: string = '';
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
    public showProductLink: boolean = false;

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
		
		this.setShowProductLinkByType();
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
				this.loading = false;
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
			this.loading = false;
			return result;
		})
		.catch((error)=>{
		    this.monatAlertService.error(this.rbkeyService.rbKey('define.flagship.error'));
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
				this.loading = false;
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
			this.loading = false;
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
				product: this.product,
				type: this.type,
				orderTemplateID: this.orderTemplate,
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
				// this.changeTypeForDemo(); //TODO remove
			},
		}).then((modal) => {
			modal.element.modal(); //it's a bootstrap element, using '.modal()' to show it
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	
	};
	
	//TODO remove
	private changeTypeForDemo = () => {
		let types = ['','flexship','wishlist','enrollment'];
		let index = types.indexOf(this.type);
		index++;
		this.type = types[index % types.length];
		
		console.log('changed type for demo :', this.type);
	};

	public addToCart = (skuID, skuCode) => {
		this.loading = true;
		this.lastAddedSkuID = skuID;
		let orderTemplateID = this.orderTemplate;
		if (this.type === 'flexship' || this.type==='VIPenrollment') {
			this.orderTemplateService.addOrderTemplateItem(skuID, orderTemplateID)
			.then( (result) =>{
				 this.monatAlertService.success(this.rbkeyService.rbKey('define.flagship.sucessfully'));
				this.loading = false;
			} )
			.catch((error)=>{
			  this.monatAlertService.showErrorsFromResponse(error);  
			})
		} else {
			this.monatService.addToCart(skuID, 1).then((result) => {
				this.monatAlertService.success(this.rbkeyService.rbKey('define.flagship.sucessfully'));
				this.loading = false;
				
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
	
	private setShowProductLinkByType = (): void => {
		this.showProductLink = (
			this.type !== 'enrollment'
			&& this.type !== 'VIPenrollmentOrder'
			&& this.type !== 'VIPenrollment'
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
