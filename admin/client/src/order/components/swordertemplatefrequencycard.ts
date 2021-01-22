/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateFrequencyCardController{

	public orderTemplate;
    public frequencyTerm;
    public frequencyTermOptions;
    
    public includeModal=true;

	constructor(public $hibachi,
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){
		this.observerService.attach(this.refreshFrequencyTerm,'OrderTemplateUpdateFrequencySuccess')
	
		if(this.orderTemplate['orderTemplateStatusType_systemCode'] === 'otstCancelled'){
			this.includeModal = false;
		}
	}

	public refreshFrequencyTerm = (data) =>{
		this.frequencyTerm = data.frequencyTerm;
	}
}

class SWOrderTemplateFrequencyCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		orderTemplate:'<',
        frequencyTerm:'<?',
        frequencyTermOptions:'<'
	};
	public controller=SWOrderTemplateFrequencyCardController;
	public controllerAs="swOrderTemplateFrequencyCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateFrequencyCard(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatefrequencycard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateFrequencyCard
};

