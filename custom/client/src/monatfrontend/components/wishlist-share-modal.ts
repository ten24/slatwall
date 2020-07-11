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
	public scope = {};
	
	public bindToController = {
	    wishlist:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = WishlistShareModalConroller;
	public controllerAs = "wishlistShareModal";

    public template = require('./wishlist-share-modal.html');

	public static Factory() {
		return () => new this();
	}
}

export {
	WishlistShareModal
};

