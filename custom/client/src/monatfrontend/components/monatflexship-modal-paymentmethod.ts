
class MonatFlexshipPaymentMethodModalController {
    public orderTemplate; 
    public accountPaymentMethods: Array<any>;
    public accountAddresses: Array<any>;
    public expirationMonthOptions: Array<any>;
	public expirationYearOptions: Array<any>;
	public close; // injected from angularModalService

    
    public existingBillingAccountAddress; 
	public selectedBillingAccountAddress = { accountAddressID : 'new' }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	public existingAccountPaymentMethod; 
	public selectedAccountPaymentMethod = { accountPaymentMethodID : 'new' }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	
	public newAccountAddress = {};
	public newAddress = {'countryCode':'US'}; // hard-coded default
    public countryCodeBySite:any;
	public newAccountPaymentMethod = {};
	public loading : boolean = false;

	//@ngInject
    constructor(
    	public orderTemplateService, 
    	public observerService, 
    	public rbkeyService, 
    	public monatAlertService,
    	private monatService
    ) {
    }
    
    public $onInit = () => {
    	this.loading = true;
    	
    	this.makeTranslations();
    	this.newAddress['countryCode']=this.countryCodeBySite;
    	
    	/**
    	 * Find and set old billing-address if any
    	*/ 
    	this.existingBillingAccountAddress = this.accountAddresses.find( item => {
    		return item.accountAddressID === this.orderTemplate.billingAccountAddress_accountAddressID;
    	});
    	if(!!this.existingBillingAccountAddress && !!this.existingBillingAccountAddress.accountAddressID){
	    	this.setSelectedBillingAccountAddressID(this.existingBillingAccountAddress.accountAddressID);
    	}
    	
    	/**
    	 * Find and set old payment-method if any
    	*/
    	this.existingAccountPaymentMethod = this.accountPaymentMethods.find( item => {
    		return item.accountPaymentMethodID === this.orderTemplate.accountPaymentMethod_accountPaymentMethodID; 
    	});
    	if(!!this.existingAccountPaymentMethod && !!this.existingAccountPaymentMethod.accountPaymentMethodID){
	    	this.setSelectedAccountPaymentMethodID(this.existingAccountPaymentMethod.accountPaymentMethodID);
    	}
    	
    	this.monatService.getOptions({'expirationMonthOptions':false, 'expirationYearOptions': false})
    	.then( (options) => {
    		this.expirationMonthOptions = options.expirationMonthOptions;
    		this.expirationYearOptions = options.expirationYearOptions;
    	})
    	.catch( (e) => console.log(e) )
    	.finally( () => this.loading=false);
    	
    }
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['billingAddress'] = this.rbkeyService.rbKey('frontend.paymentMethodModal.billingAddress');
    	this.translations['addNewBillingAddress'] = this.rbkeyService.rbKey('frontend.paymentMethodModal.addNewBillingAddress');
    	this.translations['newBillingAddress'] = this.rbkeyService.rbKey('frontend.paymentMethodModal.newBillingAddress');
    	this.translations['paymentMethod'] = this.rbkeyService.rbKey('frontend.paymentMethodModal.paymentMethod');
    	this.translations['addNewCreditCard'] = this.rbkeyService.rbKey('frontend.paymentMethodModal.addNewCreditCard');
    	this.translations['newCreditCard'] = this.rbkeyService.rbKey('frontend.newCreditCard');
    	this.translations['newCreditCard_nickName'] = this.rbkeyService.rbKey('frontend.newCreditCard.nickName');
    	this.translations['newCreditCard_creditCardNumber'] = this.rbkeyService.rbKey('frontend.newCreditCard.creditCardNumber');
    	this.translations['newCreditCard_nameOnCard'] = this.rbkeyService.rbKey('frontend.newCreditCard.nameOnCard');
    	this.translations['newCreditCard_expirationMonth'] = this.rbkeyService.rbKey('frontend.newCreditCard.expirationMonth');
    	this.translations['newCreditCard_expirationYear'] = this.rbkeyService.rbKey('frontend.newCreditCard.expirationYear');
    	this.translations['newCreditCard_securityCode'] = this.rbkeyService.rbKey('frontend.newCreditCard.securityCode');

