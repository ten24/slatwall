import { FlexshipCheckoutState, FlexshipCheckoutStore } from '@Monat/states/flexship-checkout-store';
import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

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
    	this.loading=true;
    	this.setupStateChangeListeners();
    	this.monatService.getAccountAddresses() 
    	.then( (data) => {
    		
    		this.flexshipCheckoutStore.dispatch( 'SET_ACCOUNT_ADDRESSES', {
				'accountAddresses': data.accountAddresses,
				'primaryShippingAddressID': data.primaryShippingAddressID,
				'primaryBillingAddressID': data.primaryBillingAddressID,
				'primaryAccountAddressID': data.primaryAccountAddressID,
			})
    	})
    	.then( () => this.selectAShippingAddress() )
    	.catch( e =>  console.error(e) )
		.finally( () => this.loading = false );
    };
    
	/**
	 * If none provided, select a shippingAddress first of (previous on flexship, primaryShipping, primaryAccount)
	*/
    private selectAShippingAddress(selectedShippingAddressID?) {
		 
		if(!selectedShippingAddressID ){
			selectedShippingAddressID = this.currentState?.flexship?.shippingAccountAddress_accountAddressID?.trim();
		}
    	if(!selectedShippingAddressID) { 
    		selectedShippingAddressID = this.currentState?.primaryShippingAddressID?.trim()
    	}
		if(!selectedShippingAddressID) { 
			selectedShippingAddressID = this.currentState?.primaryAccountAddressID?.trim() 
		}
    	if( !selectedShippingAddressID  && this.currentState?.accountAddresses?.length) {
    		//select the first available
    		selectedShippingAddressID = this.currentState.accountAddresses.find( () => true )?.accountAddressID?.trim();
    	}
    	
    	this.setSelectedAccountAddressID(selectedShippingAddressID);
	}
	
	
	
	// *********************. states  .**************************** //
	
    public setSelectedAccountAddressID(selectedShippingAddressID?){
		
		if( selectedShippingAddressID && this.currentState.selectedShippingAddressID != selectedShippingAddressID  ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_SHIPPING_ADDRESS_ID', {
				'selectedShippingAddressID': selectedShippingAddressID	
			});
		}
		
		if(!selectedShippingAddressID){
			this.flexshipCheckoutStore.dispatch( 'TOGGLE_NEW_SHIPPING_ADDRESS_FORM', {
				showNewShippingAddressForm: true
			});
			this.showNewAddressForm();
		}
		else if( selectedShippingAddressID && this.currentState.showNewShippingAddressForm){
			this.flexshipCheckoutStore.dispatch( 'TOGGLE_NEW_SHIPPING_ADDRESS_FORM', {
				showNewShippingAddressForm: false
			});
			this.hideNewAddressForm();
		}
	}
    
	private onNewStateReceived = (state: FlexshipCheckoutState) => {
		this.currentState = state;
		console.log("checkout-step-->shippingAddress, on-new-state", this.currentState);
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
    		this.setSelectedAccountAddressID(newAccountAddress.accountAddressID);
        }
    	console.log("add new account adress, on success", newAccountAddress);
    	return true;
    };
    
    public onAddNewAccountAddressFailure = (error) => {
        console.log("add account adress, on failure", error);
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
			appendElement: '#shipping-new-account-address-form', //can be any vlid selector
			bindings: bindings
		})
		.then( (component) => {
			component.close.then( () => {
				this.newAddressFormRef = undefined;
				this.selectAShippingAddress(this.currentState.selectedShippingAddressID);
			});
			this.newAddressFormRef = component.element;
		})
		.catch((error) => {
			console.error('unable to open new-account-address-form :', error);
		});
	};
	
	private hideNewAddressForm(){
	    this.newAddressFormRef?.hide();
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

