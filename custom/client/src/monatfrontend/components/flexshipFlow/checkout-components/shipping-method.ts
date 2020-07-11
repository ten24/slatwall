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
    };

    
    public setSelectedShippingMethodID(selectedShippingMethodID?) {
    	if(this.currentState.selectedShippingMethodID != selectedShippingMethodID ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_SHIPPING_METHOD_ID', {
				'selectedShippingMethodID': selectedShippingMethodID	
			});
		}
    }
    
    private onNewStateReceived = (state: FlexshipCheckoutState) => {
		this.currentState = state;
	}

	private setupStateChangeListeners(){
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('TOGGLE_LOADING', this.onNewStateReceived)
		);
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('SET_SHIPPING_METHODS', this.onNewStateReceived)
		);
		this.stateListeners.push(
			this.flexshipCheckoutStore.hook('SET_SELECTED_SHIPPING_METHOD_ID', this.onNewStateReceived)
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

	public template = require('./shipping-method.htm');

	public static Factory() {
		return () => new this();
	}

}

export {
	FlexshipCheckoutShippingMethod
};
