/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateUpdateScheduleModalController{

    //objects
	public orderTemplate;

	public endDayOfTheMonth:number;
	public endDate:Date;
	public endDateString:string;
	
	public scheduleOrderNextPlaceDateTimeString:string;
	public scheduleOrderNextPlaceDateTime;
	
	public orderTemplateScheduleDateChangeReasonType;
	public orderTemplateScheduleDateChangeReasonTypeOptions;
	public otherScheduleDateChangeReasonNotes;
	
	public processContext:string = 'updateSchedule';
	
	public uniqueName:string = 'updateScheduleModal';
	public formName:string = 'updateScheduleModal';
	
	public form;
	
	//rb key properties
	public title:string = "Update Schedule";

	constructor( public $timeout,
	             public $hibachi,
	             public observerService,
	             public orderTemplateService,
				 public rbkeyService,
				 public requestService
	){
	}
	
	public $onInit = () =>{
		
	    if(this.scheduleOrderNextPlaceDateTimeString != null){
	        var date = Date.parse(this.scheduleOrderNextPlaceDateTimeString);
	        this.scheduleOrderNextPlaceDateTime = (date.getMonth() + 1) + '/' + date.getDate() + '/' +  date.getFullYear();
	    }
	    
	    if(this.endDateString != null){
	        this.endDate = Date.parse(this.endDateString);
	    }
	}
	
	public save = () =>{
		var formDataToPost:any = {
			entityID: this.orderTemplate.orderTemplateID,
			entityName: 'OrderTemplate',
			context: this.processContext,
			scheduleOrderNextPlaceDateTime: this.scheduleOrderNextPlaceDateTime,
			propertyIdentifiersList: 'orderTemplateID,scheduleOrderNextPlaceDateTime'
		};
		
		formDataToPost.orderTemplateScheduleDateChangeReasonTypeID = this.orderTemplateScheduleDateChangeReasonType.value;
		formDataToPost.orderTemplateID = this.orderTemplate.orderTemplateID;
		
		if( this.orderTemplateScheduleDateChangeReasonType.value === '2c9280846a023949016a029455f0000c' &&
			this.otherScheduleDateChangeReasonNotes.length
		){
			formDataToPost.otherScheduleDateChangeReasonNotes = this.otherScheduleDateChangeReasonNotes;
		}
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise;
	}
}

class SWOrderTemplateUpdateScheduleModal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		modalButtonText:"@?",
		orderTemplate:"<?",
		orderTemplateScheduleDateChangeReasonTypeOptions:"<?",
		scheduleOrderNextPlaceDateTimeString:"@?",
		scheduleOrderNextPlaceDateTime:"=?",
        endDayOfTheMonth:'<?',
        endDateString:'@?',
        endDate:'=?'
	};
	
	public controller=SWOrderTemplateUpdateScheduleModalController;
	public controllerAs="swOrderTemplateUpdateScheduleModal";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateUpdateScheduleModal(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateupdateschedulemodal.html";
		this.restrict = "EA";
	}


    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
}

export {
	SWOrderTemplateUpdateScheduleModal
};

