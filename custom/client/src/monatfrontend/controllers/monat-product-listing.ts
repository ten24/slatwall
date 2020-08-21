import { MonatAlertService } from "@Monat/services/monatAlertService";
import { PublicService } from "@Monat/monatfrontend.module";
import { MonatService } from "@Monat/services/monatservice";
import { ObserverService } from "@Hibachi/core/core.module";
import { OrderTemplateService } from "@Monat/services/ordertemplateservice";

declare var $;

class MonatProductListingController {
    public loading:boolean;
    public accountData:any;
    public cmsContentID:string = '';  
    public argumentsObject:any = {};
    public productList:Array<any> = [];
    public cmsCategoryFilterFlag:boolean;
    public contentFilterFlag:boolean;
    public cmsContentFilterFlag:boolean;
    public pageRecordsShow:number = 40;
    public recordsCount:number;
    public callEndpoint = true;
    public showWishlist:boolean;
    public paginationMethod = 'getProductsByCategoryOrContentID';
    public searchTerm:string;
    public wishlistItems : string[];
	public hairProductFilter:any;
	public skinProductFilter:any;
	public loadingAddToCart;
	public flexshipFlag:boolean;
	
	// @ngInject
	constructor(
		public $rootScope           : ng.IRootScopeService,
		public publicService        : PublicService,
		public observerService      : ObserverService,
        private monatService        : MonatService,
		private monatAlertService   : MonatAlertService,
		private orderTemplateService: OrderTemplateService
	) {}

    
    public $onInit = () => {
        this.publicService.getCart();
        this.getWishlistItems();
    }
    
	public $postLink = () => {
        if(this.callEndpoint) this.getProducts();
        
        this.observerService.attach(this.getWishlistItems,'getAccountSuccess');
        this.observerService.attach(this.addWishlistItemID, 'addWishlistItemID');
	}
	
	public getWishlistItems = () => {
	    
		if(!this.publicService.account?.accountID){
			return;
		}
	    
	    this.orderTemplateService.getAccountWishlistItemIDs().then( wishlistItems => {
            this.wishlistItems = [];
            wishlistItems.forEach( item => this.wishlistItems.push(item.skuID) );
        });
	}
	
	public addWishlistItemID = (skuID) =>{
		this.wishlistItems.push(skuID);
	}
	
    public getProducts = (category?:any, categoryType?:string) => {
        this.loading = true;
        
        // CMS category ID is the only filter applied via ng-init and getting the CF category, due to content modules loop
        // All others are handled with headers, and only need the flag 
        if(this.cmsContentID.length && this.cmsContentFilterFlag) { 
            this.argumentsObject['cmsContentID'] = this.cmsContentID;  
            this.argumentsObject['cmsContentFilterFlag'] = true;  
        }

        if(this.contentFilterFlag) this.argumentsObject['contentFilterFlag'] = true;  
        if(this.cmsCategoryFilterFlag) this.argumentsObject['cmsCategoryFilterFlag'] = true; 
        
		if(category){
			this.argumentsObject['categoryFilterFlag'] = true;
			this.argumentsObject['categoryID'] = category.value;
			this.hairProductFilter = null;
			this.skinProductFilter = null;
			this[`${categoryType}ProductFilter`] = category;
		}
		
		if(this.flexshipFlag){
			this.argumentsObject['flexshipFlag'] = this.flexshipFlag;
		}
        
        this.argumentsObject['pageRecordsShow'] = this.pageRecordsShow;
        
        if(this.argumentsObject['categoryFilterFlag']){
        	this.argumentsObject['cmsCategoryFilterFlag'] = false;
        }
        
        this.argumentsObject.returnJsonObjects='';
        
        this.publicService.doAction('getProductsByCategoryOrContentID', this.argumentsObject).then(result => {
            this.productList = result.productList;
            this.recordsCount = result.recordsCount;
			this.observerService.notify('PromiseComplete');
            this.loading = false;
        });
    }
    
	public launchWishlistsModal = (skuID, productID, productName) => {
	    this.monatService.launchWishlistsModal(skuID, productID, productName);
	}
	
	public searchByKeyword = ():void =>{
	    this.loading = true;
        this.argumentsObject['pageRecordsShow'] = this.pageRecordsShow;
        let data:any={keyword: this.searchTerm };
        
        if(this.flexshipFlag){
        	data.flexshipFlag = this.flexshipFlag;
        }
        
		this.publicService.doAction('getProductsByKeyword', data).then(res=> {
			this.paginationMethod = 'getProductsByKeyword';
			this.recordsCount = res.recordsCount;
			this.argumentsObject['keyword'] = this.searchTerm;
			this.productList = res.productList;
			this.observerService.notify("PromiseComplete");
			this.loading = false;
		});
	}
	
	public addToCart = (skuID, quantity) => {
		this.loadingAddToCart = true;
		this.monatService.addToCart(
			skuID, 
			quantity
		)
		.then((data) => {
			this.loadingAddToCart = false;
			this.monatAlertService.success("Product added to cart successfully");
		})
		.catch( (error) => {
			this.loadingAddToCart = false;
			console.error(error);
            this.monatAlertService.showErrorsFromResponse(error);
		});
	};
}


/*********************
    To use: 
    1. Declare as the controller of a wrapper div
    2. ng-init a filter flag as true if you would like it applied,
        the corresponding ID is already being sent in the headers (with exception of cmsContentID for content-module loops, this will need an ng-init)
    3. ng-repeat using monat-product-card
    4. Use pagination directive and pass in the controller's argumentsObject if you would like to paginate
    
*******************/

export {  MonatProductListingController };