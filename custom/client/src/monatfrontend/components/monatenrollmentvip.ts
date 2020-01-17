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
	public sponsorErrors: any = {};
	public flexshipID:any;
	public frequencyTerms:any;
	public flexshipDaysOfMonth:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]; 
	public accountPriceGroupCode:number = 3; //Hardcoded pricegroup as we always want to serve VIP pricing
	public currencyCode:any;
	public flexshipOrderTemplate:any;
	public holdingShippingAddressID:string;
	public holdingShippingMethodID:string;
	public flexshipDeliveryDate;
	public flexshipFrequencyName;
	public flexshipFrequencyHasErrors: boolean = false;
	public isNotSafariPrivate:boolean;
	public flexshipItemList:any;
	public recordsCount;
	public flexshipTotal:number = 0;
	public lastAddedProductName;
	public addedItemToCart;
	public defaultTerm;
	
	// @ngInject
	constructor(public publicService, public observerService, public monatService, public orderTemplateService) {
	}

	public $onInit = () => {
		this.getCountryCodeOptions();
		this.publicService.doAction('getFrequencyTermOptions').then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
			for(let term of response.frequencyTermOptions){
				if(term.name=='Monthly'){
					this.defaultTerm = term;
				}
			}
		})
		
		//checks to local storage in case user has refreshed
		if(localStorage.getItem('shippingAddressID')){ 
			this.holdingShippingAddressID = localStorage.getItem('shippingAddressID');
		}
		
		if(localStorage.getItem('shippingMethodID')){
			this.holdingShippingMethodID = localStorage.getItem('shippingMethodID');
		}
				
		if(localStorage.getItem('flexshipDayOfMonth')){
    		this.flexshipDeliveryDate = localStorage.getItem('flexshipDayOfMonth');
		}
		
		if(localStorage.getItem('flexshipFrequency')){
	    	this.flexshipFrequencyName = localStorage.getItem('flexshipFrequency');
		}
		
		if(localStorage.getItem('flexshipID')){
	    	this.flexshipID = localStorage.getItem('flexshipID');
	    	this.getProductList();
		}
		
    	this.observerService.attach(this.getFlexshipDetails,"lastStep"); 
    	this.observerService.attach(this.getProductList,"createSuccess");
		this.observerService.attach(this.showAddToCartMessage, 'addOrderItemSuccess'); 
		

		this.localStorageCheck(); 
		
		if(this.isNotSafariPrivate){
			this.observerService.attach((accountAddress)=>{
				localStorage.setItem('shippingAddressID',accountAddress.accountAddressID); 
				this.holdingShippingAddressID = accountAddress.accountAddressID;
			}, 'shippingAddressSelected');
			
			this.observerService.attach((shippingMethod)=>{
				localStorage.setItem('shippingMethodID',shippingMethod.shippingMethodID);
				this.holdingShippingMethodID = shippingMethod.shippingMethodID;
			}, 'shippingMethodSelected');			
		}
	
	}

	public adjustInputFocuses = () => {
		this.monatService.adjustInputFocuses();
	}
	
	//check to see if we can use local storage
	public localStorageCheck = () => {
		try {
			localStorage.setItem('test', '1');
			localStorage.removeItem('test');
			this.isNotSafariPrivate = true;
		} catch (error) {
			this.isNotSafariPrivate = false;
		}
	}

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
	
	public getProductList = () => {
		this.loading = true;
		
		this.publicService.doAction('getProductsByCategoryOrContentID').then((result) => {
            this.productList = result.productList;
            this.recordsCount = result.recordsCount;
			this.observerService.notify('PromiseComplete');
            this.loading = false;
		});
	};

    public createOrderTemplate = (orderTemplateSystemCode:string = 'ottSchedule') => {
        this.loading = true;
        this.orderTemplateService.createOrderTemplate(orderTemplateSystemCode).then(result => {
        	this.flexshipID = result.orderTemplate;
        	if(this.isNotSafariPrivate && this.flexshipID){
        		localStorage.setItem('flexshipID', this.flexshipID);
        	}
        	
            this.loading = false;
        });
    }
    
    public setOrderTemplateFrequency = (frequencyTerm, dayOfMonth) => {

    	if("string" == typeof(frequencyTerm)){
    		let holdingValue = frequencyTerm;
    		frequencyTerm = {};
    		frequencyTerm.value = holdingValue;
    		frequencyTerm.name = frequencyTerm.value == '2c92808469a0e1ec0169a132879f0020' ? 'Bi-Monthly' : 'Monthly';
    	}

		if (
			'undefined' === typeof frequencyTerm
			|| 'undefined' === typeof dayOfMonth
		) {
			this.flexshipFrequencyHasErrors = true;
			return false;
		} else {
			this.flexshipFrequencyHasErrors = false;
		}
		
        this.loading = true;
        this.flexshipDeliveryDate = dayOfMonth;
		this.flexshipFrequencyName = frequencyTerm.name;
		
		if(this.isNotSafariPrivate){
			localStorage.setItem('flexshipDayOfMonth', dayOfMonth);
			localStorage.setItem('flexshipFrequency', frequencyTerm.name);	
		}
    
        const flexshipID = this.flexshipID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, frequencyTerm.value, dayOfMonth).then(result => {
            this.getFlexshipDetails();
        });
    }
    
    public getFlexshipDetails = () => {
    	this.loading = true;
    
        this.orderTemplateService.getWishlistItems(this.flexshipID).then(result => {
        	this.flexshipItemList = result.orderTemplateItems;
			this.flexshipTotal = result.orderTotal;
			this.observerService.notify('onNext');
        	this.loading = false;
        });
    }
    
	public editFlexshipItems = () => {
		this.observerService.notify('editFlexshipItems');
	}
	
	public editFlexshipDate = () => {
		this.observerService.notify('editFlexshipDate');
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
			} else {
			    this.addedItemToCart = false;
			}
		})
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
