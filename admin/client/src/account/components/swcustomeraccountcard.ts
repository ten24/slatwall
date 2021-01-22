/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCustomerAccountCardController{

	public account;
	
	public detailAccountLink:string;
	
    public title:string="Customer Account";
    public fullNameTitle:string="Customer Account";
    public emailTitle:string="Customer Email";
    public phoneTitle:string="Customer Phone";

	public baseEntityName:string;
	public baseEntity; 
	public baseEntityPropertiesToDisplayList;
	public baseEntityPropertiesToDisplay=[]; 

	public baseEntityRbKeys = {}; 

	constructor(public $hibachi,
				public rbkeyService
	){
		this.fullNameTitle = rbkeyService.rbKey('entity.account.calculatedFullName');
		this.emailTitle = rbkeyService.rbKey('entity.AccountEmailAddress.emailAddress');
		this.phoneTitle = rbkeyService.rbKey('entity.AccountPhoneNumber.phoneNumber');
		
		this.detailAccountLink = $hibachi.buildUrl('admin:entity.detailaccount','accountID=' + this.account.accountID);
		
	
		if(this.baseEntityPropertiesToDisplayList != null){
			this.baseEntityPropertiesToDisplay = this.baseEntityPropertiesToDisplayList.replace('.','_').split(',');
			
			for(var i=0; i<this.baseEntityPropertiesToDisplay.length; i++){
				this.baseEntityRbKeys[this.baseEntityPropertiesToDisplay[i]] = this.$hibachi.getRBKeyFromPropertyIdentifier(this.baseEntityName, this.baseEntityPropertiesToDisplay[i]);
			}
		}
	}

}

class SWCustomerAccountCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		account:"<",
		baseEntityName:"@?",
		baseEntity:"<?",
		baseEntityPropertiesToDisplayList:"@?",
	    title:"@?"
	};
	public controller=SWCustomerAccountCardController;
	public controllerAs="swCustomerAccountCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    accountPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWCustomerAccountCard(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(accountPartialsPath) + "/customeraccountcard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWCustomerAccountCard
};

