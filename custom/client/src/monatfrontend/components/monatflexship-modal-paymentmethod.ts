
class MonatFlexshipPaymentMethodModalController {
    public PaymentMethodModal: {};
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {};
}

class MonatFlexshipPaymentMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    accountPaymentMethods:'<',
	    orderTemplate:'<'
	};
	public controller=MonatFlexshipPaymentMethodModalController;
	public controllerAs="monatFlexshipPaymentMethodModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipPaymentMethodModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-paymentmethod.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipPaymentMethodModal
};

