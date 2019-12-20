
class MonatFlexshipCancelModalController {
	public orderTemplate; 
	public cancellationReasonTypeOptions: any[];
	public close; // injected from angularModalService
	
	public formData = {}; // {typeID:'', typeIDOther: '' }
	
	public loading = false;
	
    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService, public monatAlertService) {
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	 this.translations['whyAreYouCancelling'] = this.rbkeyService.rbKey('frontend.cancelFlexshipModal.whyAreYouCancelling');
    	 this.translations['flexshipCancelReason'] = this.rbkeyService.rbKey('frontend.cancelFlexshipModal.flexshipCancelReason');
    	 this.translations['flexshipCancelOtherReasonNotes'] = this.rbkeyService.rbKey('frontend.cancelFlexshipModal.flexshipCancelOtherReasonNotes');
    }
    
    public cancelFlexship() {
<<<<<<< HEAD

		this.loading=true;
=======
>>>>>>> parent of 6c432edd0e... Revert "Merge pull request #1221 from ten24/develop-team-sr-validationerror"
    	// make api request
        this.orderTemplateService.cancelOrderTemplate(
        	this.orderTemplate.orderTemplateID, 
	        this.formData['orderTemplateCancellationReasonType'], 
	        this.formData['orderTemplateCancellationReasonTypeOther'] 
	    )
	    .then(
            (data) => {
            	if(data && data.orderTemplate) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
	                this.closeModal();
            	} else {
            		throw(data);	
            	}
            }
        )
        .catch( (error) => {
    		this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally(() => {
        	this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null); // close, but give 100ms to animate
    };
}

class MonatFlexshipCancelModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    cancellationReasonTypeOptions:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipCancelModalController;
	public controllerAs="monatFlexshipCancelModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipCancelModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-cancel.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipCancelModal
};

