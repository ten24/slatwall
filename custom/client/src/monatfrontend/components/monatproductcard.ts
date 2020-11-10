import { MonatService } from "@Monat/services/monatservice";
import { PublicService } from "@Monat/monatfrontend.module";
import { ObserverService, RbKeyService } from "@Hibachi/core/core.module";
import { OrderTemplateService } from "@Monat/services/ordertemplateservice";
import { MonatAlertService } from "@Monat/services/monatAlertService";

declare var $;
declare var hibachiConfig;

class MonatProductCardController {
	public product;
	public type: string;
	public loading: boolean;
	public loaded: boolean = false;
	public lastAddedSkuID: string; 
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
        public $scope               : ng.IScope,
        public $location            : ng.ILocationService,
        public $timeout				: ng.ITimeoutService,
        public ModalService,
        public monatService         : MonatService, 
        public rbkeyService         : RbKeyService,
	    public publicService        : PublicService, 
	    public observerService      : ObserverService, 
        private monatAlertService   : MonatAlertService,
	    public orderTemplateService : OrderTemplateService,
	    
	) { 
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
	
	private removeSkuIdFromWishlistItemsCache( skuID:string ){
        //update-cache, put new product into wishlist-items
        let cachedAccountWishlistItemIDs = this.publicService.getFromSessionCache('cachedAccountWishlistItemIDs') || [];
        cachedAccountWishlistItemIDs = cachedAccountWishlistItemIDs.filter( item =>  item.skuID !== skuID );
        this.publicService.putIntoSessionCache("cachedAccountWishlistItemIDs", cachedAccountWishlistItemIDs);
    }

	public deleteWishlistItem = (index) => {
		this.loading = true;
		const item = this.allProducts[index];
		this.orderTemplateService.deleteOrderTemplateItem(item.orderItemID)
		.then((result) => {
			
			this.removeSkuIdFromWishlistItemsCache(item.skuID);
			this.allProducts.splice(index, 1);
			document.body.classList.remove('modal-open'); // If it's the last item, the modal will be deleted and not properly closed.
		})
		.catch((error)=>{
		    this.monatAlertService.error(this.rbkeyService.rbKey('alert.flexship.addProducterror'));
		})
		.finally(()=>{
		    this.loading =false;
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
				flexshipHasAccount: this.flexshipType == 'flexshipHasAccount' ? true : false
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
			let extraProperties = "canPlaceOrderFlag,purchasePlusTotal,appliedPromotionMessagesJson,calculatedOrderTemplateItemsCount,otherDiscountTotal";

			if(this.flexshipType == 'flexshipHasAccount'){
				extraProperties += ',qualifiesForOFYProducts,vatTotal,taxTotal,fulfillmentHandlingFeeTotal,fulfillmentTotal';
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
			.then( (result: any) =>{
			    if(!result.hasErrors) {	
			    	this.monatAlertService.success(this.rbkeyService.rbKey('alert.cart.addProductSuccessful')); 
				}
				else{
				    throw(result);
				}
			} )
			.catch((error)=>{
			  this.monatAlertService.showErrorsFromResponse(error);  
			})
			.finally(()=>{
			     this.loading=false;
			     this.addToCartToggle();
			});
		} else {
			this.monatService.addToCart(skuID, 1).then((result) => {
				if(!result.hasErrors) {	
			    	this.monatAlertService.success(this.rbkeyService.rbKey('alert.cart.addProductSuccessful')); 
				}else{
				    this.monatAlertService.showErrorsFromResponse(result);
				}
			})
			.catch((error)=>{
			    this.monatAlertService.showErrorsFromResponse(error);
			})
			.finally(()=>{
				this.loading=false;
				this.addToCartToggle();
			});
		}
	};
	
	public addToCartToggle(){
		this.loaded = true;
		this.$timeout(()=>{
			this.loaded = false;	
			}, 3000);
	}
	
    public closeModals = () =>{
        $('.modal').modal('hide');
        $('.modal-backdrop').remove() 
    }
    
	public launchWishlistsModal = () => {
    	this.monatService.launchWishlistsModal(this.product.skuID, this.product.productID, this.product.productName);
	};
	
	private setIsEnrollment = (): void => {
		this.isEnrollment = (
			this.type === 'enrollment'
			|| this.type === 'VIPenrollmentOrder'
			|| this.type === 'VIPenrollment'
		);
	}
	
	public setIsAccountWishlistItem = () => {
		this.isAccountWishlistItem = this.accountWishlistItems?.includes?.(this.product.skuID);
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

	public template = require('./monatproductcard.html');

	public static Factory() {
		return () => new this();
	}
}

export { MonatProductCardController, MonatProductCard };
