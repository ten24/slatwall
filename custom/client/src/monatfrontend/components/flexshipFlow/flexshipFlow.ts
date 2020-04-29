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
	public isOFYEligible;
	
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
		this.orderTemplateService.getSetOrderTemplateOnSession('qualifiesForOFYProducts,purchasePlusTotal,vatTotal,taxTotal,fulfillmentHandlingFeeTotal', 'save', false, false)
		.then((res:{[key:string]:any})=>{
			this.orderTemplate = res.orderTemplate;
			if(!this.orderTemplate){
				// redirect to listing
			 	this.monatService.redirectToProperSite("/my-account/flexships");
			}
		});
		
		this.monatService.getProductFilters();
    }
	
	
	public back = ():FlexshipSteps => {
		let nextFrequencyStep = this.getCanViewOFYStep() ? FlexshipSteps.OFY : FlexshipSteps.FREQUENCY;
		switch(this.currentStep){
			case FlexshipSteps.FREQUENCY:
				return this.setStepAndUpdateProgress(FlexshipSteps.SHOP);
				break;
			case FlexshipSteps.OFY:
				return this.setStepAndUpdateProgress(FlexshipSteps.FREQUENCY);
				break;
			case FlexshipSteps.CHECKOUT:
				return this.setStepAndUpdateProgress(nextFrequencyStep);
				break;
			case FlexshipSteps.REVIEW:
				return this.setStepAndUpdateProgress(FlexshipSteps.CHECKOUT);
				break;
			default:
				return this.setStepAndUpdateProgress(FlexshipSteps.SHOP);
		}
		
	}
	
	public next = ():FlexshipSteps => {

		let nextFrequencyStep = this.getCanViewOFYStep() ? FlexshipSteps.OFY : FlexshipSteps.CHECKOUT;
	
		switch(this.currentStep){
			case FlexshipSteps.SHOP:
				return this.setStepAndUpdateProgress(FlexshipSteps.FREQUENCY)
				break;
			case FlexshipSteps.FREQUENCY:
				return this.setStepAndUpdateProgress(nextFrequencyStep);
				break;
			case FlexshipSteps.OFY:
				return this.setStepAndUpdateProgress(FlexshipSteps.CHECKOUT);
				break;
			default:
				return this.setStepAndUpdateProgress(FlexshipSteps.REVIEW);
		}
		
	}
	
	public goToStep = (step:FlexshipSteps):FlexshipSteps =>{
		this.currentStep = this.farthestStepReached >= step ? step : this.currentStep;
		(this.publicService as any).showFooter = this.currentStep == FlexshipSteps.REVIEW;
		return this.currentStep;
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

		if(step == FlexshipSteps.REVIEW){
			(this.publicService as any).showFooter = true;
		}else{
			(this.publicService as any).showFooter = false;
		}

		this.updateProgress(step);
		return this.currentStep = step;
    }
    
    private getCanViewOFYStep():boolean{
		this.orderTemplate = this.orderTemplateService.mostRecentOrderTemplate;
		let today = new Date().getDate() -20 ;
		this.isOFYEligible = this.orderTemplate.scheduleOrderDayOfTheMonth && this.orderTemplate.scheduleOrderDayOfTheMonth > today;
		return this.isOFYEligible;
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
