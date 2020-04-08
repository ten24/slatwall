import { MonatService, IOption } from '@Monat/services/monatservice';

enum FlexshipSteps{
	SHOP,
	FREQUENCY,	
	OFY,
	CHECKOUT	
}

class FlexshipFlowController {
	public FlexshipSteps = FlexshipSteps; 
	public currentStep = FlexshipSteps.SHOP;
	public farthestStepReached = FlexshipSteps.SHOP;
	public orderTemplate:{[key:string]:any};
	

	
	public currentOrderTemplateID:string;

    //@ngInject
    constructor(
    	public publicService,
    	public orderTemplateService,
    	private monatService: MonatService
    ) {
    
    	
    }
    
    public $onInit = () => {
    	
    	this.currentOrderTemplateID = this.monatService.getCurrentFlexship();
    	

    }
	
	public back = ():FlexshipSteps => {
		switch(this.currentStep){
			case FlexshipSteps.FREQUENCY:
				return this.setStepAndUpdateProgress(FlexshipSteps.SHOP);
				break;
			case FlexshipSteps.OFY:
				return this.setStepAndUpdateProgress(FlexshipSteps.FREQUENCY);
				break;
			case FlexshipSteps.CHECKOUT:
				return this.setStepAndUpdateProgress(FlexshipSteps.OFY);
				break;
			default:
				return this.setStepAndUpdateProgress(FlexshipSteps.SHOP);
		}
		
	}
	
	public next = ():FlexshipSteps => {
		switch(this.currentStep){
			case FlexshipSteps.SHOP:
				return this.setStepAndUpdateProgress(FlexshipSteps.FREQUENCY)
				break;
			case FlexshipSteps.FREQUENCY:
				return this.setStepAndUpdateProgress(FlexshipSteps.OFY);
				break;
			case FlexshipSteps.OFY:
				return this.setStepAndUpdateProgress(FlexshipSteps.CHECKOUT);
				break;
			default:
				return this.setStepAndUpdateProgress(FlexshipSteps.CHECKOUT);
		}
		
	}
	
	public goToStep = (step:FlexshipSteps):FlexshipSteps =>{
		return this.currentStep = this.farthestStepReached >= step ? step : this.currentStep;
	}
	
	public updateProgress(step:FlexshipSteps):void{
		if(step > this.farthestStepReached){
			this.farthestStepReached = step;
		}
	}

	private setStepAndUpdateProgress(step:FlexshipSteps):FlexshipSteps{
		this.updateProgress(step);
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
			rbkeyService,
        ) => new FlexshipFlow(
			monatFrontendBasePath,
			rbkeyService,
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'rbkeyService',
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
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

