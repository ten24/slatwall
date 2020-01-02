class monatFlexshipFrequencyModalController {
	public orderTemplate; 
	public close; // injected from angularModalService
	public loading: boolean = false;
    public frequencyTermOptions:any;
    public selectedFrequencyTermID:string;

    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService, public publicService, public monatAlertService) {
    }
    
    public $onInit = () => {
        this.loading = true;
    	this.makeTranslations();
		this.publicService.doAction('getFrequencyTermOptions').then(response => {
			if(this.orderTemplate.frequencyTerm_termID) {
			this.selectedFrequencyTermID = this.orderTemplate.frequencyTerm_termID;
			}
			this.frequencyTermOptions = response.frequencyTermOptions;
			
		})
		.catch((error)=>{
		    console.error(error);
		})
		.finally(()=>{
		 this.loading = false;   
		})
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	 this.translations['flexshiFrequency'] = this.rbkeyService.rbKey('frontend.flexshipEdit.flexshipFrequency');
    }
    
    public setOrderTemplateFrequency() {
		this.loading = true;
        this.orderTemplateService.updateOrderTemplateFrequency(
            this.orderTemplate.orderTemplateID, 
            this.selectedFrequencyTermID, 
            this.orderTemplate.scheduleOrderDayOfTheMonth
        )
        .then( (data) => {
        	if(data.successfulActions.length && (data.successfulActions[0] == 'public:orderTemplate.updateFrequency' || data.successfulActions[1] == 'public:orderTemplate.updateFrequency') ) {
                this.observerService.notify("orderTemplateUpdated" + " " + this.orderTemplate.orderTemplateID);
            	this.monatAlertService.success("Your flexship has been updated successfully");
                this.closeModal();
        	} else {
        		throw(data);
        	}
        }).catch( (error) => {
	        this.monatAlertService.showErrorsFromResponse(error);
        }).finally(() => {
        	this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null);
    };
}

class MonatFlexshipFrequencyModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=monatFlexshipFrequencyModalController;
	public controllerAs="monatFlexshipFrequencyModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipFrequencyModal(
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

	//@ngInject
	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-deliveryfrequency.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipFrequencyModal
};
