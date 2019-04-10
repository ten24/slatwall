class SWFlexshipSurveyModalController{

	public title:string="Flexship Survey";
	
	public orderTemplate;
	public surveyOptions;
	public surveyResponse;
	public otherScheduleDateChangeReasonNotes;
	
	public processContext="Create"

	constructor( public $hibachi,
				 public requestService
	){
		console.log('surveyOptions', this.surveyOptions);
	}

	public save = () =>{
		var formDataToPost:any = {
			entityName: 'FlexshipSurveyResponse',
			context: this.processContext,
			propertyIdentifiersList: ''
		};
		
		formDataToPost.orderTemplateScheduleDateChangeReasonTypeID = this.surveyResponse.value;
		formDataToPost.orderTemplateID = this.orderTemplate.orderTemplateID;
		
		if( this.surveyResponse.value === '2c9280846a023949016a029455f0000c' &&
			this.otherScheduleDateChangeReasonNotes.length
		){
			formDataToPost.otherScheduleDateChangeReasonNotes = this.otherScheduleDateChangeReasonNotes;
		}
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise;
	}
}

class SWFlexshipSurveyModal {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		'orderTemplate':'<?',
		'surveyOptions':'<?'
	};
	public controller=SWFlexshipSurveyModalController;
	public controllerAs="swFlexshipSurveyModal";

	public static Factory(){
        var directive:any = (
		    monatBasePath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWFlexshipSurveyModal(
			monatBasePath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'monatBasePath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private monatBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatBasePath + "/monatadmin/components/flexshipsurveymodal.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	SWFlexshipSurveyModal
};

