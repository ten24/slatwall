class MonatFlexshipMenuController{
    
	public orderTemplate:any; 
	
	public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public shippingMethodOptions: any[]; 
	public stateCodeOptions: any[];
	public cancellationReasonTypeOptions: any[];
	public scheduleDateChangeReasonTypeOptions: any[];

	constructor( 
		public orderTemplateService,
		public observerService,
	){

	}
	
	public $onInit = () =>{
		console.log('flexship menue: ', this);
	}
	
   public activateFlexship() {
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
 
    	payload = this.orderTemplateService.getFlattenObject(payload);
    	//return;
    	// make api request
        this.orderTemplateService.activate(payload).then(
            (data) => {
            	if(angular.isDefined(data.orderTemplate)) {
	                this.orderTemplate = data.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + data.orderTemplate.orderTemplateID, data.orderTemplate);
            	} else{
            		console.error(data);
            	}
            	// TODO: show alert
            }, 
            (reason) => {
                throw (reason);
                // TODO: show alert
            }
        );
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
	    stateCodeOptions: '<',
	    cancellationReasonTypeOptions: '<',
	    scheduleDateChangeReasonTypeOptions: '<'
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

