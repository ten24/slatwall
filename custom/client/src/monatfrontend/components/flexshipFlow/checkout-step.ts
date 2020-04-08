class FlexshipCheckoutStepController {
	public FlexshipSteps;
	public orderTemplate;

    //@ngInject
    constructor(public orderTemplateService) {

    }

    public $onInit = () => { 
    }

}

export class FlexshipCheckoutStep {

	public restrict = 'E';
	public controller = FlexshipCheckoutStepController;
	public controllerAs = "flexshipCheckoutStep";
	public templateUrl:string;
	
	public bindToController = {

	};

	constructor(private basePath){
		this.templateUrl = basePath + "/monatfrontend/components/flexshipFlow/checkout-step.html";
	}

	public static Factory() {
        var directive:any = ( basepath) =>  new FlexshipCheckoutStep( basepath);
       
        directive.$inject = [ 'monatFrontendBasePath'];

        return directive;
    }
}