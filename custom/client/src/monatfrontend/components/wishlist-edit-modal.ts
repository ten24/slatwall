
class WishlistEditModalConroller {
    public wishlist; 
    public translations = {};
	public close; // injected from angularModalService

    //@ngInject
    constructor(public rbkeyService, public observerService) {
        this.observerService.attach(this.closeModal,'editSuccess')
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['wishlistName'] = this.rbkeyService.rbKey('frontend.wishlist.name');
    	this.translations['save'] = this.rbkeyService.rbKey('frontend.marketPartner.save');
    	this.translations['cancel'] = this.rbkeyService.rbKey('frontend.wishlist.cancel');
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class WishlistEditModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    wishlist:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = WishlistEditModalConroller;
	public controllerAs = "wishlistEditModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new WishlistEditModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/wishlist-edit-modal.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	WishlistEditModal
};

