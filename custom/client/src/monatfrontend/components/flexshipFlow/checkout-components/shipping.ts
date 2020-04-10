import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

class FlexshipCheckoutShippingController {
	public orderTemplate; 

	public accountAddresses:Array<any>;
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
    	.then( (data) => {
    		this.accountAddresses = data.accountAddresses;
	    	
	    	let oldShippingAddressID = this.orderTemplate?.shippingAccountAddress_accountAddressID?.trim();
	    	if(oldShippingAddressID !== '') oldShippingAddressID = undefined;
	    	
	    	//select either one of previously-selected shipping-address, or-primary-sgipping or primary-account-address or first of items
		    this.setSelectedAccountAddressID(
		    	oldShippingAddressID 
		    	|| data.primaryShippingAddressID 
		    	|| data.primaryAccountAddressID 
		    	|| this.accountAddresses?.find(e => true)?.accountAddressID //first of the array
		    );
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
    
    public updateShippingAddress() {
        
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate?.orderTemplateID;
    	if(this.selectedShippingAddress.accountAddressID !== 'new') {
    		 payload['shippingAccountAddress.value'] = this.selectedShippingAddress.accountAddressID;
    	} else {
	    	throw("What went wrong????");
    	}
 
    	// make api request
        this.orderTemplateService.updateShipping(
			this.orderTemplateService.getFlattenObject(payload)
		)
        .then( (response) => {
           if(response.orderTemplate) {
                this.orderTemplate = response.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
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
    
    public onAddNewAccountAddressSuccess = (newAccountAddress) => {
		if(newAccountAddress) {
    		this.accountAddresses.push(newAccountAddress);
    		this.setSelectedAccountAddressID(newAccountAddress.accountAddressID);
        }
        this.updateShippingAddress();
    	console.log("add account adress, on success", newAccountAddress);
    	return true;
    };
    
    public onAddNewAccountAddressFailure = (error) => {
        console.log("add account adress, on failure", error);
    };
    
    public showNewAddressForm = (accountAddress?) => {
        
        if(this.newAddressFormRef) {
            return this.newAddressFormRef.show();
        }
        
        
		let bindings = {
			onSuccessCallback: this.onAddNewAccountAddressSuccess,
			onFailureCallback: this.onAddNewAccountAddressFailure,
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
			component.close.then( () =>  this.newAddressFormRef = undefined);
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
	public scope = {};
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

