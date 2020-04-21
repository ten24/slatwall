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
	public messages:any;
	public type:string;
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(this.refreshFlexship.bind(this), 'addOrderTemplateItemSuccess');
	}

	public $onInit = () => {
		if(this.type != 'vipFlexshipFlow'){
			this.getFlexship();
		}
	}
	
	public refreshFlexship = () =>{
		this.manageNewOrderTemplate(this.orderTemplateService.mostRecentOrderTemplate);
	}
	
	public getFlexship():void {
	
		this.isLoading = true;
		let extraProperties = "canPlaceOrderFlag,purchasePlusTotal,appliedPromotionMessagesJson,calculatedOrderTemplateItemsCount";
		if(!this.cartThreshold){
			extraProperties += ',cartTotalThresholdForOFYAndFreeShipping'
		}
		
		let nullAccountFlag = this.type != 'vipFlexshipFlow';
		//todo: use some type of fe caching here to avoid duplicate api calls
		this.orderTemplateService.getSetOrderTemplateOnSession(extraProperties, 'upgradeFlow', nullAccountFlag, nullAccountFlag ).then(data => {

			if((data.orderTemplate as GenericTemplate) ){
				this.manageNewOrderTemplate(data.orderTemplate);
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
    		this.suggestedRetailPrice += (item.calculatedListPrice * item.quantity);
    	}
    }
    
    public manageNewOrderTemplate(orderTemplate){
		this.orderTemplate = orderTemplate;
		if(this.orderTemplate.cartTotalThresholdForOFYAndFreeShipping) this.cartThreshold = +this.orderTemplate.cartTotalThresholdForOFYAndFreeShipping;
		this.calculateSRPOnOrder();
		let messages = this.orderTemplate.appliedPromotionMessagesJson ? JSON.parse(this.orderTemplate.appliedPromotionMessagesJson) : [];
		messages = messages.filter(el => el.promotion_promotionName?.indexOf('Purchase Plus') > -1);
		
		if(!messages || !messages.length){
			this.messages = null;
		}else{
			this.messages = {
				message: messages[0].message,
				amount: messages[0].promotionPeriod_promotionRewards_amount,
				qualifierProgress: messages[0].qualifierProgress,
			}	
		}
    }

}

class EnrollmentFlexship {
	public restrict = 'E';
	public templateUrl: string;
	public scope = {};
	
	public bindToController = {
		orderTemplate: '=?',
		type: '<?'
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
