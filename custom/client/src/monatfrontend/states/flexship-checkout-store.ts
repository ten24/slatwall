import { NgStore } from './angularjs-store';
import { 
    AccountAddress, 
    AccountPaymentMethod,
    OrderTemplate, 
    OrderTemplateItem, 
    Option
} from '@Monat/models';


// keep is Simple And Stupid, remember it's not a magic-bullet
export class FlexshipCheckoutState {
	
	primaryAccountAddressID:   string   =  null;
	primaryShippingAddressID:  string   =  null;
	primaryBillingAddressID:   string   =  null;
	primaryPaymentMethodID:    string   =  null;
	
	
	loading: boolean  = true;
	flexship: OrderTemplate     = null; 
	
	// will get updated every-time we add new-address
	accountAddresses:            Array<AccountAddress>  = null; 
	shippingMethodOptions:       Array<Option>          = null;
	selectedShippingAddressID:   string                 = null;
	selectedShippingMethodID:    string                 = null;
	showNewShippingAddressForm:  boolean                = false;
	
	
	accountPaymentMethods:       Array<AccountPaymentMethod>  = null; 
	selectedPaymentProvider:     "creditCard" | "paypal"      = "creditCard";
	selectedPaymentMethodID:     string 					  =  null;
	selectedBillingAddressID:    string 					  =  null;
	billingSameAsShipping:       boolean					  =  true;
	showNewPaymentMethodForm:    boolean					  =  false;
	showNewBillingAddressForm:   boolean					  =  false;
	
	
	public getSelectedShippingAddress() : AccountAddress{
		return this.accountAddresses?.find(a => a.accountAddressID === this.selectedShippingAddressID);
	}
	
	public getSelectedBillingAddress() : AccountAddress {
		return this.accountAddresses?.find(a => a.accountAddressID === this.selectedBillingAddressID);
	}

	public getSelectedPaymentMethod() : AccountPaymentMethod {
		return this.accountPaymentMethods?.find(p => p.accountPaymentMethodID === this.selectedPaymentMethodID);
	}
}


export type FlexshipCheckoutActions = [
	
	'LOAD_STATE_FROM_CACHE',
	
	'SET_CURRENT_FLEXSHIP',

	'SET_ACCOUNT_ADDRESSES',
	'SET_SHIPPING_METHODS',
	'SET_PAYMENT_METHODS',

	'SET_SELECTED_SHIPPING_ADDRESS_ID',
	'SET_SELECTED_SHIPPING_METHOD_ID',

	'SET_SELECTED_PAYMENT_PROVIDER',
	'SET_SELECTED_PAYMENT_METHOD_ID',
	'SET_SELECTED_BILLING_ADDRESS_ID',

	'TOGGLE_LOADING',
	'TOGGLE_NEW_SHIPPING_ADDRESS_FORM',

	'TOGGLE_BILLING_SAME_AS_SHIPPING',

	'TOGGLE_NEW_PAYMENT_METHOD_FORM',
	'TOGGLE_NEW_BILLING_ADDRESS_FORM',
];

export class FlexshipCheckoutStore extends NgStore<FlexshipCheckoutState, FlexshipCheckoutActions> {

	constructor(private monatService, private orderTemplateService, private sessionStorageCache) {
		
		super(new FlexshipCheckoutState);
		
		this.monatService.getAccountAddresses()
		.then( (data) => {
    		this.dispatch('SET_ACCOUNT_ADDRESSES', (state) => {
	    		state.accountAddresses = data.accountAddresses;
	    		state.primaryShippingAddressID =  data.primaryShippingAddressID;
				state.primaryBillingAddressID =  data.primaryBillingAddressID;
				state.primaryAccountAddressID =  data.primaryAccountAddressID;
				
				state = this.setSelectedShippingAddressIDReducer(state, this.selectAShippingAddress(state));
				state = this.setSelectedBillingAddressIDReducer(state, this.selectABillingAddress(state));
				return state;
    		});
		})
    	.then( () => this.monatService.getOptions({'siteOrderTemplateShippingMethodOptions':false}, false, this.orderTemplateService.currentOrderTemplateID))
    	.then( (options) => {
    		this.dispatch('SET_SHIPPING_METHODS', (state) => {
	    		state.shippingMethodOptions = options.siteOrderTemplateShippingMethodOptions;
	    		state.selectedShippingMethodID = this.selectAShippingMethod(state);
				return state;
    		})
		})
		.then( () => this.monatService.getAccountPaymentMethods() )
		.then( (data) => {
			this.dispatch('SET_SHIPPING_METHODS', (state) => {
				state.accountPaymentMethods = data.accountPaymentMethods;
				state.primaryPaymentMethodID = data.primaryPaymentMethodID
		
				state = this.setSelectedPaymentMethodIDReducer(state, this.selectAPaymentMethod(state));
				return state;
    		})
		})
		.catch( (e) => console.error(e) )
		.finally( () => {
			this.dispatch('TOGGLE_LOADING', {loading: false});
		})
		
		

		// this.mutate({ sessionStorageCache.get('flexshipCheckoutState') });
		
		//TODO: explore, cache can be used to restore the UI after page-reloads, and not just for this project
		// this.dispatch('LOAD_STATE_FROM_CACHE', (currentState:FlexshipCheckoutState): FlexshipCheckoutState => {
		// 	return {...currentState, ...sessionStorageCache.get('flexshipCheckoutState')}
		// })

		// Using a wild card to tap into everything and update the cache
		// this.hook('*', (state) => {
		//     this.sessionStorageCache.put('flexshipCheckoutState', state);
		// });
	}
	
