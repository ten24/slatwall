
class OFYEnrollmentController {
	public flexship:string;
	public products:Array<object>;
	public stagedProductID:string;
	public loading:boolean;
	
	//@ngInject
	constructor( public observerService, public publicService, public orderTemplateService, public ModalService) {
	}

	public $onInit = () => {
		this.getPromotionSkus()
	}

	private getPromotionSkus = () => {
		this.loading = true;
		let data = {
			orderTemplateId: this.flexship,
			pageRecordsShow: 20,
		}
		
		this.publicService.doAction('getOFYProductsForOrder').then( result => {
			this.products = result.ofyProducts;
			this.loading = false;
		});
	}
	
	public addToCart():void{
		this.loading = true;
		
		let data ={
			skuID: this.stagedProductID,
        }
        
		this.publicService.doAction('addOrderItem', data ).then(res=>{
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
				currencyCode:this.products[0].currencyCode,
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
