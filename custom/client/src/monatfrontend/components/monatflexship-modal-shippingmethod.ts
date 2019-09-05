
class MonatFlexshipShippingMethodModalController {
	public orderTemplate; 
	public accountAddresses;
	public existingAccountAddress; 
	public createNewShippingAddress:boolean=false; 
    public ShippingMethodModal: {};
    constructor(public orderTemplateService) {
    }
    public $onInit = () => {
    	console.log('shippingMethodModal', this);
    	
    	for(var i; i<this.accountAddresses.length; i++){
    		if(this.orderTemplate.shippingAccountAddress_accountAddressID === this.accountAddresses[i].accountAddressID){
    			this.existingAccountAddress = this.accountAddresses[i]; 
    			console.log('found existing shipping account address', this.accountAddresses[i]);
    			break; 
    		}
    	}
    };
    
    public selectAccountAddress = (accountAddress) =>{
    	console.log('accountAddress', accountAddress);
    	this.existingAccountAddress = accountAddress; 	
    }
}

class MonatFlexshipShippingMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    shippingMethod:'=',
	    orderTemplateId:'@',
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

