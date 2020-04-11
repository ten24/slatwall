import { NgStore } from './angularjs-store';

export type AccountAddress = { accountAddressID:string };
export type Option = { 'name': string, 'value': string };

// keep is Simple And Stupid, remember it's not a magic-bullet
export interface FlexshipCheckoutState {
	loading: boolean;

	flexship: any; 
	
	// will get updated everytime we add new-address
	accountAddresses: Array<AccountAddress>; 
	shippingMethodOptions: Array<Option>;
	selectedShippingAddressID: string;
	selectedShippingMethodID: string;
	showNewShippingAddressForm: boolean;

	// will get updated everytime we add new-payment-method
	accountPaymentMethods: []; 
	selectedPaymentProvider: string;
	
	selectedPaymentMethodID: string;
	selectedBillingAddressID: string;
	showNewPaymentMethodForm: boolean;
	showNewBillingAddressForm: boolean;
	//
	primaryAccountAddressID: string;
	primaryShippingAddressID: string;
	primaryBillingAddressID: string;
	primaryPaymentMethodID: string;
}

export type FlexshipCheckoutActions = [
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

	'TOGGLE_NEW_PAYMENT_METHOD_FORM',
	'TOGGLE_NEW_BILLING_ADDRESS_FORM',
];

export class FlexshipCheckoutStore extends NgStore<FlexshipCheckoutState, FlexshipCheckoutActions> {
	public static defaultState = {
		//defaults
		loading: false,
		showNewShippingAddressForm: false,
		showNewPaymentMethodForm: false,
		showNewBillingAddressForm: false,

		accountAddresses: [],
		shippingMethodOptions: [],
		selectedShippingAddressID: undefined,
		selectedShippingMethodID: undefined,

		selectedPaymentProvider: 'creditCard', // creditCard | payPal
		accountPaymentMethods: [],
		selectedPaymentMethodID: undefined,
		selectedBillingAddressID: undefined,
		//
		primaryAccountAddressID: undefined,
		primaryShippingAddressID: undefined,
		primaryBillingAddressID: undefined,
		primaryPaymentMethodID: undefined,
	};

	constructor(private monatService, private orderTemplateService, private sessionStorageCache) {
		//TODO: explore, cache can be used to restore the UI after page-reloads, and not just for this project
		super({
			...sessionStorageCache.get('flexshipCheckoutState'),
			...FlexshipCheckoutStore.defaultState,
		} as FlexshipCheckoutState);

		// Using a wild card to tap into everything and update the cache
		// this.hook('*', (state) => {
		//     this.sessionStorageCache.put('flexshipCheckoutState', state);
		// });
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
