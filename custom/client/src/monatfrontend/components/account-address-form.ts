import { MonatService, IOption } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';

class AccountAddressFormController {
	public close;
	public formHtmlId;
	
	//callback
	public onSubmitCallback;
	public onSuccessCallback;
	public onFailureCallback;
	
	public stateCodeOptions: Array<IOption>;
	public addressFormOptions: IAddressFormOptions;
	public accountAddress= { 'countryCode': hibachiConfig.countryCode }; 
	public loading: boolean = false;

	//@ngInject
    constructor(
    	public rbkeyService, 
    	public observerService, 
    	public monatAlertService: MonatAlertService,
    	private monatService: MonatService
    ) {}
    
    public $onInit = () => {
    	
    	if(!this.formHtmlId) this.formHtmlId = Math.random().toString(36).replace('0.', 'newaccountaddressform' || '');
    	
    	this.loading=true;
    	this.monatService.getStateCodeOptionsByCountryCode()
    	.then( (options) => { 
    		this.stateCodeOptions = options.stateCodeOptions;
    		this.addressFormOptions = options.addressOptions;
    	})
    	.catch( (error) => console.error(error))
		.finally( ()=> this.loading = false );
		
    	this.makeTranslations();
    };
    
    public translations = {};
    private makeTranslations = () => {
    	this.translations['address_first_name'] = this.rbkeyService.rbKey('frontend.newAddress.firstName');
    	this.translations['address_last_name'] = this.rbkeyService.rbKey('frontend.newAddress.lastName');
    	this.translations['address_nickName'] = this.rbkeyService.rbKey('frontend.newAddress.nickName');
    	this.translations['address_country'] = this.rbkeyService.rbKey('frontend.newAddress.country');
    	this.translations['address_emailAddress'] = this.rbkeyService.rbKey('frontend.newAddress.emailAddress');
    	this.translations['address_phoneNumber'] = this.rbkeyService.rbKey('frontend.newAddress.phoneNumber');
    }
    
    public onFormSubmit() {
    	let payload = {};
    	this.loading=true;
    	
		//if callback returned true ==> the input is handeled; won't make API call
		if(this.onSubmitCallback?.(this.accountAddress) === true) return this.cancel();
		
        this.monatService.addEditAccountAddress(this.accountAddress)
        .then( (response) => {
        	if(response?.newAccountAddress) {
           	    //if callback return true ==> success-handeled, will close;
           		if(this.onSuccessCallback?.(response.newAccountAddress) === true) return this.cancel();
           		//beware of the event-name ambiguity, the core-event doesn't pass any data;
           		this.observerService.notify("newAccountAddressSaveSuccess", response.newAccountAddress);
           		this.cancel();
        	} else {
        		throw(response);
        	}
        }) 
        .catch( (error) => {
        	//if callback return true ==> error-handeled, will close;
        	if(this.onFailureCallback?.(error) === true ) return this.cancel();
        	this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally(() => {
        	this.loading = false;
        }); 
    }
	
	public cancel(){
		console.log('removing account-address-form');
		this.loading = false;
		this.close?.();
	}
}

class AccountAddressForm {

	public restrict:"E";
	public scope = {};
	
	public bindToController = {
		close: "=", //injected via modal-service
		formHtmlId:"<?",
		accountAddress: '<?',
	    // we can tap into this to get/update the form-data, before the api-call, 
	    onSubmitCallback:'=?', 
	    onSuccessCallback:'=?',
	    onFailureCallback:'=?'
	};
	
	public controller=AccountAddressFormController;
	public controllerAs="accountAddressCtrl";

	public template = require('./account-address-form.html');

	public static Factory() {
		return () => new this();
	}

}

export {
	AccountAddressForm, IAddressFormOptions
};

type IAddressFormOptions = {
	
	streetAddressLabel:string;
	streetAddressShowFlag:boolean;
	streetAddressRequiredFlag:boolean;
	
	street2AddressLabel:string;
	street2AddressShowFlag:boolean;
	street2AddressRequiredFlag:boolean;
	
	cityLabel:string;
	cityShowFlag:boolean;
	cityRequiredFlag:boolean;
	
    postalCodeLabel:string;
	postalCodeShowFlag:boolean;
	postalCodeRequiredFlag:boolean;
       
    stateCodeLabel:string;
	stateCodeShowFlag:boolean;
	stateCodeRequiredFlag:boolean;
    
	localityLabel:string;
	localityShowFlag:boolean;
	localityRequiredFlag:boolean;
}


