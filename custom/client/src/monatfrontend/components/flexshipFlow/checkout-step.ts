import { FlexshipSteps } from '@Monat/components/flexshipFlow/flexshipFlow';
import { FlexshipCheckoutState as State, FlexshipCheckoutStore } from '@Monat/components/flexshipFlow/flexship-checkout-store';
import { MonatService } from '@Monat/services/monatservice';
import { PayPalService } from '@Monat/services/paypalservice';

class FlexshipCheckoutStepController {
	
	//states
	public activePaymentMethod: string = 'creditCard';
	public state: State;
	
	public accountPaymentMethods = [];
	public orderTemplate;

    //@ngInject
    constructor(
    	public orderTemplateService, 
    	private monatService: MonatService,
    	private payPalService: PayPalService,
    	private flexshipCheckoutStore: FlexshipCheckoutStore
    ) {
    }

    public $onInit = () => { 
		
		this.flexshipCheckoutStore.hook('*', (state) => {
			this.state = state;
		});

		
		this.monatService.getAccountPaymentMethods()
		.then( (accountPaymentMethods) => {
			this.flexshipCheckoutStore.dispatch( 'SET_SELECTED_PAYMENT_METHOD', { accountPaymentMethods: accountPaymentMethods }  );
		});
		
    }
    
    public configurePayPal = () =>{
    	this.payPalService.configPayPal();
    }
	
}

export class FlexshipCheckoutStep {

	public restrict = 'E';
	public scope = {};
	public templateUrl:string;
	public controller = FlexshipCheckoutStepController;
	public controllerAs = "flexshipCheckout";
	public bindToController = {};
	

	constructor(private basePath){
		this.templateUrl = basePath + "/monatfrontend/components/flexshipFlow/checkout-step.html";
	}

	public static Factory() {
	    //@ngInject
        return ( monatFrontendBasePath ) => {
            return new FlexshipCheckoutStep( monatFrontendBasePath);
        }; 
    }
}