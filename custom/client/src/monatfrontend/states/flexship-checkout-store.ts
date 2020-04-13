import { NgStore } from './angularjs-store';

export type AccountAddress = { accountAddressID:string };
export type AccountPaymentMethod = { accountPaymentMethodID:string };
export type Option = { 'name': string, 'value': string };

// keep is Simple And Stupid, remember it's not a magic-bullet
export class FlexshipCheckoutState {
	loading: boolean= true;


	flexship: any; 
	
	// will get updated everytime we add new-address
	accountAddresses: Array<AccountAddress>; 
	shippingMethodOptions: Array<Option>;
	selectedShippingAddressID: string;
	selectedShippingMethodID: string;
	showNewShippingAddressForm: boolean = false;
	
	accountPaymentMethods: Array<AccountPaymentMethod>; 
	selectedPaymentProvider: "creditCard" | "paypal" = "creditCard";
	
	selectedPaymentMethodID: string;
	selectedBillingAddressID: string;
	
	billingSameAsShipping: boolean = true;
	showNewPaymentMethodForm: boolean = false;
	showNewBillingAddressForm: boolean = false;
	
	
	//
	primaryAccountAddressID: string;
	primaryShippingAddressID: string;
	primaryBillingAddressID: string;
	primaryPaymentMethodID: string;
	
	public getSelectedShippingAddress() {
		return this.accountAddresses?.find(a => a.accountAddressID === this.selectedShippingAddressID);
	}
	
	public getSelectedBillingAddress() {
		return this.accountAddresses?.find(a => a.accountAddressID === this.selectedBillingAddressID);
	}

	public getSelectedPaymentMethod() {
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
    	.then( () => this.monatService.getOptions({'orderTemplateShippingMethodOptions':false}))
    	.then( (options) => {
    		
    		this.dispatch('SET_SHIPPING_METHODS', (state) => {
	    		state.shippingMethodOptions = options.orderTemplateShippingMethodOptions;
	    		state.selectedShippingMethodID = this.selectAShippingMethod(state);
				return state;
    		})
    		
    	})
    	.then( () => this.monatService.getAccountPaymentMethods())
		.then( (data) => {
			
			this.dispatch('SET_SHIPPING_METHODS', (state) => {
				state.accountPaymentMethods = data.accountPaymentMethods;
				state.primaryPaymentMethodID = data.primaryPaymentMethodID
		
				state = this.setSelectedPaymentMethodIDReducer(state, this.selectAPaymentMethod(state));
				return state;
    		})
			
		})
		.then( () => {
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
	
	public setSelectedShippingAddressIDReducer(state: FlexshipCheckoutState, newAddressID: string){
		
		// only select an accountAddressID when user has passed a real-id
		// we stil want to show previously-select-item(if any) and user clicks on cancel on new-address-form
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
		// we stil want to show previously-select-item(if any) and user clicks on cancel on new-address-form
		if( newPaymentMethodID && newPaymentMethodID !== 'new' && state.selectedShippingAddressID != newPaymentMethodID ){ 
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
		// we stil want to show previously-select-item(if any) and user clicks on cancel on new-address-form
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
			selectedShippingAddressID = currentState.flexship?.ShippingAccountAddress_accountAddressID?.trim();
		}
    	if(!selectedShippingAddressID) { 
    		selectedShippingAddressID = currentState.primaryShippingAddressID?.trim()
    	}
		if(!selectedShippingAddressID) { 
			selectedShippingAddressID =	currentState.primaryAccountAddressID?.trim() 
		}
    	if( !selectedShippingAddressID  && currentState.accountAddresses?.length) {
    		//select the first available
    		selectedShippingAddressID = currentState.accountAddresses.find( () => true )?.accountAddressID?.trim();
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
    	if( !selectedBillingAddressID  && currentState.accountAddresses?.length) {
    		//select the first available
    		selectedBillingAddressID = currentState.accountAddresses.find( () => true )?.accountAddressID?.trim();
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
    	if( !selectedPaymentMethodID  && currentState.accountPaymentMethods?.length) {
    		selectedPaymentMethodID = currentState.accountPaymentMethods.find( () => true )?.accountPaymentMethodID?.trim();
    	}
    	
    	return selectedPaymentMethodID;
	}
	
	
	/**
     * 
     * USES
     
        To get the current state
        const currentState = exampleStore.copy();
     
        To dispatch a chenge in state
        exampleStore.dispatch('INCREMENT_COUNT', (oldState) => {
            return { managedProperty: newValue };
        });
        
        
        To listen for a change 
        exampleStore.hook('INCREMENT_COUNT', ( state: State, initialRun: boolean) => {
            
            1. STATE: complete-state after any event (inclusive changes)
            
            2. initialRunFlag: every hoock gets called as soon as it's registered, the flag will be true in that case;
            
        })
        .destroyOn($scope); //will get cleanedup as soon the listener (controlller is destrpyed),

     **/
}
