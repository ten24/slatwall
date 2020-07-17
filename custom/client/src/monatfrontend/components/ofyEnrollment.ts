import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

class OFYEnrollmentController {
	public flexship:string;
	public products:Array<{[key:string]:any}>;
	public stagedProductID:string;
	public loading:boolean;
	public endpoint: 'getOFYProductsForOrder' | 'getOrderTemplatePromotionSkus' = 'getOFYProductsForOrder';
	public action: 'addOrderTemplateItem' | 'addOrderItem' = 'addOrderItem';
	
	//@ngInject
	constructor( public observerService, public publicService, public orderTemplateService: OrderTemplateService, public ModalService, public monatService) {
	}

	public $onInit = () => {
		if(this.flexship){
			this.endpoint = 'getOrderTemplatePromotionSkus';
			this.action = 'addOrderTemplateItem';
			this.getPromotionSkus()
		}else{
			this.monatService.getOFYItemsForOrder().then(res => {
				console.log(res);
				this.products = res;
			})
		}
	}

	private getPromotionSkus = () => {
		this.loading = true;
		let data = {
			orderTemplateId: this.flexship,
			pageRecordsShow: 20,
		}
		
		if(!this.products){ 
			this.publicService.doAction(this.endpoint, data).then( result => {
				this.products = result.ofyProducts ? result.ofyProducts : result.orderTemplatePromotionSkus;
				this.loading = false;
				if(!this.flexship && !this.products.length){
					this.observerService.notify('onNext');
				}
			});
		}
		
		this.loading = false;
	}
	
	public addToCart():void{
		this.loading = true;

        if(this.action == 'addOrderItem'){

	 		this.monatService.addOFYItem(this.stagedProductID, 1 ).then(res=>{
				this.observerService.notify('onNext');	
				this.loading = false;
			});       	

        } else {
    		let extraProperties = "qualifiesForOFYProducts,canPlaceOrderFlag,purchasePlusTotal,appliedPromotionMessagesJson,calculatedOrderTemplateItemsCount,vatTotal,taxTotal,fulfillmentHandlingFeeTotal";
			let data = {
				optionalProperties: extraProperties,
				saveContext: 'upgradeFlow', 
				setIfNullFlag: false, 
				nullAccountFlag: false
			}
			
 	 		this.orderTemplateService
 	 		.addOrderTemplateItem( this.stagedProductID, this.flexship, 1, true, data)
 	 		.then( res => {
				this.observerService.notify('onNext');	
				this.loading = false;
			});        	

        }

	}
	
	public stageProduct(skuID:string):void{
		this.stagedProductID = skuID;
	}
	
	public launchQuickShopModal = (product) => {
		this.ModalService.showModal({
			component: 'monatProductModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				currencyCode:(this.products as any)[0].currencyCode,
				product: product,
				isEnrollment: true,
				type:'ofy'
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
	
}

class OFYEnrollment{
	public restrict: string = 'E';
	public transclude: boolean = true;
	public templateUrl: string;
	public bindToController = {
		flexship: '<?',
		products:'<?'
	};
	public controller = OFYEnrollmentController;
	public controllerAs = 'ofyEnrollment';

	public template = require('./ofyEnrollment.html');

	public static Factory() {
		return () => new this();
	}
}

export { OFYEnrollment };
