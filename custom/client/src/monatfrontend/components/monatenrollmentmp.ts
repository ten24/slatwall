declare var $;

class EnrollmentMPController {
	public Account_CreateAccount;
	public isMPEnrollment: boolean = false;
	public countryCodeOptions: any = [];
	public stateCodeOptions: any = [];
	public currentCountryCode: string = '';
	public loading: boolean = false;
	public contentId: string;
	public bundleHasErrors: boolean = false;
	public sponsorErrors: any = {};
	public openedBundle: any;
	public selectedBundleID: string = '';
	public bundles: any = [];
	public step: any;
	public productList;
	public addedItemToCart: boolean = false;
	public lastAddedProductName: string = '';
	public yearOptions: Array<number|string> = [];
	public dayOptions: Array<number|string> = [];
	public monthOptions: Array<number|string> = [];
	public currentDate: any;
	public productRecordsCount:any;
	
	// @ngInject
	constructor(public publicService, public observerService, public monatService) {}
	
	public $onInit = () => {
		this.getDateOptions();
		//this.getProductList()
		
		this.observerService.attach(this.getStarterPacks, 'createSuccess'); 
		this.observerService.attach(this.getProductList, 'createSuccess'); 
		this.observerService.attach(this.showAddToCartMessage, 'addOrderItemSuccess'); 
		
		$('.site-tooltip').tooltip();
	};
	
	public adjustInputFocuses = () => {
		this.monatService.adjustInputFocuses();
	}
	
	public getDateOptions = () => {
		this.currentDate = new Date();
		
		// Setup Years
		for ( var i = this.currentDate.getFullYear(); i >= 1900; i-- ) {
			this.yearOptions.push( i );
		}
		
		// Setup Months / Default Days
		for ( i = 1; i <= 31; i++ ) {
			var label = ( '0' + i ).slice(-2);
			if ( i < 13 ) {
				this.monthOptions.push( label );
			}
			this.dayOptions.push( label );
		}
	}
	
	public setDayOptionsByDate = ( year = null, month = null ) => {
		
		if ( null === year ) {
			year = this.currentDate.getFullYear();
		}
		
		if ( null === month ) {
			year = this.currentDate.getMonth();
		}
		
		var newDayOptions = [];
		var daysInMonth = new Date( year, month, 0 ).getDate();
		for ( var i = 1; i <= daysInMonth; i++ ) {
			newDayOptions.push( ( '0' + i ).slice(-2) );
		}
		this.dayOptions = newDayOptions;
	}
	
	public showAddToCartMessage = () => {
		var skuID = this.monatService.lastAddedSkuID;
		
		this.monatService.getCart().then( data => {

			var orderItem;
			data.orderItems.forEach( item => {
				if ( item.sku.skuID === skuID ) {
					orderItem = item;
				}
			});
			
			let productTypeName = orderItem.sku.product.productType.productTypeName;
			if ( 'Starter Kit' !== productTypeName && 'Product Pack' !== productTypeName ) {
				this.lastAddedProductName = orderItem.sku.product.productName;
				this.addedItemToCart = true;
			}
		})
	}

	public getStarterPacks = () => {
		this.publicService
			.doAction('getStarterPackBundleStruct', { contentID: this.contentId })
			.then((data) => {
				this.bundles = data.bundles;
			});
	};

	public submitStarterPack = () => {
        if ( this.selectedBundleID.length ) {
			this.loading = true;
        	this.monatService.selectStarterPackBundle( this.selectedBundleID ).then(data => {
        		this.loading = false;
            	this.observerService.notify('onNext');
        	})
        } else {
            this.bundleHasErrors = true;
        }
    }

	public submitSponsor = () => {
		this.loading = true;
		
		var selectedSponsor = document.getElementById('selected-sponsor-id');
		
		if ( null !== selectedSponsor ) {
			this.sponsorErrors.selected = false;
			var accountID = (<HTMLInputElement>selectedSponsor).value;
			
			this.monatService.submitSponsor( accountID ).then(data=> {
				if(data.successfulActions && data.successfulActions.length){
					this.observerService.notify('onNext');
					this.sponsorErrors = {};
				}else{
					this.sponsorErrors.submit = true;
				}
				this.loading = false;
			})
		} else {
			this.sponsorErrors.selected = true;
			this.loading = false;
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

	public getProductList = (pageNumber = 1, pageRecordsShow = 12 ) => {
		this.loading = true;
		this.publicService.doAction('getproducts', { pageRecordsShow: pageRecordsShow, currentPage: pageNumber }).then((result) => {
			this.observerService.notify("PromiseComplete");
			this.productList = result.productList;
			this.productRecordsCount = result.recordsCount
			this.loading = false;
		});
	}
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
