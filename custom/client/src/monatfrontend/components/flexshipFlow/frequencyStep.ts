
class FrequencyStepController {
	public orderTemplate;
	public frequencyTerms;
	public termMap = {};
	public flexshipDaysOfMonth = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]; 
	public flexshipFrequencyHasErrors:boolean;
	public loading:boolean;
	public day:number;
	public term;
	
    //@ngInject
    constructor( public monatService, public orderTemplateService,public publicService, public $scope) {

    }
    
    public $onInit = () => { 
    	this.getFrequencyTermOptions();
    }
    
	public getFrequencyTermOptions = ():void =>{
		this.monatService.getOptions({'frequencyTermOptions': false }).then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
			this.term = this.frequencyTerms[0];
			this.day = this.flexshipDaysOfMonth[0];
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
        let flexshipID = this.orderTemplateService.currentOrderTemplateID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, this.term.value, this.day).then(result => {
            this.loading = false;
            this.$scope.$parent.flexshipFlow.next();
        });
    }
}

class FrequencyStep {

	public restrict:string;
	public templateUrl:string;
	public require={
		flexshipFlow : '^flexshipFlow'
	}
	
	public controller = FrequencyStepController;
	public controllerAs = "frequencyStep";
	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			rbkeyService,
        ) => new FrequencyStep(monatFrontendBasePath);
        directive.$inject = [
			'monatFrontendBasePath',
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/frequencyStep.html";
		this.restrict = "E";
	}

}

export {
	FrequencyStep
};

