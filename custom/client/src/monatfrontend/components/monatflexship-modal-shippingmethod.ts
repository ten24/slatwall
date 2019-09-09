
class MonatFlexshipShippingMethodModalController {
	public orderTemplate; 
	public accountAddresses;
	
	public existingAccountAddress; 
	public newAccountAddress;
	public selectedAccountAddressID; 
    constructor(public orderTemplateService, public observerService) {
    }
    public $onInit = () => {
    	console.log('shippingMethodModal', this);

    	this.existingAccountAddress = this.accountAddresses.find( item => {
    		return item.accountAddressID === this.orderTemplate.shippingAccountAddress_accountAddressID;
    	});
    	
    	if(this.existingAccountAddress) {
	    	this.selectedAccountAddressID = this.existingAccountAddress.accountAddressID;
    	}
    };
    
    public setSelectedAccountAddressID(accountAddressID) {
    	console.warn("new address id :" +accountAddressID);

    	this.selectedAccountAddressID = accountAddressID;
    }
    
    public updateShippingAddress() {
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	if(this.selectedAccountAddressID !== 'new') {
    		 payload['shippingAccountAddressID'] = this.selectedAccountAddressID; //make it a struct
    	} else {
    		 payload['newAccountAddress'] = this.newAccountAddress;
    	}
    
    	// make api request
        this.orderTemplateService.updateShipping(payload).then(
            (response) => {
               
                this.orderTemplate = response.orderTemplate;
                this.observerService.notify("orderTemplateUpdated",response.orderTemplate);

                this.setSelectedAccountAddressID(this.orderTemplate.shippingAccountAddress_accountAddressID);
                
                console.log('ot updateShipping: ', this.orderTemplate); 
                
                if(angular.isDefined(response.newAccountAddress)) {
            		this.observerService.notify("newAccountAddressAdded",response.newAccountAddress);
                }
                		
                // TODO: show alert
            }, 
            (reason) => {
                throw (reason);
                // TODO: show alert
            }
        );
    }
    	
}

class MonatFlexshipShippingMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    accountAddresses:'<'
	};
	public controller=MonatFlexshipShippingMethodModalController;
	public controllerAs="monatFlexshipShippingMethodModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipShippingMethodModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-shippingmethod.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipShippingMethodModal
};

