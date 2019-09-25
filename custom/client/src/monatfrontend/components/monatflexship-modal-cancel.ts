
class MonatFlexshipCancelModalController {
	public orderTemplate; 
	public cancellationReasonTypeOptions: any[];
	
	public formData = {}; // {typeID:'', typeIDOther: '' }

	constructor(public orderTemplateService, public observerService) {
    }
    
    public $onInit = () => {
    };
    
    public cancelFlexship() {

    	//TODO frontend validation

    	// make api request
        this.orderTemplateService.cancelOrderTemplate(
        	this.orderTemplate.orderTemplateID, 
	        this.formData['typeID'], 
	        this.formData['typeIDOther'] 
	    ).then(
            (data) => {
            	if(data.orderTemplate) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
            	} else {
            		console.error(data);
            		//TODO handle errors
            	}
            	// TODO: show alert
            }, 
            (reason) => {
                throw (reason);
                // TODO: show alert
            }
        );
    }
}

class MonatFlexshipCancelModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    cancellationReasonTypeOptions:'<'
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

