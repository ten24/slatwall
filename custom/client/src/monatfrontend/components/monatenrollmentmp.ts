class EnrollmentMPController {
	public Account_CreateAccount;
	public isMPEnrollment: boolean = false;
	public countryCodeOptions: any = [];
	public stateCodeOptions: any = [];
	public currentCountryCode: string = '';
	public loading: boolean = false;
	public contentId: string;
	public selectedMP: any;
	public bundleHasErrors: boolean = false;
	public sponsorHasErrors: boolean = false;
	public openedBundle: any;
	public selectedBundleID: string = '';
	public bundles: any = [];
	public step: any;
	public productList;
	public pageTracker: number;
	public totalPages: Array<number>;
	// @ngInject
	constructor(public publicService, public observerService, public monatService) {
		this.observerService.attatch(this.getProductList, 'createSuccess'); 
	}
	
	public $onInit = () => {
		this.getCountryCodeOptions();
		this.getStarterPacks();
	};

	public getStarterPacks = () => {
		this.publicService
			.doAction('getStarterPackBundleStruct', { contentID: this.contentId })
			.then((data) => {
				this.bundles = data.bundles;
			});
	};

	public submitStarterPack = () => {
        if ( this.selectedBundleID.length ) {
        	this.monatService.addToCart( this.selectedBundleID, 1 ).then(data => {
        		console.log( data );
            	this.observerService.notify('onNext');
        	})
        } else {
            this.bundleHasErrors = true;
        }
    }

	public submitSponsor = () => {
		if (this.selectedMP) {
			this.observerService.notify('onNext');
		} else {
			this.sponsorHasErrors = true;
		}
	};

	public selectBundle = (bundleID) => {
		this.selectedBundleID = bundleID;
		this.bundleHasErrors = false;
		this.openedBundle = null;
	};

	private stripHtml = (html) => {
		let tmp = document.createElement('div');
		tmp.innerHTML = html;
		return tmp.textContent || tmp.innerText || '';
	};

	public getMpResults = (model) => {
		this.publicService.marketPartnerResults = this.publicService.doAction(
			'/?slatAction=monat:public.getmarketpartners' +
				'&search=' +
				model.mpSearchText +
				'&currentPage=' +
				1 +
				'&accountSearchType=marketPartner' +
				'&countryCode=' +
				model.currentCountryCode +
				'&stateCode=' +
				model.currentStateCode,
		);
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

	public setOwnerAccount = (ownerAccountID) => {
		this.loading = true;
		this.publicService
			.doAction('setOwnerAccountOnAccount', { ownerAccountID: ownerAccountID })
			.then((result) => {
				console.log(result);
				this.loading = false;
			});
	};

	public getProductList = (pageNumber = 1, direction: any = false, newPages = false) => {
		this.loading = true;
		const pageRecordsShow = 5;
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
}

class MonatEnrollmentMP {
	public require = {
		ngModel: '?^ngModel',
	};
	public priority = 1000;
	public restrict = 'A';
	public scope = true;
	/**
	 * Binds all of our variables to the controller so we can access using this
	 */

	public bindToController = {
		step: '@?',
		contentId: '@',
	};

	public controller = EnrollmentMPController;
	public controllerAs = 'enrollmentMp';
	// @ngInject
	constructor() {}

	public static Factory() {
		var directive = () => new MonatEnrollmentMP();
		directive.$inject = [];
		return directive;
	}
}
export { MonatEnrollmentMP };
