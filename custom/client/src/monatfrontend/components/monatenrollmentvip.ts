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
	public frequencyTerms:any;
	public flexshipDaysOfMonth:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]; 


	// @ngInject
	constructor(public publicService, public observerService, public monatService,public orderTemplateService) {
		this.observerService.attach(this.getProductList, 'createSuccess'); 
	}

	public $onInit = () => {
		this.getCountryCodeOptions();
		this.publicService.doAction('getFrequencyTermOptions').then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
		})
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
	
	public getProductList = (pageNumber = 1, direction: any = false, newPages = false) => {
		this.loading = true;
		const pageRecordsShow = 12;
		let setNew;

		if (pageNumber === 1) {
			setNew = true;
		}

		//Pagination logic TODO: abstract into a more reusable method
		if (direction === 'prev') {
			setNew = false;
			if (this.pageTracker === 1) {
				return pageNumber;
			} else if (this.pageTracker === this.totalPages[0] + 1) {
				// If user is at the beggining of a new set of ten (ie: page 11) and clicks back, reset totalPages to include prior ten pages
				let q = this.totalPages[0];
				pageNumber = q;
				//its not beautiful but it works
				this.totalPages.unshift(
					q - 10,
					q - 9,
					q - 8,
					q - 7,
					q - 6,
					q - 5,
					q - 4,
					q - 3,
					q - 2,
					q - 1,
				);
			} else {
				pageNumber = this.pageTracker - 1;
			}
		} else if (direction === 'next') {
			setNew = false;
			if (this.pageTracker >= this.totalPages[this.totalPages.length - 1]) {
				pageNumber = this.totalPages.length;
				return pageNumber;
			} else if (this.pageTracker === this.totalPages[9] + 1) {
				newPages = true;
			} else {
				pageNumber = this.pageTracker + 1;
			}
		}

		if (newPages) {
			// If user is at the end of 10 page length display, get next 10 pages
			pageNumber = this.totalPages[10] + 1;
			this.totalPages.splice(0, 10);
			setNew = false;
		}

		this.publicService
			.doAction('getproducts', { pageRecordsShow: pageRecordsShow, currentPage: pageNumber })
			.then((result) => {
				this.productList = result.productListing;

				if (setNew) {
					const holdingArray = [];
					const pages = Math.ceil(result.recordsCount / pageRecordsShow);

					for (var i = 0; i <= pages - 1; i++) {
						holdingArray.push(i);
					}

					this.totalPages = holdingArray;
				}
				this.pageTracker = pageNumber;
				this.loading = false;
			});
	};

    public createOrderTemplate = (orderTemplateSystemCode:string = 'ottSchedule') => {
        this.loading = true;
        this.orderTemplateService.createOrderTemplate(orderTemplateSystemCode).then(result => {
        	this.flexshipID = result.orderTemplate;
            this.loading = false;
        });
    }
    
    public setOrderTemplateFrequency = (frequencyTermID, dayOfMonth) => {
        this.loading = true;
        const flexshipID = this.flexshipID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, frequencyTermID, dayOfMonth).then(result => {
            this.loading = false;
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
