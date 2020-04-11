import NgStore from '@ranndev/angularjs-store';

// keep is Simple And Stupid, remember it's not a magic-bullet
export interface FlexshipCheckoutState {
  
    flexship?:any; //current flexship, will get updated after every change (shipping, billing, payment);
    loading: boolean;
    
    // 
    accountAddresses?:[]; // will get updated everytime we add new-address
    selectedShippingAddressID?:string;
    selectedShippingMethodID?:string;
    showNewShippingAddressForm: boolean;

    //  
    accountPaymentMethods?:[]; // will get updated everytime we add new-payment-method
    selectedPaymentMethodID?:string;  
    selectedBillingAddressID?:string;
    showNewPaymentMethodForm: boolean;
    showNewBillingAddressForm: boolean;
    //  
    primaryAccountAddressID?:string; 
    primaryShippingAddressID?:string; 
    primaryBillingAddressID?:string;
    primaryPaymentMethodID?:string;
}

export type FlexshipCheckoutActions = [
  
    'SET_CURRENT_FLEXSHIP',
    
    'SET_ACCOUNT_ADDRESSES', 
    'SET_PAYMENT_METHODS', 
    
    'SET_SELECTED_SHIPPING_ADDRESS',
    'SET_SELECTED_SHIPPING_METHOD',
    
    'SET_SELECTED_PAYMENT_METHOD',
    'SET_SELECTED_BILLING_ADDRESS',
    
    'TOGGLE_LOADING',
    'TOGGLE_NEW_SHIPPING_ADDRESS_FORM',
    
    'TOGGLE_NEW_PAYMENT_METHOD_FORM',
    'TOGGLE_NEW_BILLING_ADDRESS_FORM',

  
];

/**
 * It's a very light-weight state-management library for AngularJS, and currently maintained
 *
 * For Doc, Tutorials visit https://angularjs-store.gitbook.io/docs/tutorials/
 * 
*/ 
export class FlexshipCheckoutStoreService extends NgStore<FlexshipCheckoutState, FlexshipCheckoutActions> {
    constructor(
        private monatService, 
        private orderTemplateService, 
        private sessionStorageCache
    ){
        
        //TODO: explore, can be used to restore the UI after page-reloads, and not just for this project
        super(  sessionStorageCache.get('flexshipCheckoutState')  || {
                    
                    //defaults
                    loading: false,
                    showNewShippingAddressForm: false,
                    showNewPaymentMethodForm: false,
                    showNewBillingAddressForm: false
                    
                }  as FlexshipCheckoutState);
        
        
        
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
