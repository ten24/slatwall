
class MonatFlexshipShippingMethodModalController {
	public orderTemplate; 
	public accountAddresses;
	public shippingMethodOptions;

	public existingAccountAddress; 
	public selectedShippingAddress = { accountAddressID : 'new' }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	public existingShippingMethod; 
	public selectedShippingMethod = { shippingMethodID : undefined }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	
	public newAccountAddress = {};
	public newAddress = {'countryCode':'US'}; // hard-coded default

    constructor(public orderTemplateService, public observerService) {}
    
    public $onInit = () => {
    	this.existingAccountAddress = this.accountAddresses.find( item => {
    		return item.accountAddressID === this.orderTemplate.shippingAccountAddress_accountAddressID;
    	});
    	if(!!this.existingAccountAddress && !!this.existingAccountAddress.accountAddressID){
	    	this.setSelectedAccountAddressID(this.existingAccountAddress.accountAddressID);
    	}
    	
    	this.existingShippingMethod = this.shippingMethodOptions.find( item => {
    		return item.value === this.orderTemplate.shippingMethod_shippingMethodID; //shipping methods are {"name" : shipping-method-name, "value":"shipping-method-ID" }
    	});
    	if(!!this.existingShippingMethod && !!this.existingShippingMethod.value){
	    	this.setSelectedShippingMethodID(this.existingShippingMethod.value);
    	}
    };
    
    public setSelectedAccountAddressID(accountAddressID:any = 'new') {
    	console.warn("selected address id :" + accountAddressID);
    	this.selectedShippingAddress.accountAddressID = accountAddressID;
    }
    
    public setSelectedShippingMethodID(shippingMethodID?) {
    	console.warn("selected shipping method id :" + shippingMethodID);
    	this.selectedShippingMethod.shippingMethodID = shippingMethodID;
    }
    
    public updateShippingAddress() {
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	payload['shippingMethod.shippingMethodID'] = this.selectedShippingMethod.shippingMethodID;
  
    	if(this.selectedShippingAddress.accountAddressID !== 'new') {
    		 payload['shippingAccountAddress.value'] = this.selectedShippingAddress.accountAddressID;
    	} else {
    		this.newAccountAddress['address'] = this.newAddress;
    		payload['newAccountAddress'] = this.newAccountAddress;
    	}
 
    	payload = this.orderTemplateService.getFlattenObject(payload);
    	//return;
    	// make api request
        this.orderTemplateService.updateShipping(payload).then(
            (response) => {
               
               if(response.orderTemplate) {
	                this.orderTemplate = response.orderTemplate;
	                this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
	
	                if(response.newAccountAddress) {
	            		this.observerService.notify("newAccountAddressAdded",response.newAccountAddress);
	            		this.accountAddresses.push(response.newAccountAddress);
	                }
	                		
	                this.setSelectedAccountAddressID(this.orderTemplate.shippingAccountAddress_accountAddressID);
	                this.setSelectedShippingMethodID(this.orderTemplate.shippingMethod_shippingMethodID);
	                
               } else {
	               	console.error(response); //
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
	    accountAddresses:'<',
	    shippingMethodOptions:'<',
	    stateCodeOptions:'<'
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

