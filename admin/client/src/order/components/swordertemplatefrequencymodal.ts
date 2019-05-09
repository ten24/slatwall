/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateFrequencyModalController{

    //objects
	public orderTemplate;
	public frequencyTermOptions;
		
	public swOrderTemplateFrequencyCard;
	
	public processContext:string = 'updateFrequency';
	
	public uniqueName:string = 'frequencyModal';
	public formName:string = 'frequencyModal';
	
	public form;
	
	//rb key properties
	public title:string = "Update Frequency";

	constructor( public $timeout,
	             public $hibachi,
	             public entityService,
	             public observerService,
	             public orderTemplateService,
				 public rbkeyService,
				 public requestService
	){
		
	}
	
	public $onInit = () =>{
	
		this.orderTemplate = this.swOrderTemplateFrequencyCard.orderTemplate;
		this.frequencyTermOptions = this.swOrderTemplateFrequencyCard.frequencyTermOptions;
		
		if(this.swOrderTemplateFrequencyCard.frequencyTerm != null){
			
			for(var i=0; i<this.frequencyTermOptions.length; i++){
				if(this.swOrderTemplateFrequencyCard.frequencyTerm.termID === this.frequencyTermOptions[i].value){
					this.orderTemplate.frequencyTerm = this.frequencyTermOptions[i];
					break;
				}
			}
			
		} else {
			this.orderTemplate.frequencyTerm = this.frequencyTermOptions[0];
		}
	}
	
	public save = () =>{
		var formDataToPost:any = {
			entityID: this.orderTemplate.orderTemplateID,
			entityName: 'OrderTemplate',
			context: this.processContext,
			propertyIdentifiersList: 'frequencyTerm'
		};
		
		formDataToPost.frequencyTerm = this.orderTemplate.frequencyTerm;
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise;
	}
}

class SWOrderTemplateFrequencyModal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		modalButtonText:"@?"
	};
	public require = {
		swOrderTemplateFrequencyCard:"^^swOrderTemplateFrequencyCard"
	};
	
	public controller=SWOrderTemplateFrequencyModalController;
	public controllerAs="swOrderTemplateFrequencyModal";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateFrequencyModal(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatefrequencymodal.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateFrequencyModal
};

