import { FlexshipSteps } from '@Monat/components/flexshipFlow/flexshipFlow';
import { MonatService } from '@Monat/services/monatservice';

class FlexshipCheckoutStepController {
	
	//states
	public activePaymentMethod: string = 'creditCard';
	
	
	public accountPaymentMethods = [];
	public orderTemplate;

    //@ngInject
    constructor(
    	public orderTemplateService, 
    	private monatService: MonatService
    ) {
    }

    public $onInit = () => { 
		this.monatService.getAccountPaymentMethods()
		.then( (accountPaymentMethods) => {
			this.accountPaymentMethods = accountPaymentMethods;
		})
    }

}

export class FlexshipCheckoutStep {

	public restrict = 'E';
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