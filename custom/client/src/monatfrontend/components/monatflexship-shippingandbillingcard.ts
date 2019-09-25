
class MonatFlexshipShippingAndBillingCardController {
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

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipShippingAndBillingCard(
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'$hibachi',
			'rbkeyService',
			'requestService'
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-shippingandbillingcard.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipShippingAndBillingCard
};

