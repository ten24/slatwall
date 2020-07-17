
class AddressDeleteModalController {
    public wishlist; 
    public translations = {};
	public close; // injected from angularModalService
	public loading;
	public address;
	
    //@ngInject
    constructor(public rbkeyService, public observerService, public publicService, public monatAlertService) {
        this.observerService.attach(this.closeModal,'deleteAccountAddressSuccess')
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['wishlistName'] = this.rbkeyService.rbKey('frontend.wishlist.name');
    	this.translations['save'] = this.rbkeyService.rbKey('frontend.marketPartner.save');
    	this.translations['cancel'] = this.rbkeyService.rbKey('frontend.wishlist.cancel');
    	this.translations['addressDeleted'] = this.rbkeyService.rbKey('entity.AccountAddress.DeleteSuccess');
    }
    
    public deleteAccountAddress = () => {
        this.loading = true;
        return this.publicService
        .doAction("deleteAccountAddress", { 
            'accountAddressID': this.address.accountAddressID,
            'returnJsonObjects': 'account'
        })
        .then(result=>{
            
            if(result.errors){
                this.monatAlertService.error(result.errors);
            }
            
            this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class AddressDeleteModal {

	public restrict = 'E';
	
	public scope = {};
	public bindToController = {
	    address:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = AddressDeleteModalController;
	public controllerAs = "addressDeleteModal";

	public template = require('./address-delete-modal.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	AddressDeleteModal
};
