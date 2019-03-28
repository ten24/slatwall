/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountPaymentMethodModalController{

	public accountPaymentMethod;
	
	//Order or Order Template
	public baseEntityName;
	public baseEntity;
	public baseEntityPrimaryID:string;
		
	public swCustomerAccountPaymentMethodCard;
	
	public title:string="Edit Billing Information";
	public uniqueName:string = 'accountPaymentMethodModal';
	public formName:string = 'accountPaymentMethodModal';
	
	//account address labels
	public accountAddressNameTitle:string = 'Nickname';
	public streetAddressTitle:string = "Street Address"; 
	public street2AddressTitle:string = "Street Address 2";
	public cityTitle:string = 'City'; 
	public stateCodeTitle:string = 'State Code';
	
	//account payment method labels
	public accountPaymentMethodNameTitle:string = 'Nickname';
	public creditCardNumberTitle:string = "Credit Card"; 
	public nameOnCreditCardTitle:string = "Name on Credit Card"; 
	public expirationMonthTitle:string = "Expiration Month";
	public expirationYearTitle:string = "Expiration Year"; 
	
	public processContext:string = 'updateBilling';
	
	public newAccountAddress;
	public newAccountPaymentMethod;
	
	public showCreateBillingAddress:boolean=false; 
	public showCreateAccountPaymentMethod:boolean=false;
	
	public createBillingAddressTitle:string = 'Add a new address';
	public createAccountPaymentMethodTitle:string = 'Add a new payment method';

	constructor( public $timeout,
	             public $hibachi,
	             public entityService,
	             public observerService,
				 public rbkeyService,
				 public requestService
	){
		
	}
	
	public $onInit = () =>{
			
		this.baseEntityName = this.swCustomerAccountPaymentMethodCard.baseEntityName;
		this.baseEntityPrimaryID = this.swCustomerAccountPaymentMethodCard.baseEntity[this.baseEntityName + 'ID'];
		
		this.baseEntity = this.swCustomerAccountPaymentMethodCard.baseEntity;
		
		if(this.swCustomerAccountPaymentMethodCard.accountPaymentMethod != null){
			this.accountPaymentMethod = this.swCustomerAccountPaymentMethodCard.accountPaymentMethod;
		}
		
	}
	
	public save = () =>{
		/*this.observerService.notify('updateBindings');
		
		//build url
		//var queryString = 'processContext=' + this.processContext + '&' + this.baseEntityName + 'ID=' + this.baseEntityPrimaryID;
		//var requestUrl = this.$hibachi.buildUrl('admin:entity.process' + this.baseEntityName, queryString);
		
		//structure data
		if(this.newAccountPaymentMethod == null){
			this.baseEntity.$$setAccountPaymentMethod(this.newAccountPaymentMethod);
		}
		
		if(this.newAccountAddress == null){
			this.baseEntity.$$setBillingAccountAddress(this.newAccountAddress); 
		}
		
		return this.baseEntity.$$save();*/
		
		
	}
	
	public toggleCreateBillingAddress = () =>{
	    if(this.newAccountAddress == null){
	        this.newAccountAddress = {
	        	address:{}
	        }
	    }
	}
	
	public toggleCreateAccountPaymentMethod = () =>{
	    if(this.newAccountPaymentMethod == null){
	        this.newAccountPaymentMethod = {};
	    }
	}
}

class SWAccountPaymentMethodModal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountPaymentMethod:"<?",
		baseEntityName:"@?",
		baseEntity:"<?",
		processContext:"@?",
	    title:"@?",
	    createBillingAddressTitle:"@?",
	    createAccountPaymentMethodTitle:"@?",
	    accountAddressNameTitle:"@?",
		streetAddressTitle:"@?",
		street2AddressTitle:"@?",
		cityTitle:"@?", 
		stateCodeTitle:"@?",
		accountPaymentMethodNameTitle:"@?",
		creditCardNumberTitle:"@?",
		nameOnCreditCardTitle:"@?",
		expirationMonthTitle:"@?",
		expirationYearTitle:"@?"
	};
	public require = {
		swCustomerAccountPaymentMethodCard:"^^swCustomerAccountPaymentMethodCard"
	};
	
	public controller=SWAccountPaymentMethodModalController;
	public controllerAs="swAccountPaymentMethodModal";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAccountPaymentMethodModal(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountpaymentmethodmodal.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAccountPaymentMethodModal
};

