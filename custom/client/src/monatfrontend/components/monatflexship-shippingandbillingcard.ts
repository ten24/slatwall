
class MonatFlexshipShippingAndBillingCardController {
    public orderTemplate; 
    
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {
    	
    	console.log('ot',this.orderTemplate);
    };
}

class MonatFlexshipShippingAndBillingCard {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<'
	};
	public controller = MonatFlexshipShippingAndBillingCardController;
	public controllerAs = "monatFlexshipShippingAndBillingCard";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipShippingAndBillingCard(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-shippingandbillingcard.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipShippingAndBillingCard
};

