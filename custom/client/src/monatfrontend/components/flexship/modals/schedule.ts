import {MonatService,IOption} from '@Monat/services/monatservice';

class monatFlexshipScheduleModalController {
	public orderTemplate;  //injected
	public close; // injected from angularModalService
	
	//local-states
	public loading: boolean = false;
	public translations = {};

    public frequencyTermOptions: IOption[];
    public scheduleDateChangeReasonTypeOptions: IOption[];
    
    public endDayOfTheMonth = 25;
	public endDateString;
	public endDate;
	public startDate;
	public nextPlaceDateTime;
	public qualifiesSnapShot:boolean;
	public formData = {
		delayOrSkip : 'delay',
		otherReasonNotes: undefined,
		selectedFrequencyTermID: undefined,
        selectedReason: undefined,
	}; 
	
    

    //@ngInject
	constructor(
		public orderTemplateService, 
		public observerService, 
		public rbkeyService, 
		public monatService, 
		public monatAlertService
	) {
		
    }
    
    public $onInit = () => {
        this.loading = true;
    	this.makeTranslations();
    	this.calculateNextPlacedDateTime();
    	this.qualifiesSnapShot = this.orderTemplate.qualifiesForOFYProducts;
		this.monatService.getOptions({ 'frequencyTermOptions':false, 'scheduleDateChangeReasonTypeOptions':false})
		.then( (options) => {
			
			this.frequencyTermOptions = options.frequencyTermOptions;
			this.scheduleDateChangeReasonTypeOptions = options.scheduleDateChangeReasonTypeOptions;
			
			if(this.orderTemplate.frequencyTerm_termID) {
				this.formData.selectedFrequencyTermID = this.orderTemplate.frequencyTerm_termID;
			}
		})
		.catch( (error) => {
		    console.error(error);
		})
		.finally(()=>{
			this.loading = false;   
		});
		
		
    };
    
    private makeTranslations = () => {
    	
    	this.translations['delayOrSkip'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.delayOrSkip');
        //TODO business-logic
    	this.translations['delayOrSkipMessage'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.delayOrSkipMessage', { days : 15 });
    	this.translations['delayThisMonthsOrder'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.delayThisMonthsOrder');
    	this.translations['skipThisMonthsOrder'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.skipThisMonthsOrder');
		
    	this.translations['whyAreYouSkippingFlexship'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.whyAreYouSkippingFlexship');
    	this.translations['flexshipSkipOtherReason'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.flexshipSkipOtherReason');
    	this.translations['nextSkipOrderNextDeliveryDateMessage'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.nextSkipOrderNextDeliveryDateMessage');
						    
    	this.translations['orderFrequency'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.orderFrequency');
    	this.translations['flexshipFrequencyMessage'] = this.rbkeyService.rbKey('frontend.flexshipScheduleModal.flexshipFrequencyMessage');
    	
    }
    
    public updateSchedule() {
        this.loading = true;
    	let payload = {};
        payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	
    	if(this.formData.delayOrSkip === 'delay') {
    		payload['scheduleOrderNextPlaceDateTime'] = this.nextPlaceDateTime;
    	} else {
    		payload['skipNextMonthFlag'] = 1;
    	}
    	
    	payload['orderTemplateScheduleDateChangeReasonTypeID'] = this.formData.selectedReason.value;
    	if(this.formData.otherReasonNotes) {
		   	payload['otherScheduleDateChangeReasonNotes'] = this.formData['otherReasonNotes'];
    	}
    
    	payload['frequencyTermID'] = this.formData.selectedFrequencyTermID;
    
        this.orderTemplateService
        .updateOrderTemplateSchedule(
        	this.orderTemplateService.getFlattenObject(payload)
        )
        .then( (data) => {
        	if(data.orderTemplate) {
                this.orderTemplate = data.orderTemplate;
            	this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.updateSuccessful'));
            	if(data.successfulActions?.indexOf('public:order.deleteOrderTemplatePromoItem') > -1){
            		data.orderTemplate.qualifiesForOFYProducts = true;
            	}else{
            		data.orderTemplate.qualifiesForOFYProducts = this.qualifiesSnapShot;
            	}
                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
                this.closeModal();
        	} else {
        		throw(data);
        	} 
        })
        .catch( (error) => {
        	this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }

    private calculateNextPlacedDateTime = () => {
    	var date = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
    	//format mm/dd/yyyy
        this.nextPlaceDateTime = (date.getMonth() +1) + '/' + date.getDate() + '/' + date.getFullYear();
	    this.endDate = new Date(date.setMonth(date.getMonth()+2)); //next one month
    }
    
    public updateDelayOrSkip = (delayOrSkip:string) =>{
    	this.formData.delayOrSkip = delayOrSkip;
        var date = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
        var monthsToAdd = delayOrSkip === 'skip' ? 2 : 1;
        this.nextPlaceDateTime = (date.getMonth() + monthsToAdd) + '/' + date.getDate() + '/' + date.getFullYear();
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexship/modals/schedule.html";
		this.restrict = "E";
	}

}

export {
	MonatFlexshipScheduleModal
};
