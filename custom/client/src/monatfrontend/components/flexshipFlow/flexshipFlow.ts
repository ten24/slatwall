import { MonatService, IOption } from '@Monat/services/monatservice';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';
import { PublicService, ObserverService } from '@Hibachi/core/core.module'

export enum FlexshipSteps{
	SHOP,
	FREQUENCY,	
	OFY,
	CHECKOUT,
	REVIEW
}

export enum FlexshipFlowEvents {
	ON_NEXT = 'onNext',
	ON_BACK = 'onBack',
	ON_COMPLETE_CHECKOUT = 'onFlexshipFlowFinalDestiation',
	ON_COMPLETE_CHECKOUT_SUCCESS = 'onFlexshipFlowFinalDestiationSuccess',
	ON_COMPLETE_CHECKOUT_FAILURE = 'onFlexshipFlowFinalDestiationFailure'
}

class FlexshipFlowController {
	public FlexshipSteps = FlexshipSteps; 
	public currentStep = FlexshipSteps.SHOP; 
	public farthestStepReached = FlexshipSteps.SHOP; 
	public orderTemplate:{[key:string]:any};
	public currentOrderTemplateID:string;
	public muraData;
	
	
    public loading: boolean;
	
    //@ngInject
    constructor(
    	public publicService: PublicService,
    	public orderTemplateService: OrderTemplateService,
    	private monatService: MonatService,
    	public observerService: ObserverService
    ) {
    	this.observerService.attach(this.next, FlexshipFlowEvents.ON_NEXT);
    	this.observerService.attach(() => { this.loading = false }, FlexshipFlowEvents.ON_COMPLETE_CHECKOUT_FAILURE);
    }
    
    public $onInit = () => {
    	
    	this.currentOrderTemplateID = this.monatService.getCurrentFlexship()?.orderTemplateID;
		this.orderTemplateService.getSetOrderTemplateOnSession('qualifiesForOFYProducts,purchasePlusTotal,vatTotal,taxTotal', 'save', false, false)
		.then((res:{[key:string]:any})=>{
			this.orderTemplate = res.orderTemplate;
			if(!this.orderTemplate){
				// redirect to listing
			 	this.monatService.redirectToProperSite("/my-account/flexships");
			}
		});
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
				return this.setStepAndUpdateProgress(FlexshipSteps.REVIEW);
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
			return this.observerService.notify( FlexshipFlowEvents.ON_COMPLETE_CHECKOUT );
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
		muraData:'<?'
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
