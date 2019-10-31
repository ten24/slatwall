class MonatFlexshipListingController{
	
	public orderTemplates: any[];
	public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public stateCodeOptions: any[];
	public shippingMethodOptions: any[];
	public cancellationReasonTypeOptions: any[];
	public scheduleDateChangeReasonTypeOptions: any[];
	public expirationMonthOptions: any[];
	public expirationYearOptions: any[];
	public loading: boolean = false;
	
	public initialized = false; 
	
	//@ngInject
	constructor(public orderTemplateService, public $window){
		
	}
	
	public $onInit = () => {
		this.orderTemplateService.getOrderTemplates()
			.then((data) => {
				this.accountAddresses = data.accountAddresses;
				this.accountPaymentMethods = data.accountPaymentMethods;
				this.shippingMethodOptions = data.shippingMethodOptions;
				this.stateCodeOptions = data.stateCodeOptions;
				this.cancellationReasonTypeOptions = data.cancellationReasonTypeOptions;
				this.scheduleDateChangeReasonTypeOptions = data.scheduleDateChangeReasonTypeOptions;
				this.expirationMonthOptions = data.expirationMonthOptions;
				this.expirationYearOptions = data.expirationYearOptions;
				
				//set this last so that ng repeat inits with all needed data
				this.orderTemplates = data.orderTemplates; 
			}, (reason) => {
				console.error(reason);
			}).finally(()=>{
				this.initialized=true; 
			});
	}
	
	public createNewFlexship = () => {
		this.loading = true;
		this.orderTemplateService.createOrderTemplate('ottSchedule')
			.then((data) => {
				if(data.orderTemplate){
					this.setAsCurrentFlexship(data.orderTemplate); //data.orderTemplate is's the Id of newly created flexship
				} else{
					throw(data);
					this.loading = false;
				}
			})
			.catch((error) => {
				this.loading = false;
			});
	}
	
	public setAsCurrentFlexship(orderTemplate) {
		// make api request
		this.orderTemplateService
			.setAsCurrentFlexship(orderTemplate)
			.then((data) => {
				if (
					data.successfulActions &&
					data.successfulActions.indexOf('public:setAsCurrentFlexship') > -1
				) {
					this.$window.location.href = '/shop';
				} else {
					throw data;
					this.loading = false;
				}
			})
			.catch((error) => {
				console.error('setAsCurrentFlexship :', error);
				this.loading = false;
				// TODO: show alert
			});
	}

}

class MonatFlexshipListing {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	};
	public controller=MonatFlexshipListingController;
	public controllerAs="monatFlexshipListing";

	public static Factory(){
		var directive:any = (
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
		) => new MonatFlexshipListing (
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexshiplisting.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipListing
};

