import { MonatService, IAddressFormOptions, IOption } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';

class AccountAddressFormController {
	public close;
	
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
    	this.translations['address_name'] = this.rbkeyService.rbKey('frontend.newAddress.name');
    	this.translations['address_nickName'] = this.rbkeyService.rbKey('frontend.newAddress.nickName');
    	this.translations['address_country'] = this.rbkeyService.rbKey('frontend.newAddress.country');
    	this.translations['address_emailAddress'] = this.rbkeyService.rbKey('frontend.newAddress.emailAddress');
    	this.translations['address_phoneNumber'] = this.rbkeyService.rbKey('frontend.newAddress.phoneNumber');
    }
    
    public onFormSubmit() {
    	let payload = {};
    	this.loading=true;
    	
		//if callback returned true ==> the input is handeled; won't make API call
		if(this.onSubmitCallback?.(this.accountAddress) === true) return this.remove();
		
        this.monatService.addEditAccountAddress(this.accountAddress)
        .then( (response) => {
        	if(response?.newAccountAddress) {
           	    //if callback return true ==> success-handeled, will close;
           		if(this.onSuccessCallback?.(response.newAccountAddress) === true) return this.remove();
           		//beware of the event-name ambiguity, the core-event doesn't pass any data;
           		this.observerService.notify("newAccountAddressSaveSuccess", response.newAccountAddress);
           		this.remove();
        	} else {
        		throw(response);
        	}
        }) 
        .catch( (error) => {
        	//if callback return true ==> error-handeled, will close;
        	if(this.onFailureCallback?.(error) === true ) return this.remove();
        	this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally(() => {
        	this.loading = false;
        }); 
    }
	
	public remove(){
		console.log('removing account-address-form');
		this.loading = false;
		this.close?.();
		//todo: close
	}
}

class AccountAddressForm {

	public restrict:"E";
	public templateUrl:string;
	public scope = {};
	
	public bindToController = {
		close: "=", //injected via modal-service
		accountAddress: '<?',
	    
	    // we can tap into this to get/update the form-data, before the api-call, 
	    onSubmitCallback:'=?', 
	    
	    onSuccessCallback:'=?',
	    onFailureCallback:'=?'
	};
	public controller=AccountAddressFormController;
	public controllerAs="accountAddressCtrl";

	public static Factory(){
        //@ngInject
        return ( monatFrontendBasePath ) => {
            return new AccountAddressForm( monatFrontendBasePath);
        }; 
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/account-address-form.html";
	}

}

export {
	AccountAddressForm
};