	public setFlexshipReducer(state: FlexshipCheckoutState, flexship){
		state.flexship = flexship;
		state = this.setSelectedShippingAddressIDReducer(state, state.selectedShippingAddressID);
		state = this.setSelectedBillingAddressIDReducer(state, state.selectedBillingAddressID);
		state = this.setSelectedPaymentMethodIDReducer(state, state.selectedPaymentMethodID);
		state = this.setSelectedBillingAddressIDReducer(state, state.selectedBillingAddressID);
		state.selectedShippingMethodID = this.selectAShippingMethod(state, state.selectedShippingMethodID);
		return state;	
	}

	
	public setSelectedShippingAddressIDReducer(state: FlexshipCheckoutState, newAddressID: string){
		
		// only select an accountAddressID when user has passed a real-id
		// we still want to show previously-select-item(if any) when user clicks on cancel on new-address-form
		if( newAddressID && newAddressID !== 'new' && state.selectedShippingAddressID != newAddressID ){ 
			state.selectedShippingAddressID = newAddressID;
			
			if(state.billingSameAsShipping) {
				state.selectedBillingAddressID = state.selectedShippingAddressID;
			} else {
				state.billingSameAsShipping = newAddressID === state.selectedBillingAddressID
			}
		}
		
		// if user has passed new, or there's no select billing-address, show new-address-form 
		if(!state.selectedShippingAddressID || newAddressID === 'new'){
			state.showNewShippingAddressForm = true;
		} 
		else if(state.selectedShippingAddressID && state.showNewShippingAddressForm) {
			state.showNewShippingAddressForm = false;
		}
		
		return state;	
	}

	public setSelectedPaymentMethodIDReducer(state: FlexshipCheckoutState, newPaymentMethodID: string){
		
		// only select a payment-method when user has passed a real-id
		// we still want to show previously-select-item(if any) when user clicks on cancel on new-payment-method-form
		if( newPaymentMethodID && newPaymentMethodID !== 'new' && state.selectedPaymentMethodID != newPaymentMethodID ){ 
			state.selectedPaymentMethodID = newPaymentMethodID;
		}
		
		// if user has passed new, or there's no select billing-address, show new-address-form 
		if(!state.selectedPaymentMethodID || newPaymentMethodID === 'new'){
			state.showNewPaymentMethodForm = true;
		} 
		else if(state.selectedPaymentMethodID && state.showNewPaymentMethodForm) {
			state.showNewPaymentMethodForm = false;
		}
		
		return state;	
	}

	public toggleBillingSameAsShippingReducer(state: FlexshipCheckoutState, checked: boolean ){
		
		state.billingSameAsShipping = checked;

		if(state.billingSameAsShipping){
			state.selectedBillingAddressID = state.selectedShippingAddressID;
		}
		return state;
	}

	public setSelectedBillingAddressIDReducer(state:FlexshipCheckoutState, newAddressID){
		
		// only select an address when user has passed a real-id
		// we still want to show previously-select-item(if any) when user clicks on cancel on new-address-form
		if( newAddressID && newAddressID !== 'new' && state.selectedBillingAddressID != newAddressID ){ 
			state.selectedBillingAddressID = newAddressID;
			state.billingSameAsShipping = newAddressID === state.selectedShippingAddressID
		}
		
		// if user has passed new, or there's no select billing-address, show new-address-form 
		if(!state.selectedBillingAddressID || newAddressID === 'new'){
			state.showNewBillingAddressForm = true;
		} 
		else if(state.selectedBillingAddressID && state.showNewBillingAddressForm) {
			state.showNewBillingAddressForm = false;
		}
		
		return state;	
	}
	
