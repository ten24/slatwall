import { MonatAlertService } from "@Monat/services/monatAlertService";
import { RbKeyService, ObserverService } from "@Hibachi/core/core.module";

class WishlistShareModalConroller {
    public wishlist; 
	public close; // injected from angularModalService

    //@ngInject
    constructor(
    	public rbkeyService		  : RbKeyService, 
    	public observerService	  : ObserverService, 
    	private monatAlertService : MonatAlertService
    ) {
        
    }
    
    public $onInit = () => {
    	this.observerService
        .attach( 
        	() => { 
	    		this.monatAlertService.success(
	    			this.rbkeyService.rbKey('frontend.wishlist.sharingSuccess')
	    		);
	        	this.closeModal();
	        },
        	'shareWishlistSuccess',
        	"WishlistShareModalConroller"
        );
    };
    
	public $onDestroy= () => {
		this.observerService.detachByEventAndId("shareWishlistSuccess", "WishlistShareModalConroller");
	} 
   
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

