
enum FlexshipSteps{
	SHOP,
	FREQUENCY,	
	OFY,
	CHECKOUT	
}

class FlexshipFlowController {
	public FlexshipSteps = FlexshipSteps; 
	public currentStep = FlexshipSteps.SHOP;
	
    //@ngInject
    constructor(public observerService, public publicService) {
    
    }
    
    public $onInit = () => { }
	
	public back = ():FlexshipSteps => {
		switch(this.currentStep){
			case FlexshipSteps.FREQUENCY:
				return this.currentStep = FlexshipSteps.SHOP;
				break;
			case FlexshipSteps.OFY:
				return this.currentStep = FlexshipSteps.FREQUENCY;
				break;
			case FlexshipSteps.CHECKOUT:
				return this.currentStep = FlexshipSteps.OFY;
				break;
			default:
				return this.currentStep = FlexshipSteps.SHOP;
		}
		
	}
	
	public next = ():FlexshipSteps => {
		switch(this.currentStep){
			case FlexshipSteps.SHOP:
				return this.currentStep = FlexshipSteps.FREQUENCY;
				break;
			case FlexshipSteps.FREQUENCY:
				return this.currentStep = FlexshipSteps.OFY;
				break;
			case FlexshipSteps.OFY:
				return this.currentStep = FlexshipSteps.CHECKOUT;
				break;
			default:
				return this.currentStep = FlexshipSteps.CHECKOUT;
		}
		
	}
	
	public goToStep = (step):FlexshipSteps =>{
		return this.currentStep = step;
	}
	
    
}

class FlexshipFlow {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	
	};
	
	public controller = FlexshipFlowController;
	public controllerAs = "flexshipFlow";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new FlexshipFlow(
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'$hibachi',
			'rbkeyService',
			'requestService'
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/flexshipFlow.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	FlexshipFlow
};

