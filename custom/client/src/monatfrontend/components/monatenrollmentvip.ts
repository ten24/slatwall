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
	public flexshipItemList:any;
	public holdingShippingAddressID:string;
	public holdingShippingMethodID:string;

	// @ngInject
	constructor(public publicService, public observerService, public monatService, public orderTemplateService) {
	}

	public $onInit = () => {
		this.getCountryCodeOptions();
		this.publicService.doAction('getFrequencyTermOptions').then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
		})
		
		//checks to local storage in case user has refreshed
		if(localStorage.getItem('shippingAddressID')){ 
			this.holdingShippingAddressID = localStorage.getItem('shippingAddressID');
		}
		
		if(localStorage.getItem('shippingMethodID')){
			this.holdingShippingMethodID = localStorage.getItem('shippingMethodID');
		}
		
    	this.observerService.attach(this.getFlexshipItems,"lastStep");
    	this.observerService.attach(this.setOrderTemplateShippingAddress,"addShippingMethodUsingShippingMethodIDSuccess");
    	this.observerService.attach(this.setOrderTemplateShippingAddress,"addShippingAddressUsingAccountAddressSuccess");

		this.observerService.attach((accountAddress)=>{
			localStorage.setItem('shippingAddressID',accountAddress.accountAddressID); 
			this.holdingShippingAddressID = accountAddress.accountAddressID;
		}, 'shippingAddressSelected');
		
		this.observerService.attach((shippingMethod)=>{
			localStorage.setItem('shippingMethodID',shippingMethod.shippingMethodID);
			this.holdingShippingMethodID = shippingMethod.shippingMethodID;
		}, 'shippingMethodSelected');
		
	};
	public setOrderTemplateShippingAddress = () =>{
		if(!this.holdingShippingMethodID || !this.holdingShippingAddressID){
			return;
		}
		this.loading = true;
		let payload = {};
		payload['orderTemplateID'] = this.flexshipID;
		payload['shippingAccountAddress.value'] = this.holdingShippingAddressID;
		payload['shippingMethod.shippingMethodID']= this.holdingShippingMethodID;
		
		this.orderTemplateService.updateShipping(payload).then(response => {
			this.loading = false;
		})
	}
	
	public setOrderTemplateBilling = () =>{
		this.loading = true;
		let payload = {};
		payload['orderTemplateID'] = this.flexshipID;
		payload['billingAccountAddress.value'] = this.holdingShippingAddressID;
		payload['accountPaymentMethod.value']= this.holdingShippingMethodID;
		
		this.orderTemplateService.updateBilling(payload).then(response => {
			this.loading = false;
		})
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
        });
    }
    
    public setOrderTemplateFrequency = (frequencyTermID, dayOfMonth) => {
        this.loading = true;
        const flexshipID = this.flexshipID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, frequencyTermID, dayOfMonth).then(result => {
            this.loading = false;
        });
    }
    
    public getFlexshipItems = () =>{
    	this.loading = true;
        const flexshipID = this.flexshipID;
        this.orderTemplateService.getWishlistItems(flexshipID).then(result => {
        	this.flexshipItemList = result.orderTemplateItems;
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
