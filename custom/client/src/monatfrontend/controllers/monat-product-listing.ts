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
	public productFilters:any = {};
	public showProductFilter:any = {};
	public loadingAddToCart;
	public flexshipFlag:boolean;
	public qualifiedPromos;
	public productFilterTitle:string = "";

	// @ngInject
	constructor(
		public $rootScope           : ng.IRootScopeService,
		public publicService        : PublicService,
		public observerService      : ObserverService,
		public $timeout,
        private monatService        : MonatService,
		private monatAlertService   : MonatAlertService,
		private orderTemplateService: OrderTemplateService,
		private rbkeyService,
		private ModalService
	) {}

    
    public $onInit = () => {
        this.monatService.getCart(); // monat-service caches cart in session-cache for 15 min
        this.getWishlistItems();
    }
    
	public $postLink = () => {
        if(this.callEndpoint){
        	this.publicService.getAccount().then(result =>{
        		this.getProducts()
        	});
        } 
        
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
			if(category != 'none'){
				this.argumentsObject['categoryFilterFlag'] = true;
				this.argumentsObject['categoryID'] = category.value;
				for(var key in this.productFilters){
					this.productFilters[key] = null;
				}
				this.productFilters[categoryType] = category;
			}else{
				this.argumentsObject['categoryFilterFlag'] = false;
				this.argumentsObject['categoryID'] = null;
				for(var key in this.productFilters){
					this.productFilters[key] = null;
				}
			}
			this.argumentsObject['currentPage'] = 1;
		}
		
		if(this.flexshipFlag){
			this.argumentsObject['flexshipFlag'] = this.flexshipFlag;
		}
        
        this.argumentsObject['pageRecordsShow'] = this.pageRecordsShow;
        
        if(this.argumentsObject['categoryFilterFlag']){
        	this.argumentsObject['cmsCategoryFilterFlag'] = false;
        }
        if(this.publicService.account?.priceGroups?.length){
        	this.argumentsObject['priceGroupCode'] = this.publicService.account.priceGroups[0].priceGroupCode;
		}
        
        this.argumentsObject.returnJsonObjects='';
        
        this.publicService.doAction('getProductsByCategoryOrContentID', this.argumentsObject, 'GET').then(result => {
            this.productList = result.productList;
            this.recordsCount = result.recordsCount;
			this.observerService.notify('PromiseComplete');
            
            this.$timeout(()=>this.loading = false);
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
			if(data.hasErrors){
				this.monatAlertService.showErrorsFromResponse(data);
			}
		})
		.catch( (error) => {
			console.error(error);
            this.monatAlertService.showErrorsFromResponse(error);
		})
		.finally(()=>{
			this.loadingAddToCart = false;
		});
	};
	
	public launchPromoModal = () =>{
		this.ModalService.showModal({
		      component: 'promoModal',
		      bodyClass: 'angular-modal-service-active',
			  bindings: {
			    title: this.rbkeyService.rbKey('frontend.enrollment.promoModal'),
			  },
			  preClose: (modal) => {
				modal.element.modal('hide');
			},
		}).then( (modal) => {
			modal.element.modal(); //it's a bootstrap element, using '.modal()' to show it
			/// this event is fired by bootstrap
			modal.element.on('hidden.bs.modal', function (e) {
				modal.element.remove();
			});
		    modal.close.then( (confirm) => {
		    });
		}).catch((error) => {
			console.error("unable to open promoModal :",error);	
		});
	}
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