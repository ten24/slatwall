/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateAddPromotionModalController{
    
    public orderTemplate;
    public baseEntityPrimaryID:string;
    public baseEntityName:string;
    public processContext:string='addPromotionCode';
    public promotionCode:string;
    public title='Add Promotion';
    public modalButtonText='Add Promotion';

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
	            public requestService,
				public rbkeyService
	){
        this.observerService.attach(this.$onInit, 'OrderTemplateAddPromotionCodeSuccess');
	}
	
	public $onInit = () =>{
	    this.promotionCode = '';
	    if(this.orderTemplate != null){
            this.baseEntityPrimaryID = this.orderTemplate.orderTemplateID;
            this.baseEntityName = 'OrderTemplate';
	    }
	}
	
	public save = () =>{
	    var formDataToPost:any = {
			entityID: this.baseEntityPrimaryID,
			entityName: this.baseEntityName,
			context: this.processContext,
			propertyIdentifiersList: ''
		};
		
		formDataToPost.promotionCode = this.promotionCode;
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise;
	}
}

class SWOrderTemplateAddPromotionModal implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        orderTemplate: '<?'
	};
	public controller=SWOrderTemplateAddPromotionModalController;
	public controllerAs="swOrderTemplatePromotions";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateAddPromotionModal(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateaddpromotionmodal.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateAddPromotionModal
};

