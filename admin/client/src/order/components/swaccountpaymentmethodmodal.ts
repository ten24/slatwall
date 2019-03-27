/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountPaymentMethodModalController{

	public accountPaymentMethod;
	
	//Order or Order Template
	public baseEntityName;
	public baseEntity;
	public baseEntityPrimaryID:string;
		
	public swCustomerAccountPaymentMethodCard;
	
	public title:string="Edit Billing Information";
	public uniqueName:string = 'accountPaymentMethodModal';
	public formName:string = 'accountPaymentMethodModal';
	
	public newAccountAddress;
	public newAccountPaymentMethod;
	
	public showCreateBillingAddress:boolean=false; 
	public showCreateAccountPaymentMethod:boolean=false;
	
	public createBillingAddressTitle:string = 'Add a new address';
	public createAccountPaymentMethodTitle:string = 'Add a new payment method';

	constructor( public $timeout,
	             public $hibachi,
	             public entityService,
				 public rbkeyService
	){
		
	}
	
	public $onInit = () =>{
	    if(this.swCustomerAccountPaymentMethodCard != null){
			
			this.baseEntityName = this.swCustomerAccountPaymentMethodCard.baseEntityName;
			this.baseEntityPrimaryID = this.swCustomerAccountPaymentMethodCard.baseEntity[this.baseEntityName + 'ID'];
			
			this.baseEntity = this.entityService.loadEntity( this.baseEntityName,
			                                                 this.baseEntityPrimaryID,
			                                                 this.swCustomerAccountPaymentMethodCard.baseEntity);
			
			if(this.swCustomerAccountPaymentMethodCard.accountPaymentMethod != null){
				this.accountPaymentMethod = this.swCustomerAccountPaymentMethodCard.accountPaymentMethod;
			}
			
		}
	}
	
	public toggleCreateBillingAddress = () =>{
	    if(this.newAccountAddress == null){
	        this.newAccountAddress = this.entityService.newEntity('AccountAddress');
	        this.newAccountAddress.data.address = this.entityService.newEntity('Address');
	    }
	}
	
	public toggleCreateAccountPaymentMethod = () =>{
	    if(this.newAccountPaymentMethod == null){
	        this.newAccountPaymentMethod = this.entityService.newEntity('AccountPaymentMethod');
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
	    title:"@?",
	    createBillingAddressTitle:"@?",
	    createAccountPaymentMethodTitle:"@?"
	};
	public require = {
		swCustomerAccountPaymentMethodCard:"^^swCustomerAccountPaymentMethodCard"
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

