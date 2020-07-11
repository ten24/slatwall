
class MonatFlexshipCancelModalController {
	public orderTemplate; 
	public cancellationReasonTypeOptions: any[];
	public close; // injected from angularModalService
	
	public formData = {}
	
	public loading = false;
    //@ngInject
	constructor(
		public orderTemplateService, 
		public observerService, 
		public rbkeyService, 
		public monatAlertService,
		private monatService,
	) {
    }
    
    public $onInit = () => {
    	this.loading=true;
    	this.makeTranslations();
    	this.monatService.getOptions({ 'cancellationReasonTypeOptions':false})
		.then( (options) => {
			this.cancellationReasonTypeOptions = options.cancellationReasonTypeOptions;
		})
		.catch( (error) => {
		    console.error(error);
		})
		.finally(()=>{
			this.loading = false;   
		});
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	 this.translations['whyAreYouCancelling'] = this.rbkeyService.rbKey('frontend.cancelFlexshipModal.whyAreYouCancelling');
    	 this.translations['flexshipCancelReason'] = this.rbkeyService.rbKey('frontend.cancelFlexshipModal.flexshipCancelReason');
    	 this.translations['flexshipCancelOtherReasonNotes'] = this.rbkeyService.rbKey('frontend.cancelFlexshipModal.flexshipCancelOtherReasonNotes');
    }
    

    public cancelFlexship() {
		this.loading=true;
        this.orderTemplateService.cancelOrderTemplate(
        	this.orderTemplate.orderTemplateID, 
	        this.formData['orderTemplateCancellationReasonType'].value, 
	        this.formData['orderTemplateCancellationReasonTypeOther'] 
	    )
	    .then(
            (data) => {
            	if(data && data.orderTemplate) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
	                this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.canceledSuccessful'));
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

	public restrict = 'E';
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipCancelModalController;
	public controllerAs="monatFlexshipCancelModal";

	public template = require('./cancel.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipCancelModal
};
