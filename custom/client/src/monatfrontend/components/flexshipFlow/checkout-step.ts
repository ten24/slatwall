import { FlexshipSteps } from '@Monat/components/flexshipFlow/flexshipFlow';
import { FlexshipCheckoutState, FlexshipCheckoutStore } from '@Monat/states/flexship-checkout-store';

import { MonatService } from '@Monat/services/monatservice';
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
		private orderTemplateService,
		private monatAlertService,
		private monatService: MonatService,
		private payPalService: PayPalService,
		private ModalService,
		private flexshipCheckoutStore: FlexshipCheckoutStore,
	) {}

	public $onInit = () => {
		this.setupStateChangeListeners();
		
		this.flexshipCheckoutStore.dispatch( 'TOGGLE_LOADING', { 'loading': true });
		
		this.monatService.getAccountPaymentMethods()    	
		.then( data => {
			this.flexshipCheckoutStore.dispatch( 'SET_PAYMENT_METHODS', {
				'accountPaymentMethods': data.accountPaymentMethods,
				'primaryPaymentMethodID': data.primaryPaymentMethodID
			})
			this.selectAPaymentMethod();
		})
		.then( () => this.monatService.getOptions({'expirationMonthOptions':false, 'expirationYearOptions': false}) )
    	.then( (options) => {
    		this.expirationMonthOptions = options.expirationMonthOptions;
    		this.expirationYearOptions = options.expirationYearOptions;
    	});
	};
	
	
	public setSelectedPaymentProvider(selectedPaymentProvider){
		if(!this.currentState.selectedPaymentProvider || this.currentState.selectedPaymentProvider != selectedPaymentProvider ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_PAYMENT_PROVIDER', {
				'selectedPaymentProvider': selectedPaymentProvider	
			});
		}
	}
	
	public configurePayPal = () => {
		this.payPalService.configPayPal();
	};
	

    private selectAPaymentMethod(selectedPaymentMethodID?) {
		 
		if(!selectedPaymentMethodID ){
			selectedPaymentMethodID = this.currentState?.flexship?.accountPaymentMethod_accountPaymentMethodID?.trim();
		}
		if(!selectedPaymentMethodID) { 
			selectedPaymentMethodID = this.currentState?.primaryPaymentMethodID?.trim() 
		}
    	if( !selectedPaymentMethodID  && this.currentState?.accountPaymentMethods?.length) {
    		selectedPaymentMethodID = this.currentState.accountPaymentMethods.find( () => true )?.accountPaymentMethodID?.trim();
    	}
    	
    	this.setSelectedPaymentMethodID(selectedPaymentMethodID);
	}

	public setSelectedPaymentMethodID(selectedPaymentMethodID?){
		
		if( selectedPaymentMethodID && this.currentState.selectedPaymentMethodID != selectedPaymentMethodID  ){
			if(selectedPaymentMethodID === 'new') selectedPaymentMethodID = undefined;
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_SHIPPING_ADDRESS_ID', {
				'selectedPaymentMethodID': selectedPaymentMethodID	
			});
		}
		
		if(!selectedPaymentMethodID){
			this.flexshipCheckoutStore.dispatch( 'TOGGLE_NEW_PAYMENT_METHOD_FORM', {
				showNewPaymentMethodForm: true
			});
		}
		else if( selectedPaymentMethodID && this.currentState.showNewPaymentMethodForm){
			this.flexshipCheckoutStore.dispatch( 'TOGGLE_NEW_PAYMENT_METHOD_FORM', {
				showNewPaymentMethodForm: false
			});
		}
	}

	public addNewPaymentMethod = () => {
		
		let payload = {
			'orderTemplateID': this.currentState.flexship.ordertemplateID,
			'billingAccountAddress.value': this.currentState.selectedBillingAddressID,
			'newAccountPaymentMethod': this.newAccountPaymentMethod
		};
		
		this.orderTemplateService.updateBilling(payload)
        .then( (response) => {
        	
        })
        .catch( (error) => {
	        this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.newAccountPaymentMethod = false;
        });
		
	}


	public toggleBillingSameAsShipping(){
		this.flexshipCheckoutStore.dispatch( 'TOGGLE_BILLING_SAME_AS_SHIPPING', {
			billingSameAsShipping : !this.currentState?.billingSameAsShipping	
		});
		this.selectABillingAddress();
	}
	
    private selectABillingAddress(selectedBillingAddressID?) {
		 
		if(!selectedBillingAddressID && this.currentState?.billingSameAsShipping) { 
    		selectedBillingAddressID = this.currentState?.selectedShippingAddressID?.trim();
    	}
		if(!selectedBillingAddressID ){
			selectedBillingAddressID = this.currentState?.flexship?.billingAccountAddress_accountAddressID?.trim();
		}
    	if(!selectedBillingAddressID) { 
    		this.currentState?.primaryBillingAddressID?.trim()
    	}
		if(!selectedBillingAddressID) { 
			this.currentState?.primaryAccountAddressID?.trim() 
		}
    	if( !selectedBillingAddressID  && this.currentState?.accountAddresses?.length) {
    		//select the first available
    		selectedBillingAddressID = this.currentState.accountAddresses.find( () => true )?.accountAddressID?.trim();
    	}
    	
    	this.setSelectedBillingAddressID(selectedBillingAddressID);
	}
	
	public setSelectedBillingAddressID(selectedBillingAddressID?){
		
		if( selectedBillingAddressID && this.currentState.selectedBillingAddressID != selectedBillingAddressID  ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_BILLING_ADDRESS_ID', {
				'selectedBillingAddressID': selectedBillingAddressID	
			});
		}
		
		if(!selectedBillingAddressID){
			this.flexshipCheckoutStore.dispatch( 'TOGGLE_NEW_BILLING_ADDRESS_FORM', {
				showNewBillingAddressForm: true
			});
			this.showNewAddressForm();
		}
		else if( selectedBillingAddressID && this.currentState.showNewBillingAddressForm) {
			this.flexshipCheckoutStore.dispatch( 'TOGGLE_NEW_BILLING_ADDRESS_FORM', {
				showNewBillingAddressForm: false
			});
			this.hideNewAddressForm();
		}
		
		if(!this.currentState.selectedBillingAddressID || this.currentState.selectedBillingAddressID != selectedBillingAddressID ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_BILLING_ADDRESS_ID', {
				'selectedBillingAddressID': selectedBillingAddressID	
			});
		}
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
    
    public showNewAddressForm = (accountAddress?) => {
        
        if(this.newAddressFormRef) {
            return this.newAddressFormRef.show();
        }
        
		let bindings = {
			onSuccessCallback: this.onAddNewAccountAddressSuccess,
			onFailureCallback: this.onAddNewAccountAddressFailure,
		};
		
		if(accountAddress){
		    bindings['accountAddress'] = accountAddress;
		}
		
		this.ModalService.showModal({
			component: 'accountAddressForm',
			appendElement: '#billing-new-account-address-form', //can be any vlid selector
			bindings: bindings
		})
		.then( (component) => {
			component.close.then( () => {
				this.newAddressFormRef = undefined;
				this.selectABillingAddress(this.currentState.selectedShippingAddressID);
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



		
	private onNewStateReceived = (state: FlexshipCheckoutState) => {
		this.currentState = state;
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
