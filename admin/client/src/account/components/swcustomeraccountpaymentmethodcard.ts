/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCustomerAccountPaymentMethodCardController{

	public accountPaymentMethod;
	public title:string="Billing";


	constructor(public $hibachi,
				public rbkeyService
	){

		
	}
}

class SWCustomerAccountPaymentMethodCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountPaymentMethod:"<",
	    title:"@?"
	};
	public controller=SWCustomerAccountPaymentMethodCardController;
	public controllerAs="swCustomerAccountCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    accountPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWCustomerAccountPaymentMethodCard(
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
	SWCustomerAccountPaymentMethodCard
};

