import { MonatService } from "@Monat/services/monatservice";
import { PublicService } from "@Monat/monatfrontend.module";
import { ObserverService } from "@Hibachi/core/core.module";
import { OrderTemplateService } from "@Monat/services/ordertemplateservice";

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
	public flexshipProductList;
	public sponsorErrors: any = {};
	public frequencyTerms:any;
	public flexshipDaysOfMonth:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]; 
	public accountPriceGroupCode:number = 3; //Hardcoded pricegroup as we always want to serve VIP pricing
	public currencyCode:any;
	public flexshipOrderTemplate:any;
	public holdingShippingAddressID:string;
	public holdingShippingMethodID:string;
	public flexshipDeliveryDate;
	public flexshipFrequencyName;
	public flexshipFrequencyHasErrors: boolean = false;
	public flexshipItemList:any;
	public recordsCount;
	public flexshipTotal:number = 0;
	public lastAddedProductName;
	public addedItemToCart;
	public defaultTerm;
	public termMap = {};
	public isInitialized = false;
	public paginationMethod = 'getproductsByCategoryOrContentID';
	public productRecordsCount: number;
	public flexshipProductRecordsCount:number;
	public paginationObject = {hideProductPacksAndDisplayOnly: true};
	public flexshipPaginationObject = {hideProductPacksAndDisplayOnly: true, flexshipFlag: true};
	public upgradeFlow:boolean;
	public endpoint: 'setUpgradeOnOrder' | 'setUpgradeOrderType' = 'setUpgradeOnOrder';
	public showUpgradeErrorMessage:boolean;
	public hairProductFilter:any;
	public skinProductFilter:any;
	public pageRecordsShow:number = 40;
	
	// @ngInject
	constructor(
	    public monatService         : MonatService, 
	    public publicService        : PublicService, 
	    public observerService      : ObserverService, 
	    public orderTemplateService : OrderTemplateService
	){}

	public $onInit = () => {
		if(this.upgradeFlow){
			this.endpoint = 'setUpgradeOrderType';
		}
		
		this.publicService.doAction(this.endpoint, {upgradeType: 'VIP'}).then(res=>{
			if(this.endpoint == 'setUpgradeOrderType' && res.upgradeResponseFailure?.length){
				this.showUpgradeErrorMessage = true;
				this.monatService.hasOwnerAccountOnSession = res.hasOwnerAccountOnSession;
				this.isInitialized = true;
				return;
			}
			
			this.monatService.hasOwnerAccountOnSession = res.hasOwnerAccountOnSession;
			this.isInitialized = true;
			this.getCountryCodeOptions();
			this.getFrequencyTermOptions();
			this.getProductList();
			this.getFlexshipProductList();
		});
		
	}
	
	public getFrequencyTermOptions = ():void =>{
		this.publicService.doAction('getFrequencyTermOptions').then(response => {
			this.frequencyTerms = response.frequencyTermOptions;
			this.publicService['model'] = {};
			this.publicService['term'] = response.frequencyTermOptions[0]; 
			for(let term of response.frequencyTermOptions){
				this.termMap[term.value] = term;
			}
		});
	}

	public adjustInputFocuses = () => {
		this.monatService.adjustInputFocuses();
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
		this.publicService['marketPartnerResults'] = this.publicService.doAction(
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
	
	public searchByKeyword = (keyword:string, flexshipFlag?:boolean) =>{
		let data:any = {
			keyword: keyword,
			priceGroupCode: 3,
			hideProductPacksAndDisplayOnly: true
		};
		if(flexshipFlag){
			data.flexshipFlag = flexshipFlag;
		}
		this.publicService.doAction('getProductsByKeyword', data).then(res=> {
			this.paginationMethod = 'getProductsByKeyword';
			if(flexshipFlag){
				this.flexshipProductRecordsCount = res.recordsCount;
				this.flexshipPaginationObject['keyword'] = keyword;
				this.flexshipProductList = res.productList;
			}else{
				this.productRecordsCount = res.recordsCount;
				this.paginationObject['keyword'] = keyword;
				this.productList = res.productList;
			}
			this.observerService.notify("PromiseComplete");
		});
	}
	
	public getFlexshipProductList = ( category?:any, categoryType?:string ) => {
		this.loading = true;
		
		let data:any = {
			priceGroupCode: 3,
			hideProductPacksAndDisplayOnly: true,
			flexshipFlag:true,
			pageRecordsShow:this.pageRecordsShow
		};
		
		if(category){
			data.categoryFilterFlag = true;
			data.categoryID = category.value;
			this.hairProductFilter = null;
			this.skinProductFilter = null;
			this[`${categoryType}ProductFilter`] = category;
			this.paginationObject['categoryID'] = category.value;
		}
		
		this.publicService.doAction('getProductsByCategoryOrContentID', data, 'GET').then((result) => {
			this.observerService.notify("PromiseComplete");
			this.flexshipProductList = result.productList;
			this.flexshipProductRecordsCount = result.recordsCount
			this.loading = false;
		});
	}

	public getProductList = ( category?:any, categoryType?:string ) => {
		this.loading = true;
		
		let data:any = {
			priceGroupCode: 3,
			hideProductPacksAndDisplayOnly: true,
			pageRecordsShow:this.pageRecordsShow
		};
		
		if(category){
			data.categoryFilterFlag = true;
			data.categoryID = category.value;
			this.hairProductFilter = null;
			this.skinProductFilter = null;
			this[`${categoryType}ProductFilter`] = category;
			this.paginationObject['categoryID'] = category.value;
		}
		
		this.publicService.doAction('getproductsByCategoryOrContentID', data, 'GET').then((result) => {
			this.observerService.notify("PromiseComplete");
			this.productList = result.productList;
			this.productRecordsCount = result.recordsCount
			this.loading = false;
		});
	}
    
    public setOrderTemplateFrequency = (frequencyTerm, dayOfMonth) => {
		
		
		//TODO: REFACTOR MARKUP TO USE NGOPTIONS
    	if("string" == typeof(frequencyTerm)){
			frequencyTerm = this.termMap[frequencyTerm];
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
        const flexshipID = this.orderTemplateService.currentOrderTemplateID;
        this.orderTemplateService.updateOrderTemplateFrequency(flexshipID, frequencyTerm.value, dayOfMonth).then(result => {
            this.getFlexshipDetails();
        });
    }
    
    public getFlexshipDetails = () => {
    	this.loading = true;
    	const flexshipID = this.orderTemplateService.currentOrderTemplateID;
    	
    	// Q: why get-wishlist-items
        this.orderTemplateService.getWishlistItems(flexshipID).then(result => { 
        	this.flexshipItemList = result.orderTemplateItems;
			this.flexshipTotal = result.orderTotal;
			this.observerService.notify('onNext');
        	this.loading = false;
        });
    }
	
	public showAddToCartMessage = () => {
		var skuID = this.monatService.lastAddedSkuID;
		
		this.monatService.getCart().then( (data: any) => {

			var orderItem;
			data.orderItems.forEach( item => {
				if ( item.sku.skuID === skuID ) {
					orderItem = item;
				}
			});
			
			let productTypeName = orderItem.sku.product.productType.productTypeName;
			this.lastAddedProductName = orderItem.sku.product.productName;
			this.addedItemToCart = true;
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
	public bindToController = {
		upgradeFlow:'<?'
	};
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
