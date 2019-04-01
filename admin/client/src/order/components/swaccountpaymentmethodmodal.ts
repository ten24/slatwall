/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountPaymentMethodModalController{

	public accountPaymentMethod;
	
	//Options
	public accountAddressOptions;
	public accountPaymentMethodOptions;
	public countryCodeOptions;
	public expirationMonthOptions;
	public expirationYearOptions;
	public stateCodeOptions;
	
	//Order or Order Template
	public baseEntityName;
	public baseEntity;
	public processObject;
	public baseEntityPrimaryID:string;
	
	public defaultCountryCode:string='US';	
	
	public swCustomerAccountPaymentMethodCard;
	
	public title:string="Edit Billing Information";
	public modalButtonText:string="Add Billing Information";
	public uniqueName:string = 'accountPaymentMethodModal';
	public formName:string = 'accountPaymentMethodModal';
	
	public billingAccountAddressTitle:string = 'Select Billing Address';
	public accountPaymentMethodTitle:string = 'Select Account Payment Method';
	
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
		
		this.accountPaymentMethodTitle = this.rbkeyService.rbKey('entity.' + this.baseEntityName + '.accountPaymentMethod');
		
		this.accountAddressOptions = this.swCustomerAccountPaymentMethodCard.accountAddressOptions;
		this.accountPaymentMethodOptions = this.swCustomerAccountPaymentMethodCard.accountPaymentMethodOptions;

		this.countryCodeOptions = this.swCustomerAccountPaymentMethodCard.countryCodeOptions;
		this.expirationMonthOptions = this.swCustomerAccountPaymentMethodCard.expirationMonthOptions;
		this.expirationYearOptions = this.swCustomerAccountPaymentMethodCard.expirationYearOptions;
		this.stateCodeOptions = this.swCustomerAccountPaymentMethodCard.stateCodeOptions;


		this.hideSelectAccountAddress = this.accountAddressOptions.length === 0;
		this.showCreateBillingAddress = this.hideSelectAccountAddress;
		
		this.hideSelectAccountPaymentMethod = this.accountPaymentMethodOptions.length === 0;
		this.showCreateAccountPaymentMethod = this.hideSelectAccountPaymentMethod;

		if(!this.hideSelectAccountAddress  && this.swCustomerAccountPaymentMethodCard.billingAccountAddress == null){
			this.baseEntity.billingAccountAddress = this.accountAddressOptions[0];
		} else {
			for(var i=0; i<this.accountAddressOptions.length; i++){
				var option = this.accountAddressOptions[i];
				if(option['value'] == this.swCustomerAccountPaymentMethodCard.billingAccountAddress.accountAddressID){
					this.baseEntity.billingAccountAddress = option;
					break;
				}
			}
		}
		
		if(!this.hideSelectAccountPaymentMethod  && this.swCustomerAccountPaymentMethodCard.accountPaymentMethod == null){
			this.baseEntity.accountPaymentMethod = this.accountPaymentMethodOptions[0];
		} else {
			for(var i=0; i<this.accountPaymentMethodOptions.length; i++){
				var option = this.accountPaymentMethodOptions[i];
                if(option['value'] == this.swCustomerAccountPaymentMethodCard.accountPaymentMethod.accountPaymentMethodID){
                	this.baseEntity.accountPaymentMethod = option;
                	break;
                }
            }
		}
		
		for(var i=0; i<this.countryCodeOptions.length; i++){
			
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
        		countryCode: this.countryCodeOptions[0],
        		stateCode: this.stateCodeOptions[0]
        	}
	    };
		
	}
	
	public save = () =>{
		var formDataToPost:any = {
			entityID: this.baseEntityPrimaryID,
			entityName: this.baseEntityName,
			context: this.processContext,
			propertyIdentifiersList: 'billingAccountAddress,accountPaymentMethod'
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
	    modalButtonText:"@?",
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

