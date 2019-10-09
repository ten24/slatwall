
class MonatProductModalController {
	public product; 
	public type:string; 
	public flexshipID:string;
	
	public close; // injected from angularModalService

	public quantityToAdd:number = 1;

    //@ngInject
	constructor(public monatService, public observerService, public rbkeyService) {
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    	if(this.type === 'flexship') {
    		this.fetchCurrentFlexshipID();
    	}
    };
    
    public translations = {};
    private makeTranslations = () => {
    	if(this.type === 'flexship'){
    		this.translations['addButtonText'] = this.rbkeyService.rbKey('frontend.global.addToFlexship');
    	} else {
    		this.translations['addButtonText'] = this.rbkeyService.rbKey('frontend.global.addToCart');
    	}
    	
    	//TODO make translations for success/failure alert messages
    }
    
    private fetchCurrentFlexshipID = () => {
    	this.flexshipID = 'hsdgfgvwbwojfwbfiww78676';
    }
    
    public onAddButtonClick = () => {
    	console.log('on add', this);
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
	    type:'<',
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

