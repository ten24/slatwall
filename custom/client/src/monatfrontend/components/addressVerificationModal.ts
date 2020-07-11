
class AddressVerificationController {
    public suggestedAddresses:Array<Object>; 
    public selectedAddressIndex:number;
    public loading;
    public translations = {};
	public close; // injected from angularModalService

    //@ngInject
    constructor(public rbkeyService, public observerService, private publicService) {
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
    
    public submit = () =>{
    	if(this.selectedAddressIndex == 0){
    		this.close(null);
    		return;
    	}else{
    		this.loading = true;
    		this.publicService.doAction('updateAddress', this.suggestedAddresses[this.selectedAddressIndex])
    		.then(result=>{
    			this.loading = false;
    			this.suggestedAddresses[0] = this.suggestedAddresses[this.selectedAddressIndex];
    			this.close(null);
    		})
    	}
    	
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class AddressVerification {

	public restrict = 'E';
	
	public scope = {};
	public bindToController = {
	    suggestedAddresses:'<',
		close:'=' //injected by angularModalService
	};
	
	public controller = AddressVerificationController;
	public controllerAs = "addressVerification";

	public template = require('./address-verification-modal.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) =>{

	}

}

export {
	AddressVerification
}
