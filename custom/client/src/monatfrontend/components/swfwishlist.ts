import { MonatService } from "@Monat/services/monatservice";
import { OrderTemplateService, OrderTemplateLight, WishlistItemLight } from "@Monat/services/ordertemplateservice";
import { MonatAlertService } from "@Monat/services/monatAlertService";

class SWFWishlistController {
    private wishlistTypeID:string = '2c9280846b712d47016b75464e800014';
    
    // bindings
    public skuId:string;
    public productId:string;
    public productName;
	public close; // injected from angularModalService
    
    // internal vars
    public orderTemplateItems : Array<WishlistItemLight>;
    public orderTemplates : Array<OrderTemplateLight>;

    public pageRecordsShow:number;
    public currentPage:number;
    
    // ui
    public loading:boolean;
    public wishlistTemplateID:string;
    public wishlistTemplateName:string;
    public newWishlist:boolean = false;
    
    
    // @ngInject
    constructor(
        public $scope,
        public observerService,
        public $timeout,
        public orderTemplateService: OrderTemplateService,
        public monatService: MonatService,
        private monatAlertService: MonatAlertService
    ){
        if(!this.pageRecordsShow){
            this.pageRecordsShow = 6;
        }
        
        if(!this.currentPage){
            this.currentPage = 1;
        }
    }
    
    public $onInit = () => {
        this.getWishlistsLight();
    }
    
    public setWishlistID = (newID) => {
        this.wishlistTemplateID = newID;
    }
    
    public setWishlistName = (newName) => {
        this.wishlistTemplateName = newName;
    }
        
    public getWishlistsLight = () => {
        this.loading = true;
        this.orderTemplateService.getWishLists().then( wishlists => {
            this.orderTemplates = wishlists;
        })
        .catch(e => this.monatAlertService.showErrorsFromResponse(e))
        .finally( () => this.loading = false);
    }
    
    public addWishlistItem =()=>{ 
        this.loading = true;
        
        this.orderTemplateService.addWishlistItem(
            this.wishlistTemplateID, 
            this.skuId, 
            this.productId
        )
        .then( (result) => this.onAddItemSuccess() )
        .catch( (e) => this.monatAlertService.showErrorsFromResponse(e))
        .finally( () => this.loading = false);
    }

    public addItemAndCreateWishlist = (orderTemplateName:string, quantity:number = 1)=>{
        this.loading = true;
        this.setWishlistName(orderTemplateName);
        
        this.orderTemplateService.addItemAndCreateWishlist(
            this.wishlistTemplateName,
            this.skuId, 
            this.productId 
        )
        .then( (result) => this.onAddItemSuccess() )
        .catch( (e) => this.monatAlertService.showErrorsFromResponse(e))
        .finally( () => this.loading = false);
    }
    
    public onAddItemSuccess = () => {
        
        const wishlistAddAlertBox = document.getElementById("wishlistAddAlert");
        if(wishlistAddAlertBox){
            wishlistAddAlertBox.style.display = "block";
        }
        // Set the heart to be filled on the product details page
        $('#skuID_' + this.skuId).removeClass('far').addClass('fas');
        // Close the modal
     	this.close?.();
    };
    
}

class SWFWishlist  {
    
    
    public require = {
        ngModel:'?^ngModel'    
    };

    public priority = 1000;
    public scope = true;
    public restrict:"AE";

   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
        pageRecordsShow:"@?",
        currentPage:"@?",
        skuId:"<?",
        productId:"<?",
        productName:"<?",
        showWishlistModal:"<?",
        close:'=' //injected by angularModalService;
    };
    public controller       = SWFWishlistController;
    public controllerAs     = "swfWishlist";
    
        /**
     * Handles injecting the partials path into this class
     */
	public template = require('./swfwishlist.html');

	public static Factory() {
		return () => new this();
	}
  
}
export{
    SWFWishlist,
    SWFWishlistController
}