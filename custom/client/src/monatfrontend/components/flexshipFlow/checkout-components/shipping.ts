import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

class FlexshipCheckoutShippingController {
	public orderTemplate; 

	public accountAddresses:Array<any>;
	public existingAccountAddress; 
	public selectedShippingAddress = { accountAddressID : undefined }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	
	private newAddressFormRef;
	public loading: boolean = false;

	//@ngInject
    constructor(
    	public rbkeyService, 
    	public observerService, 
    	public orderTemplateService: OrderTemplateService, 
    	public monatAlertService: MonatAlertService,
    	private monatService: MonatService,
    	private ModalService
    ) {}
    
    public $onInit = () => {
    	this.loading=true;
	
        this.accountAddresses || this.monatService.getAccountAddresses() 
    	.then( (accountAddresses) => {
    		this.accountAddresses = accountAddresses;
	    	this.existingAccountAddress = this.accountAddresses.find( item => {
	    		return item.accountAddressID === this.orderTemplate?.shippingAccountAddress_accountAddressID;
	    	});
		    this.setSelectedAccountAddressID(this.existingAccountAddress?.accountAddressID);
    	})
    	.catch( (error) => {
		    console.error(error);
		})
		.finally(()=>{
			this.loading = false;   
		});
    	
    };
    
    
    public setSelectedAccountAddressID(accountAddressID:any = 'new') {
    	this.selectedShippingAddress.accountAddressID = accountAddressID;
    	if(accountAddressID === 'new'){
    	    this.showNewAddressForm();
    	} else {
    	    this.hideNewAddressForm();
    	}
    }
    
    public updateShippingAddress(accountAddress) {
        
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate?.orderTemplateID;
  
    	if(this.selectedShippingAddress.accountAddressID !== 'new') {
    		 payload['shippingAccountAddress.value'] = this.selectedShippingAddress.accountAddressID;
    	} else {
    		payload['newAccountAddress'] = accountAddress;
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
                this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.updateSucceccfull'));
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
    
    public showNewAddressForm = (accountAddress?) => {
        
        if(this.newAddressFormRef) {
            return this.newAddressFormRef.show();
        }
        
		let bindings = {
			// onSubmitCallback: (accountAddress) => {
   //         	this.updateShippingAddress(accountAddress);
   //         }
			onSuccessCallback: (accountAddress) => {
            	console.log("add account adress, on success", accountAddress);
            },
            onFailureCallback: (error) => {
            	console.log("ass account adress, on failure", error);
            }
		};
		
		if(accountAddress){
		    bindings['accountAddress'] = accountAddress;
		}
		
		this.ModalService.showModal({
			component: 'accountAddressForm',
			appendElement: '#shipping-new-account-address-form', //can be any vlid selector
			bindings: bindings
		})
		.then( (component) => {
			component.close.then((result) => {
			    console.log("onAccountAddressClose", result);
			    this.newAddressFormRef = undefined;
			});
			this.newAddressFormRef = component.element;
		})
		.catch((error) => {
			console.error('unable to open new-account-address-form :', error);
		});
	};
	
	private hideNewAddressForm(){
	    this.newAddressFormRef?.hide();
	}

}

class FlexshipCheckoutShipping {

	public restrict:"E";
	public templateUrl:string;
	
	public bindToController = {
	    orderTemplate:'<',
	};
	public controller=FlexshipCheckoutShippingController;
	public controllerAs="flexshipCheckoutShipping";

	public static Factory(){
        //@ngInject
        return ( monatFrontendBasePath ) => {
            return new FlexshipCheckoutShipping( monatFrontendBasePath);
        }; 
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/checkout-components/shipping.html";
	}

}

export {
	FlexshipCheckoutShipping
};

