import {MonatService,IOption} from '../../services/monatservice';

class monatFlexshipScheduleModalController {
	public orderTemplate;  //injected
	public close; // injected from angularModalService
	
	//local-states
	public loading: boolean = false;
	
    public frequencyTermOptions: IOption[];
    public scheduleDateChangeReasonTypeOptions: IOption[];

    public selectedFrequencyTermID:string;
    public selectedReason;

    
    public endDayOfTheMonth = 25;
	public endDateString;
	public endDate;
	public startDate;
	public nextPlaceDateTime;

	public formData = {
		delayOrSkip : 'delay',
		showOtherReasonNotes: false,
	}; 
    

    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService, public monatService, public monatAlertService) {
    }
    
    public $onInit = () => {
        this.loading = true;
    	this.makeTranslations();
    	this.calculateNextPlacedDateTime();
    	
		this.monatService.getOptions({ 'frequencyTermOptions':false, 'scheduleDateChangeReasonTypeOptions':false})
		.then( (options) => {
			
			this.frequencyTermOptions = options.frequencyTermOptions;
			this.scheduleDateChangeReasonTypeOptions = options.scheduleDateChangeReasonTypeOptions;
			
			if(this.orderTemplate.frequencyTerm_termID) {
				this.selectedFrequencyTermID = this.orderTemplate.frequencyTerm_termID;
			}
			
		})
		.catch( (error) => {
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
    	
    	this.translations['changeOrSkip'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.changeOrSkip');
        //TODO business-logic
    	this.translations['delayOrSkipMessage'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.delayOrSkipMessage', { days : 15 });
    	this.translations['delayThisMonthsOrder'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.delayThisMonthsOrder');
    	this.translations['skipThisMonthsOrder'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.skipThisMonthsOrder');
    	this.translations['flexshipCancelReason'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.flexshipCancelReason');
    	this.translations['whyAreYouCancellingFlexship'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.whyAreYouCancellingFlexship');
    	this.translations['flexshipCancelOtherReason'] = this.rbkeyService.rbKey('frontend.delayOrSkipOrderModal.flexshipCancelOtherReason');

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
    
    public updateSchedule() {
        this.loading = true;
    	let payload = {};
        payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	payload['orderTemplateScheduleDateChangeReasonTypeID'] = this.selectedReason.value;
    	
    	if(this.formData.showOtherReasonNotes) {
		   	payload['otherScheduleDateChangeReasonNotes'] = this.formData['otherReasonNotes'];
    	}
    	
    	if(this.formData.delayOrSkip === 'delay') {
    		payload['scheduleOrderNextPlaceDateTime'] = this.nextPlaceDateTime;
    	} else {
    		payload['skipNextMonthFlag'] = 1;
    		
    	}
    	
    	payload = this.orderTemplateService.getFlattenObject(payload);

    	// make api request
        this.orderTemplateService.updateOrderTemplateSchedule(payload)
        .then( (data) => {
            	if(data.orderTemplate) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
	                this.monatAlertService.success("Your flexship has been updated successfully");
	                this.closeModal();
            	} else {
            		throw(data);
            	} 
            }
        )
        .catch( (error) => {
        	this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }

    
    private calculateNextPlacedDateTime = () => {
    	//format mm/dd/yyyy
    	var date = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
	    this.nextPlaceDateTime = `${(date.getMonth() + 1)}/${date.getDate()}/${date.getFullYear()}`;
	    this.endDayOfTheMonth = 25;
	    this.endDate = new Date(date.setMonth(date.getMonth()+2));
    }
    
    public updateDelayOrSkip = (val:string) =>{
        if(val==='skip'){
            var date = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
            this.nextPlaceDateTime = `${(date.getMonth() + 2)}/${date.getDate()}/${date.getFullYear()}`;
        }
        else{
            var date = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
           this.nextPlaceDateTime = `${(date.getMonth() + 1)}/${date.getDate()}/${date.getFullYear()}`;  
        }
    	this.formData.delayOrSkip = val;
    }
    
    public selectedReasonChanged = () => {
    	if(!!this.selectedReason && !!this.selectedReason.value) {
    		this.formData.showOtherReasonNotes = this.selectedReason.systemCode === 'otsdcrtOther';
    	} else {
	    	this.formData.showOtherReasonNotes = false;
    		//TODO disable the form
    	}
    }
    
    public closeModal = () => {
     	this.close(null);
    };
}

class MonatFlexshipScheduleModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=monatFlexshipScheduleModalController;
	public controllerAs="monatFlexshipScheduleModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipScheduleModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexship/modal-schedule.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipScheduleModal
};
