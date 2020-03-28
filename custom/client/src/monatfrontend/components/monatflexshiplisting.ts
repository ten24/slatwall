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
	public account:any;
	public customerCanCreateFlexship:boolean;
	public countryCodeBySite :any;
		
	private orderTemplateTypeID:string = '2c948084697d51bd01697d5725650006'; // order-template-type-flexship 
	
	public initialized = false; 
	
	//@ngInject
	constructor(
		public orderTemplateService, 
		public $window, 
		public publicService,
		public observerService,
		public monatAlertService,
		public rbkeyService,
		public monatService
	){
		this.observerService.attach(this.fetchFlexships,"deleteOrderTemplateSuccess");
		this.observerService.attach(this.fetchFlexships,"updateFrequencySuccess");


	}
	
	public $onInit = () => {
		this.fetchFlexships();
		this.orderTemplateService.getOrderTemplateSettings().then(data =>{
			this.daysToEditFlexshipSetting = data.orderTemplateSettings;
		});
		
		this.account = this.publicService.account;
		this.getCanCreateFlexshipFlag();
	}
	
	private fetchFlexships = () => {

		this.orderTemplateService
    		.getOrderTemplates(this.orderTemplateTypeID, 100, 1, true )
			.then( (data) => {

				this.accountAddresses = data.accountAddresses;
				this.accountPaymentMethods = data.accountPaymentMethods;
				this.shippingMethodOptions = data.shippingMethodOptions;
				this.stateCodeOptions = data.stateCodeOptions;
				this.cancellationReasonTypeOptions = data.cancellationReasonTypeOptions;
				this.scheduleDateChangeReasonTypeOptions = data.scheduleDateChangeReasonTypeOptions;
				this.expirationMonthOptions = data.expirationMonthOptions;
				this.expirationYearOptions = data.expirationYearOptions;
				this.countryCodeBySite = data.countryCodeBySite;
				
				
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
		let siteID = this.publicService.cmsSiteID;
		let createURL = '/shop/?type=flexship&orderTemplateId=';
		
		if(siteID != 'default'){
			createURL = '/' + siteID + createURL;
		}
		
		this.orderTemplateService.createOrderTemplate('ottSchedule')
			.then((data) => {
				
				if (
					data.successfulActions &&
					data.successfulActions.indexOf('public:order.create') > -1
				) {
				    this.monatAlertService.success(this.rbkeyService.rbKey('frontend.flexshipCreateSucess'))
				    this.monatService.redirectToProperSite(
										'/shop/?type=flexship&orderTemplateId=' + data.orderTemplate
									);
				} else{
					throw(data);
				}
			})
			.catch((e) => {
			    this.monatAlertService.showErrorsFromResponse(e);
			})
			.finally( () => {
				this.loading = false;
			});
	}
	
	/**
	 * TODO: remove
	 * @depricated, not in use any more
	 * will be remove in later commits 
	 * 
	*/ 
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
	
	public getCanCreateFlexshipFlag = () => {
	    this.publicService.doAction('getCustomerCanCreateFlexship').then(res=>{
	       this.customerCanCreateFlexship = res.customerCanCreateFlexship;
	    });
	}

}

class MonatFlexshipListing {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {};
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

