/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountPaymentMethodModalController{

	public accountPaymentMethod;
	
	//Options
	public accountAddressOptions;
	public accountPaymentMethodOptions;
	public expirationMonthOptions;
	public expirationYearOptions;
	public stateCodeOptions;
	
	//Order or Order Template
	public baseEntityName;
	public baseEntity;
	public processObject;
	public baseEntityPrimaryID:string;
		
	public swCustomerAccountPaymentMethodCard;
	
	public title:string="Edit Billing Information";
	public uniqueName:string = 'accountPaymentMethodModal';
	public formName:string = 'accountPaymentMethodModal';
	
	public billingAccountAddressTitle:string = 'Select Billing Address';
	public accountPaymentMethodTitle:string = 'Select Account Payment Method';
	
	//account address labels
	public accountAddressNameTitle:string = 'Nickname';
	public streetAddressTitle:string = "Street Address"; 
	public street2AddressTitle:string = "Street Address 2";
	public cityTitle:string = 'City'; 
	public stateCodeTitle:string = 'State';
	public postalCodeTitle:string = 'Postal Code'
	
	//account payment method labels
	public accountPaymentMethodNameTitle:string = 'Nickname';
	public creditCardNumberTitle:string = "Credit Card"; 
	public nameOnCreditCardTitle:string = "Name on Credit Card"; 
	public expirationMonthTitle:string = "Expiration Month";
	public expirationYearTitle:string = "Expiration Year"; 
	public securityCodeTitle:string = "Security Code"
	
	public processContext:string = 'updateBilling';
	
	public newAccountAddress;
	public newAccountPaymentMethod;
	
	public hideSelectAccountAddress:boolean=false;
	public hideSelectAccountPaymentMethod:boolean=false;
	
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
		this.baseEntity = this.swCustomerAccountPaymentMethodCard.baseEntity;
		this.baseEntityPrimaryID = this.baseEntity[this.$hibachi.getPrimaryIDPropertyNameByEntityName(this.baseEntityName)];
		
		this.accountAddressOptions = this.swCustomerAccountPaymentMethodCard.accountAddressOptions;
		this.accountPaymentMethodOptions = this.swCustomerAccountPaymentMethodCard.accountPaymentMethodOptions;

		this.expirationMonthOptions = this.swCustomerAccountPaymentMethodCard.expirationMonthOptions;
		this.expirationYearOptions = this.swCustomerAccountPaymentMethodCard.expirationYearOptions;
		this.stateCodeOptions = this.swCustomerAccountPaymentMethodCard.stateCodeOptions;


		this.hideSelectAccountAddress = this.accountAddressOptions.length === 0;
		this.showCreateBillingAddress = this.hideSelectAccountAddress;
		
		this.hideSelectAccountPaymentMethod = this.accountPaymentMethodOptions.length === 0;
		this.showCreateAccountPaymentMethod = this.hideSelectAccountPaymentMethod;

		if(!this.hideSelectAccountAddress){
			this.baseEntity.billingAccountAddress = this.accountAddressOptions[0];
		}
		
		if(!this.hideSelectAccountPaymentMethod){
			this.baseEntity.accountPaymentMethod = this.accountPaymentMethodOptions[0];
		}
		
		if(this.swCustomerAccountPaymentMethodCard.accountPaymentMethod != null){
			this.accountPaymentMethod = this.swCustomerAccountPaymentMethodCard.accountPaymentMethod;
		}
		
		this.newAccountPaymentMethod = {
        	expirationMonth: this.expirationMonthOptions[0],
        	expirationYear: this.expirationYearOptions[0]
        };
        
        this.newAccountAddress = {
        	address:{
        		stateCode: this.stateCodeOptions[0]
        	}
	    };
		
	}
	
	public save = () =>{
		var formDataToPost:any = {
			entityID: this.baseEntityPrimaryID,
			entityName: this.baseEntityName,
			context: this.processContext
		};
		
		if(this.showCreateBillingAddress){
			formDataToPost.newAccountAddress = this.newAccountAddress;
		} else {
			formDataToPost.billingAccountAddress = this.baseEntity.billingAccountAddress;
		}
		
		if(this.showCreateAccountPaymentMethod){
			formDataToPost.newAccountPaymentMethod = this.newAccountPaymentMethod;
		} else {
			formDataToPost.accountPaymentMethod = this.baseEntity.accountPaymentMethod;
		}
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		console.log('admin request', adminRequest);
		
		return adminRequest.promise;
	}
}

class SWAccountPaymentMethodModal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountPaymentMethod:"<?",
		accountPaymentMethodOptions: "<?",
		accountAddressOptions: "<?",
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

