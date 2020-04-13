import { FlexshipSteps } from '@Monat/components/flexshipFlow/flexshipFlow';
import { FlexshipCheckoutState, FlexshipCheckoutStore } from '@Monat/states/flexship-checkout-store';

import { MonatService } from '@Monat/services/monatservice';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';

import { PayPalService } from '@Monat/services/paypalservice';

class FlexshipCheckoutStepController {
	//states
	public currentState = {} as FlexshipCheckoutState;
	private stateListeners =[];

	private newAddressFormRef;
	
	
	public expirationMonthOptions;
	public expirationYearOptions;
	public newAccountPaymentMethod = {
		
	};

	//@ngInject
	constructor(
		private ModalService,
		private monatService: MonatService,
		private payPalService: PayPalService,
		private monatAlertService: MonatAlertService,
		private orderTemplateService: OrderTemplateService,
		private flexshipCheckoutStore: FlexshipCheckoutStore,
	) {}

	public $onInit = () => {
		this.setupStateChangeListeners();
		
		//TODO: refactor into FlexshipCheckoutStore, and make these lazy
		this.monatService.getOptions({'expirationMonthOptions':false, 'expirationYearOptions': false}) 
    	.then( (options) => {
    		this.expirationMonthOptions = options.expirationMonthOptions;
    		this.expirationYearOptions = options.expirationYearOptions;
    	});
	};
	
	
	public configurePayPal = () => {
		this.payPalService.configPayPal();
	};

	public addNewPaymentMethod = () => {
		
		let payload = {
			'orderTemplateID': this.currentState.flexship.ordertemplateID,
			'billingAccountAddress.value': this.currentState.selectedBillingAddressID,
			'newAccountPaymentMethod': this.newAccountPaymentMethod
		};
		
		//TODO: Extract newPaymentMethod into seperate-API
		this.orderTemplateService.updateBilling( 
			this.orderTemplateService.getFlattenObject(payload)
		)
        .then( (response) => {
        	
	        if(response.newAccountPaymentMethod) {
				this.currentState.accountPaymentMethods.push(response.newAccountPaymentMethod);
				this.flexshipCheckoutStore.dispatch('SET_PAYMENT_METHODS', {
					accountPaymentMethods : this.currentState.accountPaymentMethods
				});
	    		this.setSelectedPaymentMethodID(response.newAccountPaymentMethod.accountPaymentMethodID);
	        } else {
	        	throw response;
	        }
	        
        })
        .catch( (error) => {
	        this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.newAccountPaymentMethod = false;
        });
		
	}
	
	public cancelAddNewPayment = () =>{
		// doing this will reopen the form if there's no payment-methods
		// otherwise will fallback to either previously-selected, or best available 
		this.setSelectedPaymentMethodID(this.flexshipCheckoutStore.selectAPaymentMethod(this.currentState));
	}

	// *****************. States  .***********************//
	
	public setSelectedPaymentProvider(selectedPaymentProvider){
		
		if(selectedPaymentProvider === this.currentState.selectedPaymentProvider) return;
	
		this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_PAYMENT_PROVIDER', {
			'selectedPaymentProvider': selectedPaymentProvider	
		});
	}
	
	public setSelectedPaymentMethodID(selectedPaymentMethodID?){
		
		this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_PAYMENT_METHOD_ID', (state) => {
			return this.flexshipCheckoutStore.setSelectedPaymentMethodIDReducer( state, selectedPaymentMethodID);
		});
	}

	public toggleBillingSameAsShipping(){
		this.flexshipCheckoutStore.dispatch( 'TOGGLE_BILLING_SAME_AS_SHIPPING', (state) => {
			return this.flexshipCheckoutStore.toggleBillingSameAsShippingReducer( state, !this.currentState.billingSameAsShipping);
		});
	}
	
	public setSelectedBillingAddressID(selectedBillingAddressID?){
		
		this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_BILLING_ADDRESS_ID', (state) => {
			return this.flexshipCheckoutStore.setSelectedBillingAddressIDReducer( state, selectedBillingAddressID);
		});
	}

	private onNewStateReceived = (state: FlexshipCheckoutState) => {
		this.currentState = state;
		this.currentState.showNewBillingAddressForm ? this.showNewAddressForm() : this.hideNewAddressForm();
		console.log("checkout-step, on-new-state", this.currentState);
	}
	
	private setupStateChangeListeners(){
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('*', this.onNewStateReceived)
		);
	}
	
	public $onDestroy= () => {
		//to clear all of the listenets 
		this.stateListeners.map( hook => hook.destroy());
	}

	
	// *****************. new Address Form  .***********************//
	
    public onAddNewAccountAddressSuccess = (newAccountAddress) => {
		
		if(newAccountAddress) {
			this.currentState.accountAddresses.push(newAccountAddress);
			this.flexshipCheckoutStore.dispatch('SET_ACCOUNT_ADDRESSES', {
				accountAddresses : this.currentState.accountAddresses
			});
    		this.setSelectedBillingAddressID(newAccountAddress.accountAddressID);
        }
    	console.log("add new billing-account adress, on success", newAccountAddress);
    	return true;
    };
    
    public onAddNewAccountAddressFailure = (error) => {
        console.log("add billing-account-adress, on failure", error);
    };
    
    public showNewAddressForm = () => {
        
        if(this.newAddressFormRef) {
            return this.newAddressFormRef.show();
        }
        
		let bindings = {
			onSuccessCallback: this.onAddNewAccountAddressSuccess,
			onFailureCallback: this.onAddNewAccountAddressFailure,
			formHtmlID: Math.random().toString(36).replace('0.', 'new_billing_address_form' || '')
		};
		
		this.ModalService.showModal({
			component: 'accountAddressForm',
			appendElement: '#new-billing-account-address-form', //can be any vlid selector
			bindings: bindings
		})
		.then( (component) => {
			component.close.then( () => {
				this.newAddressFormRef = undefined;
				
				// doing this will reopen the form if there's no billing-address
				// otherwise will fallback to either previously-selected, or best available 
				this.setSelectedBillingAddressID(this.flexshipCheckoutStore.selectABillingAddress(this.currentState));
				
			});
			this.newAddressFormRef = component.element;
		})
		.catch((error) => {
			console.error('unable to open new-billing-account-address-form :', error);
		});
	};
	
	private hideNewAddressForm(){
	    this.newAddressFormRef?.hide();
	}
	
	
	// *****************. Helpers  .***********************//
	public formatAddress = (accountAddress):string =>{
        return this.monatService.formatAccountAddress(accountAddress);
    }

	
}

export class FlexshipCheckoutStep {
	public restrict = 'E';
	public scope = {};
	public templateUrl: string;
	public controller = FlexshipCheckoutStepController;
	public controllerAs = 'flexshipCheckout';
	public bindToController = {};

	constructor(private basePath) {
		this.templateUrl = basePath + '/monatfrontend/components/flexshipFlow/checkout-step.html';
	}

	public static Factory() {
		//@ngInject
		return (monatFrontendBasePath) => {
			return new FlexshipCheckoutStep(monatFrontendBasePath);
		};
	}
}
