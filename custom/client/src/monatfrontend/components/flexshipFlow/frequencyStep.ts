import{ FlexshipFlow } from './flexshipFlow';

class FrequencyStepController {
	public orderTemplate;
	public frequencyTerms;
	public termMap = {};
	public flexshipDaysOfMonth = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]; 
	public flexshipFrequencyHasErrors:boolean;
	public loading:boolean;
	public flexshipFlow:FlexshipFlow;
	
    //@ngInject
    constructor( public monatService, public orderTemplateService,public publicService) {

    }
    
    public $onInit = () => { 
    	this.getFrequencyTermOptions();
    }
    
	public getFrequencyTermOptions = ():void =>{
		this.monatService.getOptions({'frequencyTermOptions': false }).then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
			this.publicService.model = {};
			for(let term of response.frequencyTermOptions){
				this.termMap[term.value] = term;
				if(term.name=='Monthly'){
					this.publicService.model.term = term;
				}
			}
		});
	}
	
	
    public setOrderTemplateFrequency = (frequencyTerm, dayOfMonth) => {
		this.loading = true;
		
    	if("string" == typeof(frequencyTerm)){
			frequencyTerm = this.termMap[frequencyTerm];
    	}

		if (
			'undefined' === typeof frequencyTerm
			|| 'undefined' === typeof dayOfMonth
		) {
			this.flexshipFrequencyHasErrors = true;
			return false;
		} else {
			this.flexshipFrequencyHasErrors = false;
		}
		
        
        let flexshipID = this.orderTemplateService.currentOrderTemplateID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, frequencyTerm.value, dayOfMonth).then(result => {
            this.flexshipFlow.next();
            this.loading = false;
        });
    }
}

class FrequencyStep {

	public restrict:string;
	public templateUrl:string;
	public require={
		flexshipFlow : '^flexshipFlow'
	}
	
	public bindToController = {
	
	};
	
	public controller = FrequencyStepController;
	public controllerAs = "frequencyStep";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			rbkeyService,
        ) => new FrequencyStep(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/frequencyStep.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	FrequencyStep
};

