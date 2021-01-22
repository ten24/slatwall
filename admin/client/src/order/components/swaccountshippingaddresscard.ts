/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountShippingAddressCardController{

	public shippingAccountAddress;
	public shippingMethod;
	
	public accountAddressOptions;
	public shippingMethodOptions;
	public stateCodeOptions;
	
	public title:string="Shipping";
	public shippingAddressTitle:string='Shipping Address';
	public shippingMethodTitle:string='Shipping Method';
	public modalButtonText:string;
	
	//entity that account payment method will be set on
	public baseEntityName:string;
	public baseEntity;
	
	public includeModal = true;
	
	public defaultCountryCode:string;

	constructor(public $hibachi,
				public observerService,
				public rbkeyService,
				public ModalService
	){
		this.observerService.attach(this.updateShippingInfo, 'OrderTemplateUpdateShippingSuccess');
		this.observerService.attach(this.addressVerificationCheck, 'OrderTemplateUpdateShippingSuccess');
		this.observerService.attach(this.updateShippingInfo, 'OrderTemplateUpdateBillingSuccess');
		
		if(this.shippingAccountAddress != null && this.shippingMethod != null){
			this.modalButtonText = this.rbkeyService.rbKey('define.update')  + ' ' + this.title; 
		} else {
			this.modalButtonText = this.rbkeyService.rbKey('define.add')  + ' ' + this.title; 
		}
		
		if(this.baseEntityName === 'OrderTemplate' && this.baseEntity['orderTemplateStatusType_systemCode'] === 'otstCancelled'){
			this.includeModal = false;
		}
	}
	
	public addressVerificationCheck = ({shippingAccountAddress})=>{
		if(!shippingAccountAddress){
			return;
		}
		try{
			let addressVerification = JSON.parse(shippingAccountAddress.address_verificationJson);
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
                sAction:this.updateShippingInfo,
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
	
	public updateShippingInfo = (data) =>{
		if( data['account.accountAddressOptions'] != null){
			this.accountAddressOptions = data['account.accountAddressOptions'];
		}
		
		if( data.shippingAccountAddress != null && data.shippingMethod != null) {
			this.shippingAccountAddress = data.shippingAccountAddress;
			this.shippingMethod = data.shippingMethod; 
			this.modalButtonText = this.rbkeyService.rbKey('define.update')  + ' ' + this.title;
		}
		
		if(data.addressID){
			for(let key in data){
				this.shippingAccountAddress[`address_${key}`] = data[key];
			}
		}

	}
}

class SWAccountShippingAddressCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		accountAddressOptions: "<",
		shippingAccountAddress:"<",
		baseEntityName:"@?",
		baseEntity:"<",
		countryCodeOptions:"<",
		defaultCountryCode: "@?",
		shippingMethod: "<",
		shippingMethodOptions: "<",
		stateCodeOptions: "<",
	    title:"@?"
	};
	public controller=SWAccountShippingAddressCardController;
	public controllerAs="swAccountShippingAddressCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAccountShippingAddressCard(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountshippingaddresscard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAccountShippingAddressCard
};

