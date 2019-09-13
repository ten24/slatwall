
class MonatFlexshipChangeOrSkipOrderModalController {
	public orderTemplate; 
	public scheduleDateChangeReasonTypeOptions;
	
	public formData = {
		selectedReason: '',
		otherReasonNotes: undefined,
		nextPlaceDateTime: new Date()
	}; 
	// payload :: {orderTemplateScheduleDateChangeReasonTypeID:'', otherScheduleDateChangeReasonNotes: '', nextPlaceDateTime: '' }

    constructor(public orderTemplateService, public observerService) {
    }
    
    public $onInit = () => {
    	console.log('flexship modal update schedule : ', this);
    };
    
    public updateSchedule() {

    	//TODO frontend validation
    	let payload = {};
    	payload['orderTemplateScheduleDateChangeReasonTypeID'] = this.formData.selectedReason.value;
    	
    	//HardCoded sysCode for "Other reason"
    	if(this.formData.selectedReason.sysCode === 'otsdcrtOther' && this.formData.otherReasonNotes) {
		   	payload['otherScheduleDateChangeReasonNotes'] = this.formData.otherReasonNotes;
    	}
    	payload['scheduleOrderNextPlaceDateTime'] = this.formData.nextPlaceDateTime;
    	
    	
    	payload = this.orderTemplateService.getFlattenObject(payload);
     	console.log('updateSchedule :'+JSON.stringify(payload));
     	
     	return;
    	// make api request
        this.orderTemplateService.updateSchedule(payload).then(
            (data) => {
            	if(angular.isDefined(data.orderTemplate)) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
            	} else {
            		console.error(JSON.stringify(data));
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

class MonatFlexshipChangeOrSkipOrderModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    scheduleDateChangeReasonTypeOptions:'<'
	};
	public controller=MonatFlexshipChangeOrSkipOrderModalController;
	public controllerAs="monatFlexshipChangeOrSkipOrderModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipChangeOrSkipOrderModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-changeorskiporder.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipChangeOrSkipOrderModal
};

