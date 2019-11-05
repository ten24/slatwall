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
	public daysToEditFlexshipSetting:any;
	
		
	private orderTemplateTypeID:string = '2c948084697d51bd01697d5725650006'; // order-template-type-flexship 
	
	public initialized = false; 
	
	//@ngInject
	constructor(public orderTemplateService, public $window){
		
	}
	
	public $onInit = () => {
		this.fetchFlexships();
		this.orderTemplateService.getOrderTemplateSettings().then(data =>{
			this.daysToEditFlexshipSetting = data.orderTemplateSettings;
		})
	}
	
	private fetchFlexships = () => {

		this.orderTemplateService
    		.getOrderTemplates(this.orderTemplateTypeID )
			.then( (data) => {

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
			})
			.catch( (e) => {
				console.error(e);
			})
			.finally( () => {
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
				}
			})
			.catch((e) => {
				console.error(e);
			})
			.finally( () => {
				this.loading = false;
			});
	}
	
	public setAsCurrentFlexship(orderTemplateID:string) {

		// make api request
		this.orderTemplateService
			.setAsCurrentFlexship(orderTemplateID)
			.then((data) => {
				if (
					data.successfulActions &&
					data.successfulActions.indexOf('public:setAsCurrentFlexship') > -1
				) {
					this.$window.location.href = '/shop';
				} else {
					throw data;
				}
			})
			.catch( (error) => {
				console.error('setAsCurrentFlexship :', error);
				// TODO: show alert
			})
			.finally( () => {
				//TODO
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

