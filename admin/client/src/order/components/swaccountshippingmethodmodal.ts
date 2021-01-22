/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAccountShippingMethodModalController{

    //objects
	public accountShippingAddress;
	public shippingMethod;
	
	public newAccountAddress;
	
	//Options
	public accountAddressOptions;
	public countryCodeOptions;
    public shippingMethodOptions;
    public stateCodeOptions;
	
	//Order or Order Template
	public baseEntityName;
	public baseEntity;
	public processObject;
	public baseEntityPrimaryID:string;
		
	public swAccountShippingAddressCard;
	
	public processContext:string = 'updateShipping';
	
	public uniqueName:string = 'shippingMethodModal';
	public formName:string = 'shippingMethodModal';
	
	//rb key properties
	public title:string = "Edit Shipping Information";
	public shippingMethodTitle:string = "Shipping Method";
	public modalButtonText:string = "Add Shipping Information";
	
    public defaultCountryCode:string;
	
	public createShippingAddressTitle:string = 'Add new shipping address';
	public shippingAccountAddressTitle:string = 'Shipping account address'
	
    //view state properties
	public hideSelectAccountAddress:boolean = false; 
	public showCreateShippingAddress:boolean;
	

	constructor( public $timeout,
	             public $hibachi,
	             public entityService,
	             public observerService,
	             public orderTemplateService,
				 public rbkeyService,
				 public requestService
	){
		this.observerService.attach(this.$onInit, 'OrderTemplateUpdateShippingSuccess');
		this.observerService.attach(this.$onInit, 'OrderTemplateUpdateBillingSuccess');
	}
	
	public $onInit = () =>{
		this.showCreateShippingAddress = false;

		this.baseEntityName = this.swAccountShippingAddressCard.baseEntityName;
		this.baseEntity = this.swAccountShippingAddressCard.baseEntity;
		this.baseEntityPrimaryID = this.baseEntity[this.$hibachi.getPrimaryIDPropertyNameByEntityName(this.baseEntityName)];
		
		this.defaultCountryCode = this.swAccountShippingAddressCard.defaultCountryCode;
		
		this.accountAddressOptions = this.swAccountShippingAddressCard.accountAddressOptions;
		this.countryCodeOptions = this.swAccountShippingAddressCard.countryCodeOptions;
		this.shippingMethodOptions = this.swAccountShippingAddressCard.shippingMethodOptions;
		this.stateCodeOptions = this.swAccountShippingAddressCard.stateCodeOptions;
		
		this.hideSelectAccountAddress = this.accountAddressOptions.length === 0;
		this.showCreateShippingAddress = this.hideSelectAccountAddress;
        
        if(!this.hideSelectAccountAddress  && this.swAccountShippingAddressCard.shippingAccountAddress == null){
			this.baseEntity.shippingAccountAddress = this.accountAddressOptions[0];
		} else {
			for(var i=0; i<this.accountAddressOptions.length; i++){
				var option = this.accountAddressOptions[i];
				if(option['value'] === this.swAccountShippingAddressCard.shippingAccountAddress.accountAddressID){
					this.baseEntity.shippingAccountAddress = option;
					break;
				}
			}
		}
        
        this.baseEntity.shippingMethod = this.shippingMethodOptions[0];
	
	    this.newAccountAddress = {
        	address:{}
	    };	
	}
	
	public save = () =>{
		var formDataToPost:any = {
			entityID: this.baseEntityPrimaryID,
			entityName: this.baseEntityName,
			context: this.processContext,
			propertyIdentifiersList: 'shippingAccountAddress,shippingMethod,account.accountAddressOptions,' + this.orderTemplateService.orderTemplatePropertyIdentifierList
		};
		
		if(this.showCreateShippingAddress){
			formDataToPost.newAccountAddress = this.newAccountAddress;
			formDataToPost.newAccountAddress.address.stateCode = this.newAccountAddress.address.stateCode.stateCode;
			formDataToPost.newAccountAddress.address.countryCode = this.newAccountAddress.address.countryCode.countryCode;
		} else {
			formDataToPost.shippingAccountAddress = this.baseEntity.shippingAccountAddress;
		}
		
		formDataToPost.shippingMethodID = this.baseEntity.shippingMethod.value;
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise;
	}
}

class SWAccountShippingMethodModal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		modalButtonText:"@?"
	};
	public require = {
		swAccountShippingAddressCard:"^^swAccountShippingAddressCard"
	};
	
	public controller=SWAccountShippingMethodModalController;
	public controllerAs="swAccountShippingMethodModal";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAccountShippingMethodModal(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountshippingmethodmodal.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAccountShippingMethodModal
};

