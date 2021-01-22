/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateGiftCardsController{

	public customerGiftCards;

    public giftCardCollection;
    
    public edit:boolean=false;
    
    public orderTemplate;

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){

	}
	
	public $onInit = () =>{
	    this.giftCardCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateAppliedGiftCard');
	    this.giftCardCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID, '=', undefined, true);
		this.giftCardCollection.setDisplayProperties('giftCard.giftCardCode,giftCard.calculatedBalanceAmount,amountToApply','',{isVisible:true,isSearchable:true,isDeletable:true,isEditable:false});

		this.giftCardCollection.addDisplayProperty('orderTemplateAppliedGiftCardID','',{isVisible:false,isSearchable:false,isDeletable:true,isEditable:false})
		
	}
}

class SWOrderTemplateGiftCards implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        orderTemplate: '<?',
        customerGiftCards: '<?'
	};
	public controller=SWOrderTemplateGiftCardsController;
	public controllerAs="swOrderTemplateGiftCards";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateGiftCards(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplategiftcards.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateGiftCards
};

