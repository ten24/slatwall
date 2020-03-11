import{ HybridCartController, genericObject, GenericTemplate, GenericOrderTemplateItem} from './hybridCart';

class EnrollmentFlexshipController {
	public showCart = false;
	public cart:any;
	public isEnrollment:boolean;
	public orderTemplate:GenericTemplate;
	public orderTemplateID:string;
	public hybridCart:HybridCartController;
	public isLoading:boolean;
	public cartThreshold:number;
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(this.getFlexship.bind(this), 'addOrderTemplateItemSuccess')
	}

	public $onInit = () => {
		this.getFlexship();
	}
	
	public getFlexship():void {
		this.isLoading = true;
		let extraProperties = "canPlaceOrderFlag";
		if(!this.cartThreshold){
			extraProperties += ',cartTotalThresholdForOFYAndFreeShipping'
		}
		this.orderTemplateService.getSetOrderTemplateOnSession(extraProperties).then(data => {
			if((data.orderTemplate as GenericTemplate) ){
				this.orderTemplate = data.orderTemplate;
				this.cartThreshold = +this.orderTemplate.cartTotalThresholdForOFYAndFreeShipping;
				this.isLoading = false;
			} else {
				throw(data);
			}
		});
	}
	
    public removeOrderTemplateItem = (item:GenericOrderTemplateItem) => {
    	this.orderTemplateService
    	.removeOrderTemplateItem(item.orderTemplateItemID)
    	.then( (data) => {
        	this.getFlexship();
    	});
    }
    
    public increaseOrderTemplateItemQuantity = (item:GenericOrderTemplateItem) => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity + 1).then( (data) => {
        	this.getFlexship();
        });
    }
    
    public decreaseOrderTemplateItemQuantity = (item:GenericOrderTemplateItem) => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity - 1).then( data => {
        	this.getFlexship();
        });
    }

}

class EnrollmentFlexship {
	public restrict = 'E';
	public templateUrl: string;
	public scope = {};
	
	public bindToController = {
		orderTemplate: '<?'
	}
	
	public require={
		hybridCart : '^hybridCart'
	}
	
	public controller = EnrollmentFlexshipController;
	public controllerAs = 'enrollmentFlexship';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/enrollment-flexship.html';
	}
}

export { EnrollmentFlexship };
