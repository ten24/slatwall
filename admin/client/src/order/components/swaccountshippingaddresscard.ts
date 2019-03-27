/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountShippingAddressCardController{

	public accountShippingAddress;
	public title:string="Shipping";
	
	//entity that account payment method will be set on
	public baseEntityName:string;
	public baseEntity;

	constructor(public $hibachi,
				public rbkeyService
	){

		
	}
}

class SWAccountShippingAddressCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountShippingAddress:"<",
		baseEntityName:"@?",
		baseEntity:"<",
	    title:"@?"
	};
	public controller=SWAccountShippingAddressCardController;
	public controllerAs="swAccountShippingAddressCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    accountPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAccountShippingAddressCard(
			accountPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'accountPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private accountPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(accountPartialsPath) + "/customeraccountpaymentmethodcard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAccountShippingAddressCard
};

