class MonatFlexshipCardController{
    
    public dayOfMonthFormatted:string;
	public shippingMethodOptions:any[]; 
	public orderTemplate:any; 
	
	constructor(public observerService){
	}
	
	public $onInit = () =>{
		console.log('smo', this.shippingMethodOptions)
		this.observerService.attach(this.updateOrderTemplate, "orderTemplateUpdated" + this.orderTemplate.orderTemplateID);
	}
	
	public updateOrderTemplate = (orderTemplate?) => {
		this.orderTemplate = orderTemplate;
	}

}

class MonatFlexshipCard {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    accountAddresses:'<',
	    accountPaymentMethods:'<',
	    shippingMethodOptions: '<',
	    stateCodeOptions:'<'
	};
	public controller=MonatFlexshipCardController;
	public controllerAs="monatFlexshipCard";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipCard(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexshipcard.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipCard
};

