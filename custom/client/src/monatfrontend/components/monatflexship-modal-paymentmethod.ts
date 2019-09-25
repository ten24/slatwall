
class MonatFlexshipPaymentMethodModalController {
    public orderTemplate; 
    public accountPaymentMethods: Array<{}>;
    public accountAddresses: Array<{}>;
    public expirationMonthOptions: Array<{}>;
	public expirationYearOptions: Array<{}>;
    
    
    public existingBillingAccountAddress; 
	public selectedBillingAccountAddress = { accountAddressID : 'new' }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	public existingAccountPaymentMethod; 
	public selectedAccountPaymentMethod = { accountPaymentMethodID : 'new' }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	
	public newAccountAddress = {};
	public newAddress = {'countryCode':'US'}; // hard-coded default

	public newAccountPaymentMethod = {};

	//@ngInject
    constructor(public orderTemplateService, public observerService) {
    }
    
    public $onInit = () => {
    	/**
    	 * Find and set old billing-address if any
    	*/ 
    	this.existingBillingAccountAddress = this.accountAddresses.find( item => {
    		return item.accountAddressID === this.orderTemplate.billingAccountAddress_accountAddressID;
    	});
    	
    	if(!!this.existingBillingAccountAddress && !!this.existingBillingAccountAddress.accountAddressID){
	    	this.setSelectedBillingAccountAddressID(this.existingBillingAccountAddress.accountAddressID);
    	}
    	
    	/**
    	 * Find and set old payment-method if any
    	*/
    	this.existingAccountPaymentMethod = this.accountPaymentMethods.find( item => {
    		return item.accountPaymentMethodID === this.orderTemplate.accountPaymentMethod_accountPaymentMethodID; 
    	});
    	
    	if(!!this.existingAccountPaymentMethod && !!this.existingAccountPaymentMethod.accountPaymentMethodID){
	    	this.setSelectedAccountPaymentMethodID(this.existingAccountPaymentMethod.accountPaymentMethodID);
    	}
    	
    }
    
    public setSelectedBillingAccountAddressID(accountAddressID:any = 'new') {
    	this.selectedBillingAccountAddress.accountAddressID = accountAddressID;
    }
    
    public setSelectedAccountPaymentMethodID(accountPaymentMethodID:any = 'new') {
    	this.selectedAccountPaymentMethod.accountPaymentMethodID = accountPaymentMethodID;
    }
    
    public updateBilling() {
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate.orderTemplateID;

    	if(this.selectedBillingAccountAddress.accountAddressID !== 'new') {
    		 payload['billingAccountAddress.value'] = this.selectedBillingAccountAddress.accountAddressID;
    	} else {
    		this.newAccountAddress['address'] = this.newAddress;
    		payload['newAccountAddress'] = this.newAccountAddress;
    	}
    	
    	if(this.selectedAccountPaymentMethod.accountPaymentMethodID !== 'new') {
    		 payload['accountPaymentMethod.value'] = this.selectedAccountPaymentMethod.accountPaymentMethodID;
    	} else {
    		payload['newAccountPaymentMethod'] = this.newAccountPaymentMethod;
    	}
 
		//flattning it for hibachi
    	payload = this.orderTemplateService.getFlattenObject(payload);

    	// make api request
        this.orderTemplateService.updateBilling(payload).then(
            (response) => {
               
               if(response.orderTemplate) {
	                this.orderTemplate = response.orderTemplate;
	
	                if(response.newAccountAddress) {
	            		this.observerService.notify("newAccountAddressAdded",response.newAccountAddress);
	            		this.accountAddresses.push(response.newAccountAddress);
	                }
	                
	                if(response.newAccountPaymentMethod) {
	            		this.observerService.notify("newAccountPaymentMethodAdded",response.newAccountPaymentMethod);
	            		this.accountPaymentMethods.push(response.newAccountPaymentMethod);
	                }
	                
	                this.setSelectedBillingAccountAddressID(this.orderTemplate.billingAccountAddress_accountAddressID);
	                this.setSelectedAccountPaymentMethodID(this.orderTemplate.accountPaymentMethod_accountPaymentMethodID);
	                
	                this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
               } else {
               		//TODO handle errors
	               	console.error(response); 
               }
                
                // TODO: show alerts
            }, 
            (reason) => {
                throw (reason);
                // TODO: show alert
            }
        );
    }

}

class MonatFlexshipPaymentMethodModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    accountPaymentMethods:'<',
 	    stateCodeOptions:'<',
	    accountAddresses:'<',
	    orderTemplate:'<',
	    expirationMonthOptions: '<',
		expirationYearOptions: '<'
	};
	public controller=MonatFlexshipPaymentMethodModalController;
	public controllerAs="monatFlexshipPaymentMethodModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipPaymentMethodModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-paymentmethod.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipPaymentMethodModal
};

