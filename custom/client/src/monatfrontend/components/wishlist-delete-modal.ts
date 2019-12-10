
class WishlistDeleteModalConroller {
    public wishlist; 
    public translations = {};
	public close; // injected from angularModalService

    //@ngInject
    constructor(public rbkeyService, public observerService) {
        this.observerService.attach(this.closeModal,'deleteOrderTemplateSuccess')
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['deleteWishlist'] = this.rbkeyService.rbKey(
    		'frontend.wishlist.deleteWishlist',
    	);
    	
    	this.translations['areYouSure'] = this.rbkeyService.rbKey(
    		'frontend.wishlist.areYouSureWishlist',
    	);
    	
    	this.translations['cancel'] = this.rbkeyService.rbKey(
    		'frontend.marketPartner.cancel',
    	);
    	
    	this.translations['continue'] = this.rbkeyService.rbKey(
    		'frontend.wishlist.continue',
    	);
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class WishlistDeleteModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    wishlist:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = WishlistDeleteModalConroller;
	public controllerAs = "wishlistDeleteModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new WishlistDeleteModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/wishlist-delete-modal.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	WishlistDeleteModal
};

