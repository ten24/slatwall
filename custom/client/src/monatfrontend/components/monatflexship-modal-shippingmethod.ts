
class MonatFlexshipShippingMethodModalController {
	public orderTemplate; 
	public accountAddresses:Array<any>;
	public shippingMethodOptions:Array<any>;
	public close; // injected from angularModalService

	public existingAccountAddress; 
	public selectedShippingAddress = { accountAddressID : 'new' }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	public existingShippingMethod; 
	public selectedShippingMethod = { shippingMethodID : undefined }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	
	public countryCodeBySite:any;
	public newAccountAddress = {};
	public newAddress = {'countryCode':'US'}; //TODO: hard-coded default]
	public countryCodeOptions = {};
	
	public loading: boolean = false;

	//@ngInject
    constructor(
    	public orderTemplateService, 
    	public observerService, 
    	public rbkeyService, 
    	public monatAlertService,
    	private monatService
    ) {}
    
    public $onInit = () => {
    	this.loading=true;
    	
    	this.makeTranslations();
     
    	this.newAddress['countryCode']=this.countryCodeBySite;	
    	this.existingAccountAddress = this.accountAddresses.find( item => {
    		return item.accountAddressID === this.orderTemplate.shippingAccountAddress_accountAddressID;
    	});
    	if(!!this.existingAccountAddress && !!this.existingAccountAddress.accountAddressID){
	    	this.setSelectedAccountAddressID(this.existingAccountAddress.accountAddressID);
    	}
    	
    	this.monatService.getOptions({'orderTemplateShippingMethodOptions':false})
    	.then( (options) => {
    		this.shippingMethodOptions = options.orderTemplateShippingMethodOptions;
   
	    	this.existingShippingMethod = this.shippingMethodOptions.find( item => {
	    		return item.value === this.orderTemplate.shippingMethod_shippingMethodID; //shipping methods are {"name" : shippingMethodName, "value":"shippingMethodID" }
	    	});
	    	
	    	if(!!this.existingShippingMethod && !!this.existingShippingMethod.value){
		    	this.setSelectedShippingMethodID(this.existingShippingMethod.value);
	    	}
    	})
    	.catch( (error) => {
		    console.error(error);
		})
		.finally(()=>{
			this.loading = false;   
		});
    	
    };
    
    public translations = {};
    private makeTranslations = () => {
    	//TODO make translations for success/failure alert messages
    	this.translations['shippingMethod'] = this.rbkeyService.rbKey('frontend.shippingMethodModal.shippingMethod');
    	this.translations['shippingAddress'] = this.rbkeyService.rbKey('frontend.shippingMethodModal.shippingAddress');
    	this.translations['addNewShippingAddress'] = this.rbkeyService.rbKey('frontend.shippingMethodModal.addNewShippingAddress');
    	this.translations['newShippingAddress'] = this.rbkeyService.rbKey('frontend.shippingMethodModal.newShippingAddress');
    	this.translations['newAddress_nickName'] = this.rbkeyService.rbKey('frontend.newAddress.nickName');
    	this.translations['newAddress_name'] = this.rbkeyService.rbKey('frontend.newAddress.name');
    	this.translations['newAddress_address'] = this.rbkeyService.rbKey('frontend.newAddress.address');
    	this.translations['newAddress_address2'] = this.rbkeyService.rbKey('frontend.newAddress.address2');
    	this.translations['newAddress_country'] = this.rbkeyService.rbKey('frontend.newAddress.country');
    	this.translations['newAddress_state'] = this.rbkeyService.rbKey('frontend.newAddress.state');
    	this.translations['newAddress_selectYourState'] = this.rbkeyService.rbKey('frontend.newAddress.selectYourState');
    	this.translations['newAddress_city'] = this.rbkeyService.rbKey('frontend.newAddress.city');
    	this.translations['newAddress_zipCode'] = this.rbkeyService.rbKey('frontend.newAddress.zipCode');
    	this.translations['select_country'] = this.rbkeyService.rbKey('frontend.newAddress.selectCountry');

    }
    
    public setSelectedAccountAddressID(accountAddressID:any = 'new') {
    	this.selectedShippingAddress.accountAddressID = accountAddressID;
    }
    
    public setSelectedShippingMethodID(shippingMethodID?) {
    	this.selectedShippingMethod.shippingMethodID = shippingMethodID;
    }
    
    public updateShippingAddress() {
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;
    	payload['shippingMethodID'] = this.selectedShippingMethod.shippingMethodID;
    	this.loading = true;
  
    	if(this.selectedShippingAddress.accountAddressID !== 'new') {
    		 payload['shippingAccountAddress.value'] = this.selectedShippingAddress.accountAddressID;
    	} else {
    		this.newAccountAddress['address'] = this.newAddress;
    		payload['newAccountAddress'] = this.newAccountAddress;
    	}
 
    	payload = this.orderTemplateService.getFlattenObject(payload);

    	// make api request
        this.orderTemplateService.updateShipping(payload)
        .then( (response) => {
           if(response.orderTemplate) {
                this.orderTemplate = response.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
                if(response.newAccountAddress) {
            		this.observerService.notify("newAccountAddressAdded",response.newAccountAddress);
            		this.accountAddresses.push(response.newAccountAddress);
                }
                		
                this.setSelectedAccountAddressID(this.orderTemplate.shippingAccountAddress_accountAddressID);
                this.setSelectedShippingMethodID(this.orderTemplate.shippingMethod_shippingMethodID);
                
               	this.monatAlertService.success("Your flexship has been updated successfully");
                this.closeModal();
           } else {
               	throw(response);
           }
        }) 
        .catch( (error) => {
            console.error(error);
	        this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally(() => {
        	this.loading = false;
        }); 
    }

    public closeModal = () => {
     	this.close(null); // close, but give 100ms to animate
    };
    	
}

class MonatFlexshipShippingMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    accountAddresses:'<',
	    stateCodeOptions:'<',
	    countryCodeBySite:'<',
	    close:'=' //injected by angularModalService;
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

