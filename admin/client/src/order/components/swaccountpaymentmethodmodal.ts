/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountPaymentMethodModalController{

	public accountPaymentMethod;
	
	//Order or Order Template
	public baseEntityName;
	public baseEntity;
	
	public title:string="Edit Billing Information";
	public uniqueName:string = 'accountPaymentMethodModal';
	public formName:string = 'accountPaymentMethodModal';
	
	public swCustomerAccountPaymentMethodCard;

	constructor(public $hibachi,
				public rbkeyService
	){

	    console.log('customerAccountCard', this.swCustomerAccountPaymentMethodCard);

		if(this.swCustomerAccountPaymentMethodCard != null){
			
			this.baseEntityName = this.swCustomerAccountPaymentMethodCard.baseEntityName;
			this.baseEntity = this.swCustomerAccountPaymentMethodCard.baseEntity;
			
			if(this.swCustomerAccountPaymentMethodCard.accountPaymentMethod != null){
				this.accountPaymentMethod = this.swCustomerAccountPaymentMethodCard.accountPaymentMethod;
			}
			
		}
	}
}

class SWAccountPaymentMethodModal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountPaymentMethod:"<?",
		baseEntityName:"@?",
		baseEntity:"<?",
	    title:"@?"
	};
	public require = {
		swCustomerAccountPaymentMethodCard:"^?swCustomerAccountPaymentMethodCard"
	};
	
	public controller=SWAccountPaymentMethodModalController;
	public controllerAs="swAccountPaymentMethodModal";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAccountPaymentMethodModal(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountpaymentmethodmodal.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAccountPaymentMethodModal
};

