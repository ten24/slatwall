
class MonatFlexshipCancelModalController {
	public orderTemplate; 
	public cancellationReasonTypeOptions: any[];
	
	public formData = {}; // {typeID:'', typeIDOther: '' }

	constructor(public orderTemplateService, public observerService) {
    }
    public $onInit = () => {
    	console.log('flexship menue item cancel: ', this);
    };
    
    public cancelOrdertemplate = () => {
    	console.log("cancelling order template : "+this.orderTemplate);
    	let payload = {'orderTemplateCancellationReasonType' : this.formData};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
     	console.log(this.orderTemplateService.getFlattenObject(payload));
    }
    
    public cancelFlexship() {
    	console.log("cancelling order template : "+this.orderTemplate);
    	
    	let payload = {'orderTemplateCancellationReasonType' : this.formData};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	payload = this.orderTemplateService.getFlattenObject(payload);

     	console.log(payload);
    	// make api request
        this.orderTemplateService.cancel(payload).then(
            (response) => {
                this.orderTemplate = response.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
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

