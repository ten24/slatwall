/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddressFormPartialController{

	public address;
	public countryCodeOptions;
	public stateCodeOptions;

	constructor(public $hibachi,
				public observerService,
				public rbkeyService
	){

	}
	

}

class SWAddressFormPartial implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		address: "=",
		countryCodeOptions: "<",
		stateCodeOptions: "<"
	};
	public controller=SWAddressFormPartialController;
	public controllerAs="swAddressFormPartial";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    addressPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAddressFormPartial(
			addressPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'addressPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private addressPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(addressPartialsPath) + "/addressformpartial.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAddressFormPartial
};

