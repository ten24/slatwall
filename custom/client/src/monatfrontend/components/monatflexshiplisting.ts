class MonatFlexshipListingController{
	
	public orderTemplates: any[];
	public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public stateCodeOptions: any[];
	public daysToEditFlexshipSetting:any;
	public account:any;
	public customerCanCreateFlexship:boolean;
	public countryCodeBySite :any;
		
	public loading: boolean = false;
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
		public monatService,
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
				this.stateCodeOptions = data.stateCodeOptions;
				this.countryCodeBySite = data.countryCodeBySite;
				
				//set this last so that ng repeat inits with all needed data
				this.orderTemplates = data.orderTemplates; 
				let newFlexshipID = this.monatService.getNewlyCreatedFlexship();
				if(newFlexshipID) {
					var newOrderTemplate = this.orderTemplates.find( ot => ot.orderTemplateID === newFlexshipID );
					if(newOrderTemplate){
						newOrderTemplate['isNew'] = true;
					}
					this.monatService.setNewlyCreatedFlexship(''); //unset
				}
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
		let createURL = '/flexship-flow/';
		
		if(siteID != 'default'){
			createURL = '/' + siteID + createURL;
		}
		
		this.orderTemplateService.createOrderTemplate('ottSchedule', 'save', true)
			.then((data) => {
				
				if (
					data.successfulActions &&
					data.successfulActions.indexOf('public:order.create') > -1
				) {
					this.monatService.setNewlyCreatedFlexship(data.orderTemplate); 
				    this.monatService.redirectToProperSite('/flexship-flow');
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
	
	public getCanCreateFlexshipFlag = () => {
	    this.publicService.doAction('getCustomerCanCreateFlexship').then(res=>{
	       this.customerCanCreateFlexship = res.customerCanCreateFlexship;
	    });
	}

}

class MonatFlexshipListing {

	public restrict = 'EA'
	public scope = {};
	public bindToController = {};
	public controller=MonatFlexshipListingController;
	public controllerAs="monatFlexshipListing";
	
	public template = require('./monatflexshiplisting.html');

	public static Factory() {
		return () => new this();
	}
}

export {
	MonatFlexshipListing
};

