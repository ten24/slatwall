class MonatFlexshipListingController{
    
    public orderTemplates: any[];
    public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public stateCodeOptions: any[];
	constructor( public orderTemplateService
	){

	}
	
	public $onInit = () => {
	    this.orderTemplateService.getOrderTemplates()
	    .then(
	    	(data) => {
	            this.orderTemplates = data.orderTemplates; 
	            this.accountAddresses = data.accountAddresses;
	            this.accountPaymentMethods = data.accountPaymentMethods;
	            this.stateCodeOptions = data.stateCodeOptions;
 	        },
	        (reason) => {
	            console.error(reason);
	        }
	    );
	}

}

class MonatFlexshipListing {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	};
	public controller=MonatFlexshipListingController;
	public controllerAs="monatFlexshipListing";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipListing (
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexshiplisting.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipListing
};

