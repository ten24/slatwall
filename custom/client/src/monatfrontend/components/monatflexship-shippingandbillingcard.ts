
class MonatFlexshipShippingAndBillingCardController {
	
	public restrict = 'EA'
    public orderTemplate; 
    
    //@ngInject
    constructor( public rbkeyService) {
    }
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	
    	this.translations['creditCardInfoLastFourDigit'] = this.rbkeyService.rbKey(
    		'frontend.flexshipDetails.creditCardInfoLastFourDigit',
    		{ 'lastFourDigit' : this.orderTemplate.accountPaymentMethod_creditCardLastFour }
    	);
    	
    	let creditCardInfoExpirationReplaceStringData = {
    		'month' : this.orderTemplate.accountPaymentMethod_expirationMonth,
    		'year' : this.orderTemplate.accountPaymentMethod_expirationYear
    	}
    	 
    	this.translations['creditCardInfoExpiration'] = this.rbkeyService.rbKey('frontend.flexshipDetails.creditCardInfoExpiration', creditCardInfoExpirationReplaceStringData);
    
    }
}

class MonatFlexshipShippingAndBillingCard {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<'
	};
	public controller = MonatFlexshipShippingAndBillingCardController;
	public controllerAs = "monatFlexshipShippingAndBillingCard";
	
	public template = require('./monatflexship-shippingandbillingcard.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipShippingAndBillingCard
};

