import { MonatService, IOption } from '@Monat/services/monatservice';

export enum FlexshipSteps{
	SHOP,
	FREQUENCY,	
	OFY,
	CHECKOUT	
}

export enum FlexshipFLowEvents {
	ON_NEXT = 'onFlexshipFlowNext',
	ON_BACK = 'onFlexshipFlowBack',
	ON_FINALIZE = 'onFlexshipFlowFinalDestiation'
}

class FlexshipFlowController {
	public FlexshipSteps = FlexshipSteps; 
	public currentStep = FlexshipSteps.CHECKOUT;
	public farthestStepReached = FlexshipSteps.CHECKOUT;
	
	public orderTemplate:{[key:string]:any};
	
    //@ngInject
    constructor(
    	public publicService,
    	public orderTemplateService,
    	private monatService: MonatService,
    	public observerService
    ) {
    
    	
    }
    
    public $onInit = () => {
    	
    	this.orderTemplate = this.monatService.getCurrentFlexship();
    	
		if(!this.orderTemplate){
			//redirect to listing
			// this.monatService.redirectToProperSite("/my-account/flexships");
		}
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
		
		if(this.currentStep === step && step === FlexshipSteps.CHECKOUT){
			this.observerService.notify( FlexshipFLowEvents.ON_FINALIZE );

		}
		
		
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

