
class MonatProductModalController {
	public product; 
	public context;
	
	public close; // injected from angularModalService


    //@ngInject
	constructor(public orderTemplateService, public observerService, public rbkeyService) {
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    }
    
    public closeModal = () => {
    	console.log("closing modal");
     	this.close(null); // close, but give 100ms to animate
    };

}

class MonatProductModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    product:'<',
	    context:'<',
		close:'=' //injected by angularModalService
	};
	public controller=MonatProductModalController;
	public controllerAs="monatProductModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatProductModal(
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

	//@ngInject
	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monat-product-modal.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatProductModal
};

