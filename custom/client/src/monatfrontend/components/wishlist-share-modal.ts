
class WishlistShareModalConroller {
    public wishlist; 
	public close; // injected from angularModalService

    //@ngInject
    constructor(public rbkeyService, public observerService) {
        this.observerService.attach(this.closeModal,'shareWishlistSuccess');
    }
    
    public $onInit = () => {
    };
   
    public closeModal = () => {
     	this.close(null);
    }
    
}

class WishlistShareModal {

	public restrict = "E";
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    wishlist:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = WishlistShareModalConroller;
	public controllerAs = "wishlistShareModal";

	public static Factory(){
        var directive:any = ( monatFrontendBasePath ) => new WishlistShareModal( monatFrontendBasePath);
        directive.$inject = ['monatFrontendBasePath'];
        return directive;
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/wishlist-share-modal.html";
	}
}

export {
	WishlistShareModal
};

