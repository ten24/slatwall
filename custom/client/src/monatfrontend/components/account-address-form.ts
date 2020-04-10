import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';


class AccountAddressFormController {
	public close;
	
	//callback
	public onSubmitCallback;
	public onSuccessCallback;
	public onFailureCallback;
	
	public accountAddress= {'countryCode': hibachiConfig.countryCode }; 
	public stateCodeOptions: Array<any>;
	
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
    	this.makeTranslations();
 
    	this.monatService.getStateCodeOptionsByCountryCode()
    	.then( (options) => this.stateCodeOptions = options )
    	//todo address-form-field-options
    	.catch( (error) => {
		    console.error(error);
		})
		.finally(()=>{
			this.loading = false;   
		});
    	
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['addNewAddress'] = this.rbkeyService.rbKey('frontend.newAddress.addNewAddress');
    	this.translations['address_nickName'] = this.rbkeyService.rbKey('frontend.newAddress.nickName');
    	this.translations['address_name'] = this.rbkeyService.rbKey('frontend.newAddress.name');
    	this.translations['address_address'] = this.rbkeyService.rbKey('frontend.newAddress.address');
    	this.translations['address_address2'] = this.rbkeyService.rbKey('frontend.newAddress.address2');
    	this.translations['address_country'] = this.rbkeyService.rbKey('frontend.newAddress.country');
    	this.translations['address_state'] = this.rbkeyService.rbKey('frontend.newAddress.state');
    	this.translations['address_selectYourState'] = this.rbkeyService.rbKey('frontend.newAddress.selectYourState');
    	this.translations['address_city'] = this.rbkeyService.rbKey('frontend.newAddress.city');
    	this.translations['address_zipCode'] = this.rbkeyService.rbKey('frontend.newAddress.zipCode');
    	this.translations['select_country'] = this.rbkeyService.rbKey('frontend.newAddress.selectCountry');

    }
    
    public onFormSubmit() {
    	let payload = {};
    	this.loading=true;
    	
		//if callback returned true ==> the input is handeled; won't make API call
		if(this.onSubmitCallback?.(this.accountAddress) === true) return this.remove();
		
        this.monatService.addEditAccountAddress(this.accountAddress)
        .then( (response) => {
        	if(response?.accountAddress) {
           	    //if caller returned true ==> success-handeled;
           		if(this.onSuccessCallback?.(response.accountAddress) === true) return this.remove();
           		this.observerService.notify("addAccountAddressSaveSuccess", response.accountAddress);
           		this.remove();
        	} else {
        		throw(response);
        	}
        }) 
        .catch( (error) => {
        	//if caller returned true ==> error-handeled;
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
	
	public bindToController = {
		close: "=", //injected via modal-service
		accountAddress: '<?',
	    
	    // we can tap into this to get the form-data, before the api-call, 
	    // if the callback-function returns true, it won't make the API call;
	    onSubmitCallback:'=?', 
	    
	    // can remove these..., things will be much simpler
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

