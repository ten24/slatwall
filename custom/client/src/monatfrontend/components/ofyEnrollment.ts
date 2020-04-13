
class OFYEnrollmentController {
	public flexship:string;
	public products:Array<{[key:string]:any}>;
	public stagedProductID:string;
	public loading:boolean;
	public endpoint: 'getOFYProductsForOrder' | 'getOrderTemplatePromotionSkus' = 'getOFYProductsForOrder';
	public action: 'addOrderTemplateItem' | 'addOrderItem' = 'addOrderItem';
	
	//@ngInject
	constructor( public observerService, public publicService, public orderTemplateService, public ModalService) {
	}

	public $onInit = () => {
		if(this.flexship){
			this.endpoint = 'getOrderTemplatePromotionSkus';
			this.action = 'addOrderTemplateItem';
		}
		this.getPromotionSkus()
	}

	private getPromotionSkus = () => {
		this.loading = true;
		let data = {
			orderTemplateId: this.flexship,
			pageRecordsShow: 20,
		}
		
		this.publicService.doAction(this.endpoint, data).then( result => {
			this.products = result.ofyProducts ? result.ofyProducts : result.orderTemplatePromotionSkus;
			this.loading = false;
		});
	}
	
	public addToCart():void{
		this.loading = true;
		
		let data ={
			skuID: this.stagedProductID,
			orderTemplateID:this.flexship
        }
        
		this.publicService.doAction(this.action, data ).then(res=>{
			this.observerService.notify('onNext');	
			this.loading = false;
		});
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
	public scope = {};
	public bindToController = {
		flexship: '<?',
	};
	public controller = OFYEnrollmentController;
	public controllerAs = 'ofyEnrollment';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/ofyEnrollment.html';
	}
}

export { OFYEnrollment };
