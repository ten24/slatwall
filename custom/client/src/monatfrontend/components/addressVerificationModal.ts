
class AddressVerificationController {
    public suggestedAddresses:Array<Object>; 
    public translations = {};
	public close; // injected from angularModalService

    //@ngInject
    constructor(public rbkeyService, public observerService) {
        this.observerService.attach(this.closeModal,'editSuccess');
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    private makeTranslations = () => {
    	this.translations['suggestedAddress'] = this.rbkeyService.rbKey('frontend.checkout.suggestedAddress');
    	this.translations['cancel'] = this.rbkeyService.rbKey('frontend.wishlist.cancel');
    	this.translations['addressMessage']= this.rbkeyService.rbKey('frontend.checkout.addressChangeMessage');
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class AddressVerification {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    suggestedAddresses:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = AddressVerificationController;
	public controllerAs = "addressVerification";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new AddressVerification(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/address-verification-modal.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	AddressVerification
}

