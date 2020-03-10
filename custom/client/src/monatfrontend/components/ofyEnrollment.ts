
class OFYEnrollmentController {
	public flexship:string;
	public products:Array<object>;
	public stagedProductID:string;
	public loading:boolean;
	
	//@ngInject
	constructor( public observerService, public publicService, public orderTemplateService) {
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
            orderTemplateSystemCode: 'ottSchedule',
            saveContext: 'upgradeFlow',
            returnJSONObjects:''
        }
        
		this.publicService.doAction('addOrderItem,createOrderTemplate', data ).then(res=>{
			
			if(res.orderTemplate){
				this.orderTemplateService.canPlaceOrderFlag = false;
				document.cookie = "flexshipID=" + res.orderTemplate;
				this.observerService.notify('newOrderTemplate', res.orderTemplate);
				this.observerService.notify('onNext');	
			}
			this.loading = false;
		});
	}
	
	public stageProduct(skuID:string):void{
		this.stagedProductID = skuID;
	}
	
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
