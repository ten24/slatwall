/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateAddGiftCardModalController{
    
    public orderTemplate;
    public baseEntityPrimaryID:string;
    public baseEntityName:string;
    public processContext:string='applyGiftCard';
    public promotionCode:string;
    public title='Apply Gift Card';
    public modalButtonText='Apply Gift Card';
    
    public swOrderTemplateGiftCards;
    
    public customerGiftCards:any;
    
    public giftCard:any;
    public amountToApply:number=0
    public maxAmount:number=0;
    
    public currencyFilter:any;

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
	            public requestService,
				public rbkeyService,
				public $filter
	){
		this.currencyFilter = this.$filter('swcurrency');
        this.observerService.attach(this.$onInit, 'OrderTemplateApplyGiftCardSuccess');
	}
	
	public $onInit = () =>{
	    if(this.orderTemplate != null){
            this.baseEntityPrimaryID = this.orderTemplate.orderTemplateID;
            this.baseEntityName = 'OrderTemplate';
	    }
	    
	    if(this.swOrderTemplateGiftCards != null && this.swOrderTemplateGiftCards.customerGiftCards != null){
	    	this.customerGiftCards = this.swOrderTemplateGiftCards.customerGiftCards;
	    	this.giftCard = this.customerGiftCards[0];
	    }
	}
	
	public prefillGiftCardAmount = () =>{
		if(this.orderTemplate.total < this.giftCard.calculatedBalanceAmount){
			this.amountToApply = this.orderTemplate.total; 	
		} else { 
			this.amountToApply = this.giftCard.calculatedBalanceAmount;
		}
		
		this.maxAmount = Number(this.amountToApply);
		
		this.amountToApply = Number(this.amountToApply);
	}
	
	public save = () =>{
	    var formDataToPost:any = {
			entityID: this.baseEntityPrimaryID,
			entityName: this.baseEntityName,
			context: this.processContext,
			propertyIdentifiersList: ''
		};
		
		formDataToPost.giftCardID = this.giftCard.value;
		formDataToPost.amountToApply = this.amountToApply;
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise;
	}
}

class SWOrderTemplateAddGiftCardModal implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        orderTemplate: '<?'
	};
	public require = {
		swOrderTemplateGiftCards:"^^swOrderTemplateGiftCards"
	}
	public controller=SWOrderTemplateAddGiftCardModalController;
	public controllerAs="swOrderTemplateAddGiftCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateAddGiftCardModal(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateaddgiftcardmodal.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateAddGiftCardModal
};

