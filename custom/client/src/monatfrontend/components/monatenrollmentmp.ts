declare var $;

class EnrollmentMPController {
	public Account_CreateAccount;
	public isMPEnrollment: boolean = false;
	public countryCodeOptions: any = [];
	public stateCodeOptions: any = [];
	public currentCountryCode: string = '';
	public loading: boolean = false;
	public contentId: string;
	public bundleErrors: Array<any> = [];
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
	public paginationMethod = 'getStarterPackBundleStruct';
	public paginationObject = {};
	
	public loadingBundles: boolean = false;
	
	// @ngInject
	constructor(public publicService, public observerService, public monatService, private rbkeyService) {}
	
	public $onInit = () => {
		this.getDateOptions();
		this.observerService.attach(this.getProductList, 'createSuccess'); 
		this.observerService.attach(this.showAddToCartMessage, 'addOrderItemSuccess'); 
		$('.site-tooltip').tooltip();
		this.publicService.doAction('setUpgradeOnOrder', {upgradeType: 'marketPartner'}).then(res=>{
			this.getStarterPacks();
			this.getProductList();	
		});
	}
	
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
	
	public searchByKeyword = (keyword:string) =>{
		this.publicService.doAction('getProductsByKeyword', {keyword: keyword, priceGroupCode: 1}).then(res=> {
			this.paginationMethod = 'getProductsByKeyword';
			this.productRecordsCount = res.recordsCount;
			this.paginationObject['keyword'] = keyword;
			this.productList = res.productList;
			this.observerService.notify("PromiseComplete");
		});
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
			} else{
			    this.addedItemToCart = false;
			}
		})
	}

	public getStarterPacks = () => {
		this.loadingBundles = true;
		
		this.publicService
			.doAction('getStarterPackBundleStruct', { contentID: this.contentId })
			.then((data) => {
				this.loadingBundles = false;
				this.bundles = data.bundles;
				//truncating string
				for(let bundle in this.bundles){
					let str = this.stripHtml(this.bundles[bundle].description);
					this.bundles[bundle].description = str.length > 70 ? str.substring(0, str.indexOf(' ', 60)) + '...' : str;
				}
			});
	};

	public submitStarterPack = () => {
		
		this.bundleErrors = [];
		
        if ( this.selectedBundleID.length ) {
			this.loading = true;
			this.monatService.selectStarterPackBundle( this.selectedBundleID ).then(data => {
				this.loading = false;
        		
				if ( data.hasErrors ) {
					for ( let error in data.errors ) {
						this.bundleErrors = this.bundleErrors.concat( data.errors[ error ] );
					}
				} else {
					this.observerService.notify('onNext');
				}
    		});
        } else {
            this.bundleErrors.push( this.rbkeyService.rbKey('frontend.enrollment.selectPack'));
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

	public selectBundle = ( bundleID, $event ) => {
		$event.preventDefault();
		
		this.selectedBundleID = bundleID;
		this.bundleErrors = [];
	};

	private stripHtml = (html) => {
		let tmp = document.createElement('div');
		tmp.innerHTML = html;
		return tmp.textContent || tmp.innerText || '';
	};

	public getProductList = () => {
		this.loading = true;
		this.publicService.doAction('getproductsByCategoryOrContentID', {priceGroupCode: 1}).then((result) => {
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
