import { MonatService } from '@Monat/services/monatservice';

class MonatFlexshipPaymentMethodModalController {
    public orderTemplate; 
    


	public close; // injected from angularModalService

    public accountPaymentMethods: Array<any>;
    public expirationMonthOptions: Array<any>;
	public expirationYearOptions: Array<any>;
    public accountAddresses: Array<any>;
	public stateCodeOptions: Array<any>;
    
    public existingBillingAccountAddress; 
	public selectedBillingAccountAddress = { accountAddressID : undefined }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	public existingAccountPaymentMethod; 
	public selectedAccountPaymentMethod = { accountPaymentMethodID : undefined }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	
	public newAccountAddress = {};
	public newAddress = {'countryCode': hibachiConfig.countryCode }; 
	public newAccountPaymentMethod = {};
	public loading : boolean = false;

	//@ngInject
    constructor(
    	public orderTemplateService, 
    	public observerService, 
    	public rbkeyService, 
    	public monatAlertService,
    	private monatService: MonatService
    ) {
    }
    
    public $onInit = () => {
    	this.loading = true;
    	
    	this.makeTranslations();
    	
    	this.monatService.getStateCodeOptionsByCountryCode()
    	.then( (options) => this.stateCodeOptions = options )
    	.then( () => this.monatService.getOptions({'expirationMonthOptions':false, 'expirationYearOptions': false}) )
    	.then( (options) => {
    		this.expirationMonthOptions = options.expirationMonthOptions;
    		this.expirationYearOptions = options.expirationYearOptions;
    	})
    	.then( () => this.monatService.getAccountAddresses() )
    	.then( (accountAddresses) => {
    		this.accountAddresses = accountAddresses;
    		this.existingBillingAccountAddress = this.accountAddresses.find( item => {
	    		return item.accountAddressID === this.orderTemplate.billingAccountAddress_accountAddressID;
	    	});
		    this.setSelectedBillingAccountAddressID(this?.existingBillingAccountAddress?.accountAddressID);
    	})
    	.then( () => this.monatService.getAccountPaymentMethods() )
    	.then( (accountPaymentMethods) => {
    		this.accountPaymentMethods = accountPaymentMethods;
    		this.existingAccountPaymentMethod = this.accountPaymentMethods.find( item => {
	    		return item.accountPaymentMethodID === this.orderTemplate.accountPaymentMethod_accountPaymentMethodID; 
	    	});
		    this.setSelectedAccountPaymentMethodID(this?.existingAccountPaymentMethod?.accountPaymentMethodID);
    	})
    	.catch( (error) => {
		    console.error(error);
		})
		.finally(()=>{
			this.loading = false;   
		});
    	
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
			    
            	this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.updateSucceccfull'));
			
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

	public restrict = 'E';
	public templateUrl:string;
	
	public bindToController = {
	    orderTemplate:'<',
		close:'=' //injected by angularModalService
	};

	public controller=MonatFlexshipPaymentMethodModalController;
	public controllerAs="monatFlexshipPaymentMethodModal";

    public static Factory(){
		//@ngInject
        return ( monatFrontendBasePath ) => {
        	return new MonatFlexshipPaymentMethodModal(monatFrontendBasePath);
        };
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexship/modals/paymentmethod.html";
	}
}

export {
	MonatFlexshipPaymentMethodModal
};

