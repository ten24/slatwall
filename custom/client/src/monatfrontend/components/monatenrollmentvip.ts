class VIPController {
	public loading:boolean=false;
	public pageTracker: number;
	public totalPages: Array<number>;
	public Account_CreateAccount;
	public countryCodeOptions: any = [];
	public stateCodeOptions: any = [];
	public currentCountryCode: string = '';
	public currentStateCode: string = '';
	public mpSearchText: string = '';
	public currentMpPage: number = 1;
	public isVIPEnrollment: boolean = false;
	public productList;
	public sponsorHasErrors: boolean = false;
	public selectedMP: any;
	public flexshipID:any;
	public accountPriceGroupCode:number = 3; //Hardcoded pricegroup as we always want to serve VIP pricing
	public currencyCode:any;

	// @ngInject
	constructor(public publicService, public observerService, public monatService,public orderTemplateService) {
		this.observerService.attach(this.getProductList, 'createSuccess'); 
	}

	public $onInit = () => {
		this.getCountryCodeOptions();
	};

	public getCountryCodeOptions = () => {
		if (this.countryCodeOptions.length) {
			return this.countryCodeOptions;
		}

		this.publicService.getCountries().then((data) => {
			this.countryCodeOptions = data.countryCodeOptions;
		});
	};

	public getStateCodeOptions = (countryCode) => {
		this.currentCountryCode = countryCode;

		this.publicService.getStates(countryCode).then((data) => {
			this.stateCodeOptions = data.stateCodeOptions;
		});
	};

	public getMpResults = (model) => {
		this.publicService.marketPartnerResults = this.publicService.doAction(
			'/?slatAction=monat:public.getmarketpartners' +
				'&search=' +
				model.mpSearchText +
				'&currentPage=' +
				this.currentMpPage +
				'&accountSearchType=VIP' +
				'&countryCode=' +
				model.currentCountryCode +
				'&stateCode=' +
				model.currentStateCode,
		);
	};
	
	public submitSponsor = () => {
		this.loading = true;
		if (this.selectedMP) {
			this.monatService.submitSponsor(this.selectedMP.accountID).then(data=> {
				if(data.successfulActions && data.successfulActions.length){
					this.observerService.notify('onNext');
				}else{
					this.sponsorHasErrors = true;
				}
				this.loading = false;
			})
		} else {
			this.sponsorHasErrors = true;
			this.loading = false;
		}
	};
	
	public getProductList = () => {
		this.loading = true;
		this.publicService.doAction('getProductsByCategoryOrContentID', { 'priceGroupCode': this.accountPriceGroupCode, 'currencyCode': this.currencyCode }).then((result) => {
			this.productList = result.productList;
			this.loading = false;
		});
	};

    public createOrderTemplate = (orderTemplateSystemCode:string = 'ottSchedule') => {
        this.loading = true;
        this.orderTemplateService.createOrderTemplate(orderTemplateSystemCode).then(result => {
        	this.flexshipID = result.orderTemplate;
            this.loading = false;
            this.observerService.notify('onNext');
        });
    }
}

class MonatEnrollmentVIP {
	public require = {
		ngModel: '?^ngModel',
	};
	public priority = 1000;
	public restrict = 'A';
	public scope = true;
	/**
	 * Binds all of our variables to the controller so we can access using this
	 */
	public bindToController = {};
	public controller = VIPController;
	public controllerAs = 'vipController';
	// @ngInject
	constructor() {}

	public static Factory() {
		var directive = () => new MonatEnrollmentVIP();
		directive.$inject = [];
		return directive;
	}
}
export { MonatEnrollmentVIP };
