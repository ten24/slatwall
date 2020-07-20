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
    public wishlistItems;
	public hairProductFilter:any;
	public skinProductFilter:any;
	public loadingAddToCart;
	public flexshipFlag:boolean;
	
	// @ngInject
	constructor(
		public publicService,
		public observerService,
        private monatService,
		public $rootScope,
		public ModalService,
		private monatAlertService
	) {
        
	}

    
    public $onInit = () => {
        this.observerService.attach(this.handleAddItem,'addItemSuccess');
        this.observerService.attach(this.handleAddItem,'createWishlistSuccess');
        this.observerService.attach(this.handleAddItem,'addOrderTemplateItemSuccess');
        this.observerService.attach(this.getWishlistItems,'getAccountSuccess');
        this.publicService.getCart();
    }
    
	public $postLink = () => {
        if(this.callEndpoint) this.getProducts();
	}
	
	public handleAddItem = () =>{
	    this.getWishlistItems();
	    if(!this.callEndpoint) this.showWishlist = true;
	    
	    // On product detail page, fill the heart.
	    if ( $('.product-img-section .wishlist .far').length ) {
	        $('.product-img-section .wishlist .far').removeClass('far').addClass('fas no-hover')
	    }
	}
	
	public getWishlistItems = () => {
		if(!this.publicService.account?.accountID){
			return;
		}
	    this.monatService.getAccountWishlistItemIDs()
	    .then( data => {
            if ( data?.wishlistItems ) {
                
                this.wishlistItems = '';
                data.wishlistItems.forEach(item => {
                    this.wishlistItems += item.productID + ',';
                });
                
                this.observerService.notify('accountWishlistItemsSuccess');
            }
        });
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
    
	public launchWishlistModal = (skuID, productName) => {
		let newSkuID = skuID
		this.ModalService.showModal({
			component: 'swfWishlist',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				sku: newSkuID,
				productName: productName
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
			.then((modal) => {
				//it's a bootstrap element, use 'modal' to show it
				modal.element.modal();
				modal.close.then((result) => {});
			})
			.catch((error) => {
				console.error('unable to open model :', error);
			});
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