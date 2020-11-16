/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplatePromotionsController{

    public promotionCodeCollection;
    
    public edit:boolean=false;
    
    public orderTemplate;
    
    public skuColumns; 

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){

	}
	
	public $onInit = () =>{
	    this.promotionCodeCollection = this.collectionConfigService.newCollectionConfig('PromotionCode');
	    this.promotionCodeCollection.addFilter('orderTemplates.orderTemplateID', this.orderTemplate.orderTemplateID, '=', undefined, true);
	}
}

class SWOrderTemplatePromotions implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        orderTemplate: '<?'
	};
	public controller=SWOrderTemplatePromotionsController;
	public controllerAs="swOrderTemplatePromotions";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplatePromotions(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatepromotions.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplatePromotions
};

