import { FlexshipCheckoutState, FlexshipCheckoutStore } from '@Monat/states/flexship-checkout-store';
import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

import {AccountAddress } from '@Monat/models';

class FlexshipCheckoutShippingAddressController {
	
	public currentState = {} as FlexshipCheckoutState;
	private stateListeners =[];

	private newAddressFormRef;
	public loading: boolean = false;

	//@ngInject
    constructor(
    	public rbkeyService, 
    	public observerService, 
    	public monatAlertService: MonatAlertService,
    	private monatService: MonatService,
    	private ModalService,
    	private flexshipCheckoutStore: FlexshipCheckoutStore,
    ) {}
    
    public $onInit = () => {
    	this.setupStateChangeListeners();
    };

	// *********************. states  .**************************** //
	
    public setSelectedShippingAddressID(selectedShippingAddressID?){
		this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_SHIPPING_ADDRESS_ID', (state) => {
			return this.flexshipCheckoutStore.setSelectedShippingAddressIDReducer( state, selectedShippingAddressID);
		});
	}
    
	private onNewStateReceived = (state: FlexshipCheckoutState) => {
		console.info("checkout-step-->shippingAddress, on-new-state ");
		this.currentState = state;
		this.currentState.showNewShippingAddressForm ? this.showNewAddressForm() : this.hideNewAddressForm();
	}

	private setupStateChangeListeners(){
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('TOGGLE_LOADING', this.onNewStateReceived)
		);
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('SET_ACCOUNT_ADDRESSES', this.onNewStateReceived)
		);
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('SET_SELECTED_SHIPPING_ADDRESS_ID', this.onNewStateReceived)
		);
	}
	
	public $onDestroy= () => {
		//to clear all of the listeners 
		this.stateListeners.map( hook => hook.destroy());
	}    

	public formatAddress = (accountAddress):string =>{
        return this.monatService.formatAccountAddress(accountAddress);
    }


	// *****************. new Address Form  .***********************//
	
    public onAddNewAccountAddressSuccess = (newAccountAddress: AccountAddress) => {
		
		if(newAccountAddress) {
			this.currentState.accountAddresses.push(newAccountAddress);
			this.flexshipCheckoutStore.dispatch('SET_ACCOUNT_ADDRESSES', {
				accountAddresses : this.currentState.accountAddresses
			});
    		this.setSelectedShippingAddressID(newAccountAddress.accountAddressID);
        }
    	return true;
    };
    
    
    public showNewAddressForm = (accountAddress?) => {
        
        if(this.newAddressFormRef) {
            return this.newAddressFormRef?.show?.();
        }
        
		let bindings = {
			onSuccessCallback: this.onAddNewAccountAddressSuccess,
			formHtmlId: Math.random().toString(36).replace('0.', 'newshippingaddressform' || '')
		};
		
		// sometimes concurrent calls to this function (caused by concurrent api response), 
		// creates multiple instance of the modal, as the show-modal function is async 
		// and waits for angular to load the template from network
		// to prevent that, we're populating this.newAddressFormRef with some temp-data
		this.newAddressFormRef = bindings.formHtmlId;
		
		
		this.ModalService.showModal({
			component: 'accountAddressForm',
			appendElement: '#shipping-new-account-address-form', //can be any vlid selector
			bindings: bindings
		})
		.then( (component) => {
			component.close.then( () => {
				this.newAddressFormRef = undefined;
				// doing this will reopen the form if there's no account-address
				// otherwise will fallback to either previously-selected, or best available 
				this.setSelectedShippingAddressID(this.flexshipCheckoutStore.selectAShippingAddress(this.currentState));
				
			});
			this.newAddressFormRef = component.element;
		})
		.catch((error) => {
			this.newAddressFormRef = undefined;
			console.error('unable to open new-account-address-form :', error);
		});
	};
	
	private hideNewAddressForm(){
	    this.newAddressFormRef?.hide?.();
	}

}

class FlexshipCheckoutShippingAddress {

	public restrict:"E";
	public scope = {};
	public templateUrl:string;
	public bindToController = {
	    orderTemplate:'<',
	};
	public controller=FlexshipCheckoutShippingAddressController;
	public controllerAs="flexshipCheckoutShippingAddress";

	public static Factory(){
        //@ngInject
        return ( monatFrontendBasePath ) => {
            return new FlexshipCheckoutShippingAddress( monatFrontendBasePath);
        }; 
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/checkout-components/shipping-address.html";
	}

}

export {
	FlexshipCheckoutShippingAddress
};
