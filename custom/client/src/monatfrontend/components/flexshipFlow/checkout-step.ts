import { FlexshipSteps } from '@Monat/components/flexshipFlow/flexshipFlow';

class FlexshipCheckoutStepController {
	
	//states
	public activePaymentMethod: string = 'creditCard';

	public orderTemplate;

    //@ngInject
    constructor(public orderTemplateService) {

    }

    public $onInit = () => { 
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