    	this.translations['newAddress_nickName'] = this.rbkeyService.rbKey('frontend.newAddress.nickName');
    	this.translations['newAddress_name'] = this.rbkeyService.rbKey('frontend.newAddress.name');
    	this.translations['newAddress_address'] = this.rbkeyService.rbKey('frontend.newAddress.address');
    	this.translations['newAddress_address2'] = this.rbkeyService.rbKey('frontend.newAddress.address2');
    	this.translations['newAddress_country'] = this.rbkeyService.rbKey('frontend.newAddress.country');
    	this.translations['newAddress_state'] = this.rbkeyService.rbKey('frontend.newAddress.state');
    	this.translations['newAddress_selectYourState'] = this.rbkeyService.rbKey('frontend.newAddress.selectYourState');
    	this.translations['newAddress_city'] = this.rbkeyService.rbKey('frontend.newAddress.city');
    	this.translations['newAddress_zipCode'] = this.rbkeyService.rbKey('frontend.newAddress.zipCode');

    }
    
    public setSelectedBillingAccountAddressID(accountAddressID:any = 'new') {
    	this.selectedBillingAccountAddress.accountAddressID = accountAddressID;
    }
    
    public setSelectedAccountPaymentMethodID(accountPaymentMethodID:any = 'new') {
    	this.selectedAccountPaymentMethod.accountPaymentMethodID = accountPaymentMethodID;
    }
    
    public updateBilling() {
        this.loading = true;
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;

    	if(this.selectedBillingAccountAddress.accountAddressID !== 'new') {
    		 payload['billingAccountAddress.value'] = this.selectedBillingAccountAddress.accountAddressID;
    	} else {
    		this.newAccountAddress['address'] = this.newAddress;
    		payload['newAccountAddress'] = this.newAccountAddress;
    	}
    	
    	if(this.selectedAccountPaymentMethod.accountPaymentMethodID !== 'new') {
    		 payload['accountPaymentMethod.value'] = this.selectedAccountPaymentMethod.accountPaymentMethodID;
    	} else {
    		payload['newAccountPaymentMethod'] = this.newAccountPaymentMethod;
    	}
 
		//flattning it for hibachi
    	payload = this.orderTemplateService.getFlattenObject(payload);

    	// make api request
        this.orderTemplateService.updateBilling(payload)
        .then( (response) => {
        	
			if(response.orderTemplate) {
			    this.orderTemplate = response.orderTemplate;
			
			    if(response.newAccountAddress) {
					this.observerService.notify("newAccountAddressAdded",response.newAccountAddress);
					this.accountAddresses.push(response.newAccountAddress);
			    }
			    
			    if(response.newAccountPaymentMethod) {
					this.observerService.notify("newAccountPaymentMethodAdded",response.newAccountPaymentMethod);
					this.accountPaymentMethods.push(response.newAccountPaymentMethod);
			    }
			    
			    this.setSelectedBillingAccountAddressID(this.orderTemplate.billingAccountAddress_accountAddressID);
			    this.setSelectedAccountPaymentMethodID(this.orderTemplate.accountPaymentMethod_accountPaymentMethodID);
			    
			    this.monatAlertService.success("Your flexship has been updated successfully");
			
			    this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
			    this.closeModal();
			} else {
			   	throw(response); 
			}
        })
        .catch( (error) => {
	        this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null);
    };

}

class MonatFlexshipPaymentMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    accountPaymentMethods:'<',
 	    stateCodeOptions:'<',
	    accountAddresses:'<',
	    orderTemplate:'<',
		countryCodeBySite:'<',
		close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipPaymentMethodModalController;
	public controllerAs="monatFlexshipPaymentMethodModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipPaymentMethodModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-paymentmethod.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipPaymentMethodModal
};

