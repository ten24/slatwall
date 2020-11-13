
class WishlistEditModalConroller {
    public wishlist; 
    public translations = {};
	public close; // injected from angularModalService
	public wishlistName;

    //@ngInject
    constructor(public rbkeyService, public observerService) {
        this.observerService.attach(this.closeModal,'editSuccess')
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    	this.wishlistName = this.wishlist.name;
    };
    
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['wishlistName'] = this.rbkeyService.rbKey('frontend.wishlist.name');
    	this.translations['save'] = this.rbkeyService.rbKey('frontend.marketPartner.save');
    	this.translations['cancel'] = this.rbkeyService.rbKey('frontend.wishlist.cancel');
    }
    
    public closeModal = () => {
     	this.close(this.wishlistName);
    }
    
}

class WishlistEditModal {

	public restrict:string;

	public scope = {};
	public bindToController = {
	    wishlist:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = WishlistEditModalConroller;
	public controllerAs = "wishlistEditModal";
	
    public template = require('./wishlist-edit-modal.html');

	public static Factory() {
		return () => new this();
	}
}

export {
	WishlistEditModal
};