	//helper functions to select best available shipping ang billing details
	
	public selectAShippingAddress(currentState:FlexshipCheckoutState, selectedShippingAddressID?:string) {
		 
		if(!selectedShippingAddressID && currentState.selectedShippingAddressID){
			selectedShippingAddressID = currentState.selectedShippingAddressID;
		} 
		if(!selectedShippingAddressID ){
			selectedShippingAddressID = currentState.flexship?.shippingAccountAddress_accountAddressID?.trim();
		}
    	if(!selectedShippingAddressID) { 
    		selectedShippingAddressID = currentState.primaryShippingAddressID?.trim()
    	}
		if(!selectedShippingAddressID) { 
			selectedShippingAddressID =	currentState.primaryAccountAddressID?.trim() 
		}
    	if(!selectedShippingAddressID){
    		//select the first available, else we'd have to show new address form
    		selectedShippingAddressID = currentState.accountAddresses?.find( () => true )?.accountAddressID?.trim() || 'new';
    	}
    	return selectedShippingAddressID;
	}
	
	public selectAShippingMethod(currentState:FlexshipCheckoutState, selectedShippingMethodID?:string) {
		 
		if(!selectedShippingMethodID && currentState.selectedShippingMethodID){
			selectedShippingMethodID = currentState.selectedShippingMethodID;
		} 
		 
		if(!selectedShippingMethodID){
			selectedShippingMethodID = currentState.flexship?.shippingMethod_shippingMethodID?.trim();
		}
    	if( !selectedShippingMethodID  && currentState.shippingMethodOptions?.length) {
    		selectedShippingMethodID = currentState.shippingMethodOptions?.find(e => true)?.value?.trim();
    	}
    	
    	return selectedShippingMethodID;
	}

	
	public selectABillingAddress(currentState:FlexshipCheckoutState, selectedBillingAddressID?:string) {
		 
		if(!selectedBillingAddressID && currentState.selectedBillingAddressID){
			selectedBillingAddressID = currentState.selectedBillingAddressID;
		} 
		if(!selectedBillingAddressID && currentState.billingSameAsShipping) { 
    		selectedBillingAddressID = currentState.selectedShippingAddressID?.trim();
    	}
		if(!selectedBillingAddressID ){
			selectedBillingAddressID = currentState.flexship?.billingAccountAddress_accountAddressID?.trim();
		}
    	if(!selectedBillingAddressID) { 
    	   selectedBillingAddressID = currentState.primaryBillingAddressID?.trim()
    	}
		if(!selectedBillingAddressID) { 
			selectedBillingAddressID = currentState.primaryAccountAddressID?.trim() 
		}
    	if( !selectedBillingAddressID ) {
    		//select the first available
    		selectedBillingAddressID = currentState.accountAddresses?.find( () => true )?.accountAddressID?.trim() || 'new';
    	}
    	return selectedBillingAddressID;
	}
	
	public selectAPaymentMethod(currentState:FlexshipCheckoutState, selectedPaymentMethodID?:string) {
		 
		if(!selectedPaymentMethodID && currentState.selectedPaymentMethodID){
			selectedPaymentMethodID = currentState.selectedPaymentMethodID;
		} 
		 
		if(!selectedPaymentMethodID ){
			selectedPaymentMethodID = currentState.flexship?.accountPaymentMethod_accountPaymentMethodID?.trim();
		}
		if(!selectedPaymentMethodID) { 
			selectedPaymentMethodID = currentState.primaryPaymentMethodID?.trim() 
		}
    	if( !selectedPaymentMethodID ) {
    		selectedPaymentMethodID = currentState.accountPaymentMethods?.find( () => true )?.accountPaymentMethodID?.trim() || 'new';
    	}
    	
    	return selectedPaymentMethodID;
	}
	
	
	/**
     * 
     * USES
     
        To get the current state
        const currentState = exampleStore.copy();
     
        To dispatch a change in state
        exampleStore.dispatch('INCREMENT_COUNT', (oldState) => {
            return { managedProperty: newValue };
        });
        
        
        To listen for a change 
        exampleStore.hook('INCREMENT_COUNT', ( state: State, initialRun: boolean) => {
            
            1. STATE: complete-state after any event (inclusive changes)
            
            2. initialRunFlag: every hook gets called as soon as it's registered, the flag will be true in that case;
            
        })
        .destroyOn($scope); //will get cleaned-up as soon the listener (controller is destroyed),

     **/
}
