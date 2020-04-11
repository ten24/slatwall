import { FlexshipSteps } from '@Monat/components/flexshipFlow/flexshipFlow';
import { FlexshipCheckoutState, FlexshipCheckoutStore } from '@Monat/states/flexship-checkout-store';

import { MonatService } from '@Monat/services/monatservice';
import { PayPalService } from '@Monat/services/paypalservice';

class FlexshipCheckoutStepController {
	//states
	public currentState = {} as FlexshipCheckoutState;
	private stateListeners =[];
	private orderTemplate; //TODO: remove, placeholder

	//@ngInject
	constructor(
		public orderTemplateService,
		private monatService: MonatService,
		private payPalService: PayPalService,
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
			return data;
		})
		.then( data => {
			//select a payment method (previous,current,first)
		})
		;
	};

	public setSelectedPaymentProvider(selectedPaymentProvider){
		if(!this.currentState.selectedPaymentProvider || this.currentState.selectedPaymentProvider != selectedPaymentProvider ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_PAYMENT_PROVIDER', {
				'selectedPaymentProvider': selectedPaymentProvider	
			});
		}
	}
	
	public setSelectedPaymentMethodID(selectedPaymentMethodID?){
		if(!this.currentState.selectedPaymentMethodID || this.currentState.selectedPaymentMethodID != selectedPaymentMethodID ){
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_PAYMENT_METHOD_ID', {
				'selectedPaymentMethodID': selectedPaymentMethodID	
			});
		}
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
	
	public configurePayPal = () => {
		this.payPalService.configPayPal();
	};
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
