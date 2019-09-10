class MonatFlexshipMenuController{
    
 //   public orderTemplate;
 //   public accountAddresses;
	// public accountPaymentMethods;
	public shippingMethodOptions:any[];
	
	constructor( public orderTemplateService
	){

	}
	
	public $onInit = () =>{
		console.log('sm', this.shippingMethodOptions);
	}

}

class MonatFlexshipMenu{

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    accountAddresses:'<',
	    accountPaymentMethods:'<',
	    shippingMethodOptions: '<',
	    stateCodeOptions: '<'
	};
	public controller=MonatFlexshipMenuController;
	public controllerAs="monatFlexshipMenu";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipMenu(
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'$hibachi',
			'rbkeyService',
			'requestService'
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexshipmenu.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipMenu
};

