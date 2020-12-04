import { FlexshipSteps, FlexshipFlowEvents } from '@Monat/components/flexshipFlow/flexshipFlow';

class FrequencyStepController {
	public orderTemplate;
	public frequencyTerms;
	public flexshipDaysOfMonth = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]; 
	public flexshipFrequencyHasErrors:boolean;
	public loading:boolean;
	public day:number;
	public term;
	
    //@ngInject
    constructor( public monatService, public orderTemplateService, public observerService) {

    }
    
    public $onInit = () => { 
    	this.getFrequencyTermOptions();
    	this.orderTemplate = this.orderTemplateService.mostRecentOrderTemplate;
    }
    
	public getFrequencyTermOptions = ():void =>{
		this.monatService.getOptions({'frequencyTermOptions': false }).then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
			if(this.orderTemplate.frequencyTerm_termID){
				for(let term of this.frequencyTerms){
					if(term.value == this.orderTemplate.frequencyTerm_termID){
						this.term = term;
					}
				}
			}
			
			if(!this.term){
				this.term = this.frequencyTerms[0];
			} 
			if(this.orderTemplate.scheduleOrderDayOfTheMonth){
				this.day = this.orderTemplate.scheduleOrderDayOfTheMonth;
			}else{
				this.day = this.flexshipDaysOfMonth[0];
			}
		});
	}
	
	
    public setOrderTemplateFrequency = (frequencyTerm, dayOfMonth) => {
		this.loading = true;
        let flexshipID = this.orderTemplateService.currentOrderTemplateID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, this.term.value, this.day).then(result => {
            this.loading = false;
            if(typeof result.qualifiesForOFY == 'boolean') this.orderTemplateService.mostRecentOrderTemplate.qualifiesForOFYProducts = result.qualifiesForOFY;
        	this.observerService.notify(FlexshipFlowEvents.ON_NEXT);
        });
    }
}

class FrequencyStep {

	public restrict = 'E'
	public templateUrl:string;
	public require={
		flexshipFlow : '^flexshipFlow'
	}
	
	public controller = FrequencyStepController;
	public controllerAs = "frequencyStep";
	
	public template = require('./frequencyStep.html');

	public static Factory() {
		return () => new this();
	}

}

export {
	FrequencyStep
};
