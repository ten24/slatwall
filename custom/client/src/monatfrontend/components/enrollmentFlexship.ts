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
	public suggestedRetailPrice: 0; 
	
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
				this.calculateSRPOnOrder();
				this.isLoading = false;
			} else {
				throw(data);
			}
		});
	}
	
    public removeOrderTemplateItem = (item:GenericOrderTemplateItem):void => {
    	this.orderTemplateService
    	.removeOrderTemplateItem(item.orderTemplateItemID)
    	.then( (data) => {
        	this.getFlexship();
    	});
    }
    
    public increaseOrderTemplateItemQuantity = (item:GenericOrderTemplateItem):void => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity + 1).then( (data) => {
        	this.getFlexship();
        });
    }
    
    public decreaseOrderTemplateItemQuantity = (item:GenericOrderTemplateItem):void => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity - 1).then( data => {
        	this.getFlexship();
        });
    }
    
    public calculateSRPOnOrder= ():void =>{
    	if(!this.orderTemplate.orderTemplateItems) return;
    	this.suggestedRetailPrice = 0;
    	for(let item of this.orderTemplate.orderTemplateItems){
    		this.suggestedRetailPrice += item.calculatedListPrice;
    	}
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
