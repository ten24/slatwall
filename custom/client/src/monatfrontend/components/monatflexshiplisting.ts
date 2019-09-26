class MonatFlexshipListingController{
    
    public orderTemplates: any[];
    public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public stateCodeOptions: any[];
	public shippingMethodOptions: any[];
	public cancellationReasonTypeOptions: any[];
	public scheduleDateChangeReasonTypeOptions: any[];
	public expirationMonthOptions: any[];
	public expirationYearOptions: any[];
	
	public initialized=false; 
	
    //@ngInject
	constructor( public orderTemplateService){
		
	}
	
	public $onInit = () => {
	    this.orderTemplateService.getOrderTemplates()
	    .then( (data) => {
	            this.accountAddresses = data.accountAddresses;
	            this.accountPaymentMethods = data.accountPaymentMethods;
	            this.shippingMethodOptions = data.shippingMethodOptions;
	            this.stateCodeOptions = data.stateCodeOptions;
	            this.cancellationReasonTypeOptions = data.cancellationReasonTypeOptions;
	            this.scheduleDateChangeReasonTypeOptions = data.scheduleDateChangeReasonTypeOptions;
	            this.expirationMonthOptions = data.expirationMonthOptions;
	            this.expirationYearOptions = data.expirationYearOptions;
	            
	            //set this last so that ng repeat inits with all needed data
	        	this.orderTemplates = data.orderTemplates; 
 	        }, (reason) => {
	            console.error(reason);
	    }).finally(()=>{
	    	this.initialized=true; 
	    });
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

