
class MonatFlexshipChangeOrSkipOrderModalController {
	public orderTemplate; 
	public scheduleDateChangeReasonTypeOptions;
	
	public endDayOfTheMonth = 25;
	public endDate;
	public nextPlaceDateTime;
	
	public formData = {
		delayOrSkip : 'delay',
		showOtherReasonNotes: false,
	}; 
	
	public selectedReason;
	// payload :: {orderTemplateScheduleDateChangeReasonTypeID:'', otherScheduleDateChangeReasonNotes: '', nextPlaceDateTime: '' }

    constructor(public orderTemplateService, public observerService) {
    }
    
    public $onInit = () => {
    	console.log('flexship modal update schedule : ', this);
    	this.calculateNextPlacedDateTime();
    };
    
    
    private calculateNextPlacedDateTime = () => {
    	//format mm/dd/yyyy
    	var date = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
	    this.nextPlaceDateTime = (date.getMonth() + 1) + '/' + date.getDate() + '/' +  date.getFullYear();
	    this.endDayOfTheMonth = 25;
	    this.endDate = new Date((date.getMonth() + 1 +3) + '/' + date.getDate() + '/' +  date.getFullYear());
    }
    
    public updateDelayOrSkip = (val:string) =>{
    	this.formData.delayOrSkip = val;
    }
    
    public selectedReasonChanged = () => {
    	console.log('reason changed ', this.selectedReason);
    	if(!!this.selectedReason && !!this.selectedReason.value) {
    		this.formData.showOtherReasonNotes = this.selectedReason.systemCode === 'otsdcrtOther';
    	} else {
	    	this.formData.showOtherReasonNotes = false;
    		//disable form
    	}
    }
    
    public updateSchedule() {

    	//TODO frontend validation
    	let payload = {};
        payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	payload['orderTemplateScheduleDateChangeReasonTypeID'] = this.selectedReason.value;
    	
    	//HardCoded sysCode for "Other reason"
    	if(this.formData.showOtherReasonNotes) {
		   	payload['otherScheduleDateChangeReasonNotes'] = this.formData['otherReasonNotes'];
    	}
    	
    	if(this.formData.delayOrSkip === 'delay') {
    		payload['scheduleOrderNextPlaceDateTime'] = this.nextPlaceDateTime;
    	} else {
    		payload['skipMontFlag'] = true;
    	}
    	
    	
    	payload = this.orderTemplateService.getFlattenObject(payload);
     	console.log('updateSchedule :', payload);
     	
     	return;
    	// make api request
        this.orderTemplateService.updateSchedule(payload).then(
            (data) => {
            	if(data.orderTemplate) {
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

