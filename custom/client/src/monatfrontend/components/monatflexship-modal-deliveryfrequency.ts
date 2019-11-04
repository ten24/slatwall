
class monatFlexshipFrequencyModalController {
	public orderTemplate; 
	public close; // injected from angularModalService
	public loading: boolean = false;
    public frequencyTerms:any;
	public orderTemplateName;

    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService, public publicService) {
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    	this.orderTemplateName = this.orderTemplate.orderTemplateName;
		this.publicService.doAction('getFrequencyTermOptions').then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
		})
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	 this.translations['flexshiFrequency'] = this.rbkeyService.rbKey('frontend.flexshipEdit.flexshipFrequency');
    }
    
    public saveFlexshipName() {

    	//TODO frontend validation
		this.loading = true;
		
    	// make api request
        this.orderTemplateService.editOrderTemplate(
        	this.orderTemplate.orderTemplateID, 
        	this.orderTemplateName, 
	    ).then(data => {
        	if(data.orderTemplate) {
                this.orderTemplate = data.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
                this.closeModal();
        	} else {
        		throw(data);
        	}
        }).catch(error => {
            console.error(error);
            // TODO: show alert / handle error
        }).finally(() => {
        	this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null); // close, but give 100ms to animate
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

