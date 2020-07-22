import { Option } from "@Hibachi/form/components/swfselect";
import { MonatService } from "@Monat/services/monatservice";
import { OrderTemplateService} from "@Monat/services/ordertemplateservice";
import { MonatAlertService } from "@Monat/services/monatAlertService";

class SWFWishlistController {
    private wishlistTypeID:string = '2c9280846b712d47016b75464e800014';
    
    // bindings
    public skuId:string;
    public productName;
	public close; // injected from angularModalService
    
    // internal vars
    public orderTemplateItems : Array<any>;
    public orderTemplates : Array<any>;

    public pageRecordsShow:number;
    public currentPage:number;
    public currentList:Option;
    
    // ui
    public loading:boolean;
    public wishlistTemplateID:string;
    public wishlistTemplateName:string;
    public newWishlist:boolean = false;
    public newTemplateID:string;

    
    
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
        this.observerService.attach(this.refreshList,"myAccountWishlistSelected");    
    }
    
    public setWishlistID = (newID) => {
        this.wishlistTemplateID = newID;
    }
    
    public setWishlistName = (newName) => {
        this.wishlistTemplateName = newName;
    }
    
    // functions for swf-wishlist modal
    
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
            this.skuId
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
            this.skuId
        )
        .then( (result) => this.onAddItemSuccess() )
        .catch( (e) => this.monatAlertService.showErrorsFromResponse(e))
        .finally( () => this.loading = false);
    }
    
    
    // finctions for my-wishlists page
    
        
    private refreshList = (option:Option)=>{
        this.loading = true;
        this.currentList = option;

        if(!option){
           this.loading = false; 
           return;
        }

        this.orderTemplateService
        .getWishlistItems(option.value,this.pageRecordsShow,this.currentPage,this.wishlistTypeID)
        .then(result=>{
            this.orderTemplateItems = result.orderTemplateItems;
            this.loading = false;
        });

    }

    public getAllWishlists = (pageRecordsToShow:number = this.pageRecordsShow, setNewTemplates:boolean = true, setNewTemplateID:boolean = false) => {
        this.loading = true;

        this.orderTemplateService
        .getOrderTemplates(this.wishlistTypeID, pageRecordsToShow, this.currentPage)
        .then( (result) => {

            if(setNewTemplates){
                this.orderTemplates = result['orderTemplates'];                
            } else if(setNewTemplateID){
                this.newTemplateID = result.orderTemplates[0].orderTemplateID;
            }
        })
        .catch( (e) => {
            //TODO
            console.error(e);
        })
        .finally( () => {
            this.loading = false;
        });
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
    
    public redirectPageToShop(){
        this.monatService.redirectToProperSite('/shop')
    }
    
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