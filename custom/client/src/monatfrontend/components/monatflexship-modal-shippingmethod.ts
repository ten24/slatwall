
class MonatFlexshipShippingMethodModalController {
	public orderTemplate; 
	public accountAddresses;
	public existingAccountAddress; 
	public selectedAccountAddressID; 
    public ShippingMethodModal: {};
    constructor(public orderTemplateService) {
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
}

class MonatFlexshipShippingMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    shippingMethod:'=',
	    orderTemplate:'<',
	    accountAddresses:'<',
	    selectedAccountAddressID:'<'
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

