/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountShippingAddressCardController{

	public accountShippingAddress;
	
	public accountAddressOptions;
	public shippingMethodOptions;
	public stateCodeOptions;
	
	public title:string="Shipping";
	
	//entity that account payment method will be set on
	public baseEntityName:string;
	public baseEntity;
	
	public defaultCountryCode:string;

	constructor(public $hibachi,
				public observerService,
				public rbkeyService
	){

	}
	

}

class SWAccountShippingAddressCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountAddressOptions: "<",
		accountShippingAddress:"<",
		baseEntityName:"@?",
		baseEntity:"<",
		defaultCountryCode: "@?",
		shippingMethodOptions: "<",
		stateCodeOptions: "<",
	    title:"@?"
	};
	public controller=SWAccountShippingAddressCardController;
	public controllerAs="swAccountShippingAddressCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAccountShippingAddressCard(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountshippingaddresscard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAccountShippingAddressCard
};

