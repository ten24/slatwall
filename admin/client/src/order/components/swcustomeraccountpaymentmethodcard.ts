/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCustomerAccountPaymentMethodCardController{

	public accountPaymentMethod;
	public title:string="Billing";
	
	//entity that account payment method will be set on
	public baseEntityName:string;
	public baseEntity;
	
	constructor(public $hibachi,
				public rbkeyService
	){

	}
}

class SWCustomerAccountPaymentMethodCard implements ng.IDirective {


	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountPaymentMethod:"<",
		baseEntityName:"@?",
		baseEntity:"<",
	    title:"@?"
	};

	
	public controller=SWCustomerAccountPaymentMethodCardController;
	public controllerAs="swCustomerAccountPaymentMethodCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWCustomerAccountPaymentMethodCard(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/customeraccountpaymentmethodcard.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWCustomerAccountPaymentMethodCard
};

