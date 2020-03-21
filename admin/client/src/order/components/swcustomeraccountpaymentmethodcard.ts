/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCustomerAccountPaymentMethodCardController{

	public title:string;
	public billingAddressTitle:string="Billing Address";
	public modalButtonText:string;
	public paymentTitle:string="Payment";

	public billingAccountAddress;
	public accountPaymentMethod; 
	
	//entity that account payment method will be set on
	public baseEntityName:string;
	public baseEntity;
	
	public defaultCountryCode:string;
	
	//options
	public accountAddressOptions;
	public accountPaymentMethodOptions;
	
	public countryCodeOptions;
	
	public expirationMonthOptions;
	public expirationYearOptions;
	
	public stateCodeOptions;
	
	public propertiesToDisplayList;
	public propertiesToDisplay;
	
	public includeModal=true;
	
	constructor(public $hibachi,
				public observerService,
				public orderTemplateService, 
				public rbkeyService,
				public ModalService
	){
		this.observerService.attach(this.updateBillingInfo, 'OrderTemplateUpdateShippingSuccess');
		this.observerService.attach(this.updateBillingInfo, 'OrderTemplateUpdateBillingSuccess');
		this.observerService.attach(this.updateBillingInfo, 'OrderTemplateAddOrderTemplateItemSuccess');
		this.observerService.attach(this.updateBillingInfo, 'OrderTemplateRemoveOrderTemplateItemSuccess');
		this.observerService.attach(this.updateBillingInfo, 'OrderTemplateItemSaveSuccess');
		this.observerService.attach(this.addressVerificationCheck, 'OrderTemplateUpdateBillingSuccess');
		
		this.title = this.rbkeyService.rbKey('define.billing');
		
		if(this.propertiesToDisplayList == null){
			this.propertiesToDisplayList = 'fulfillmentTotal,fulfillmentDiscount,subTotal,total';
		} else {
			this.orderTemplateService.setOrderTemplatePropertyIdentifierList(this.propertiesToDisplayList);
		}
		
		this.propertiesToDisplay = this.propertiesToDisplayList.split(',');
		
		if(this.billingAccountAddress != null && this.accountPaymentMethod != null){
			this.modalButtonText = this.rbkeyService.rbKey('define.update')  + ' ' + this.title; 
		} else {
			this.modalButtonText = this.rbkeyService.rbKey('define.add')  + ' ' + this.title; 
		}
		
		if(this.baseEntityName === 'OrderTemplate' && this.baseEntity['orderTemplateStatusType_systemCode'] === 'otstCancelled'){
			this.includeModal = false;
		}
	}
	
	public updateBillingInfo = (data) =>{
		if( data == null) return;
		
		if( data['account.accountAddressOptions'] != null ){
			this.accountAddressOptions = data['account.accountAddressOptions'];
		}
		
		if( data['account.accountPaymentMethodOptions'] != null &&  
			data.billingAccountAddress != null && 
			data.accountPaymentMethod != null
		){
			this.accountPaymentMethodOptions = data['account.accountPaymentMethodOptions'];
			this.billingAccountAddress = data.billingAccountAddress; 
			this.accountPaymentMethod = data.accountPaymentMethod; 
			this.modalButtonText = this.rbkeyService.rbKey('define.update')  + ' ' + this.title;
		}
		
		for(var i=0; i<this.propertiesToDisplay.length; i++){
			var propertyIdentifier = this.propertiesToDisplay[i];
			
			if(data[propertyIdentifier] != null){
				this.baseEntity[propertyIdentifier] = data[propertyIdentifier];
			}
			
			if(data['orderTemplate.' + propertyIdentifier] != null){
				this.baseEntity[propertyIdentifier] = data['orderTemplate.' + propertyIdentifier];
			}
		}
		
		if(data.addressID){
			for(let key in data){
				this.billingAccountAddress[`address_${key}`] = data[key];
			}
		}
	}
	
	public addressVerificationCheck = ({billingAccountAddress})=>{
		if(!billingAccountAddress){
			return;
		}
		try{
			let addressVerification = JSON.parse(billingAccountAddress.address_verificationJson);
			if(addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success && addressVerification.hasOwnProperty('suggestedAddress')){
				this.launchAddressModal([addressVerification.address,addressVerification.suggestedAddress]);
			}
		}catch(e){
			console.log(e);
		}
	}
	
	public launchAddressModal(addresses: Array<object>):void{
		this.ModalService.showModal({
			component: 'swAddressVerification',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                suggestedAddresses: addresses, //address binding goes here
                sAction:this.updateBillingInfo,
                propertyIdentifiersList:'addressID,firstName,lastName,streetAddress,street2Address,city,stateCode,postalCode,countryCode'
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
	
}

class SWCustomerAccountPaymentMethodCard implements ng.IDirective {


	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountAddressOptions: "<",
		accountPaymentMethod:"<",
		accountPaymentMethodOptions:"<",
		billingAccountAddress:"<?",
		baseEntityName:"@?",
		baseEntity:"<",
		countryCodeOptions:"<",
		defaultCountryCode: "@?",
		expirationMonthOptions:"<",
		expirationYearOptions:"<",
		stateCodeOptions:"<",
		propertiesToDisplayList:"@?",
	    title:"@?"
	};

	
	public controller=SWCustomerAccountPaymentMethodCardController;
	public controllerAs="swCustomerAccountPaymentMethodCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWCustomerAccountPaymentMethodCard(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/customeraccountpaymentmethodcard.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWCustomerAccountPaymentMethodCard
};

