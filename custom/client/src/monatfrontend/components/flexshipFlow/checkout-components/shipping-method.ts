import { FlexshipCheckoutState, FlexshipCheckoutStore } from '@Monat/states/flexship-checkout-store';

import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

class FlexshipCheckoutShippingMethodController {
	public loading: boolean = false;
	
	public currentState = {} as FlexshipCheckoutState;
	private stateListeners =[];
	
	//@ngInject
    constructor(
    	public rbkeyService, 
    	private monatService: MonatService,
    	private flexshipCheckoutStore: FlexshipCheckoutStore,
    ) {}
    
    public $onInit = () => {
        
        this.loading=true;
        this.setupStateChangeListeners();
        
    	this.monatService.getOptions({'orderTemplateShippingMethodOptions':false}) 
    	.then( (options) => {
    		
    		this.flexshipCheckoutStore.dispatch( 'SET_SHIPPING_METHODS', {
				shippingMethodOptions: options.orderTemplateShippingMethodOptions
    		})
    		this.selectAShippingMethod();
    	})
    	.catch( e => console.error(e) )
		.finally( () => this.loading = false);
    };
    
    private selectAShippingMethod(selectedShippingMethodID?) {
		/**
		 * If none provided, select a shipping-method first of ( previous on flexship, OR first available )
		 */
		if(!selectedShippingMethodID?.trim() ){
			selectedShippingMethodID = this.currentState?.flexship?.shippingMethod_shippingMethodID?.trim();
		}
    	if( !selectedShippingMethodID  && this.currentState?.shippingMethodOptions?.length) {
    		selectedShippingMethodID = this.currentState?.shippingMethodOptions?.find(e => true)?.value?.trim();
    	}
    	
    	this.setSelectedShippingMethodID( selectedShippingMethodID );
	}
    
    public setSelectedShippingMethodID(selectedShippingMethodID?) {
    	if(!this.currentState.selectedShippingMethodID || this.currentState.selectedShippingMethodID != selectedShippingMethodID ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_SHIPPING_ADDRESS_ID', {
				'selectedShippingMethodID': selectedShippingMethodID	
			});
		}
    }
    
    private onNewStateReceived = (state: FlexshipCheckoutState) => {
		this.currentState = state;
		this.selectAShippingMethod(this.currentState.selectedShippingMethodID);
		console.log("checkout-step-->shippingMethod, on-new-state", this.currentState);
	}

	private setupStateChangeListeners(){
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('SET_CURRENT_FLEXSHIP', this.onNewStateReceived)
		);
	}
	
	public $onDestroy= () => {
		//to clear all of the listenets 
		this.stateListeners.map( hook => hook.destroy());
	}    

    
}

class FlexshipCheckoutShippingMethod {

	public restrict:"E";
	public scope = {};
	public templateUrl:string;
	public bindToController = {
	    orderTemplate:'<',
	};
	public controller=FlexshipCheckoutShippingMethodController;
	public controllerAs="flexshipCheckoutShippingMethod";

	public static Factory(){
        //@ngInject
        return ( monatFrontendBasePath ) => {
            return new FlexshipCheckoutShippingMethod( monatFrontendBasePath);
        }; 
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/checkout-components/shipping-method.html";
	}

}

export {
	FlexshipCheckoutShippingMethod
};

