
class MonatFlexshipNameModalController {
	public orderTemplate; 
	public close; // injected from angularModalService
	public loading: boolean = false;

	public orderTemplateName;

    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService, public monatAlertService) {
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    	this.orderTemplateName = this.orderTemplate.orderTemplateName;
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	 this.translations['flexshipName'] = this.rbkeyService.rbKey('frontend.nameFlexshipModal.flexshipName');
    }
    
    public saveFlexshipName() {

    	//TODO frontend validation
		this.loading = true;
		
    	// make api request
        this.orderTemplateService.editOrderTemplate(
        	this.orderTemplate.orderTemplateID, 
        	this.orderTemplateName, 
	    ).then( (data) => {
        	if(data.orderTemplate) {
                this.orderTemplate = data.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
                this.monatAlertService.success("Your flexship's name has been updated successfully");
                this.closeModal();
        	} else {
        		throw(data);
        	}
        })
        .catch( (error) => {
            console.error(error);
            this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally( () => {
        	this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null);
    };
}

class MonatFlexshipNameModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipNameModalController;
	public controllerAs="monatFlexshipNameModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipNameModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexship/modals/name.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipNameModal
};

