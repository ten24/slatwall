/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCustomerAccountCardController{

    public title:string="Customer Account";
    public fullNameTitle:string="Customer Account";
    public emailTitle:string="Customer Email";
    public phoneTitle:string="Customer Phone";
	public account;

	constructor(){

	}

}

class SWCustomerAccountCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	    title:"@?",
		account:"<"
	};
	public controller=SWCustomerAccountCardController;
	public controllerAs="swCustomerAccountCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    giftCardPartialsPath,
			slatwallPathBuilder
        ) => new SWCustomerAccountCard(
			giftCardPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
			'accountPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }

	constructor(private accountPartialsPath, private slatwallPathBuilder){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(accountPartialsPath) + "/customeraccountcard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWCustomerAccountCard
};

