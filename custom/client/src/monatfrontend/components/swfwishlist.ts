/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />
declare var $;

import {Option} from "../../../../../org/Hibachi/client/src/form/components/swfselect";

class SWFWishlistController {
    public orderTemplateItems:Array<any>;
    public orderTemplates:Array<any>;
    public pageRecordsShow:number;
    public currentPage:number;
    public currentList:Option;
    public loading:boolean;
    public isVIPAccount:boolean;
    private wishlistTypeID:string = '2c9280846b712d47016b75464e800014';
    public wishlistTemplateID:string;
    public wishlistTemplateName:string;
    public sku:string;
    public newTemplateID:string;
    public showTemplateList:boolean = false;
    public showWishlistModal:boolean;
	public close; // injected from angularModalService
    public productName;
    public newWishlist:boolean = false;
    // @ngInject
    constructor(
        public $scope,
        public observerService,
        public $timeout,
        public orderTemplateService,
        public monatService
    ){
        if(!this.pageRecordsShow){
            this.pageRecordsShow = 6;
        }
        
        if(!this.currentPage){
            this.currentPage = 1;
        }
        
        this.observerService.attach(this.refreshList,"myAccountWishlistSelected");        
        this.observerService.attach(this.successfulAlert,"OrderTemplateAddOrderTemplateItemSuccess");
        this.observerService.attach(this.onAddItemSuccess,"createWishlistSuccess"); 
        this.observerService.attach(this.onAddItemSuccess,"addItemSuccess"); 
    }
    
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

    public deleteItem =(index)=>{
        this.loading = true;
        const item = this.orderTemplateItems[index];
        
        this.orderTemplateService.deleteOrderTemplateItem(item.orderItemID).then(result=>{
            
            this.orderTemplateItems.splice(index, 1);
            this.refreshList(this.currentList);
            this.loading = false;
            return result;
        });
    }
    
    public addWishlistItem =(skuID)=>{ 
        this.loading = true;
        this.orderTemplateService.addOrderTemplateItem(this.sku ? this.sku : skuID, this.wishlistTemplateID)
        .then(result=>{
            this.loading = false;
            this.onAddItemSuccess(this.sku);
        });
    }

    public addItemAndCreateWishlist = (orderTemplateName:string, quantity:number = 1)=>{
        this.loading = true;
        this.setWishlistName(orderTemplateName)
        return this.orderTemplateService.addOrderTemplateItemAndCreateWishlist(this.wishlistTemplateName, this.sku, quantity).then(result=>{
            this.loading = false;
            this.getAllWishlists();
            this.observerService.attach(this.successfulAlert,"createWishlistSuccess");
            return result;
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
    
    public getWishlistsLight = () =>{
        this.orderTemplateService.getOrderTemplatesLight().then(response =>{
            this.orderTemplates = response['orderTemplates'];
        });
    }
    
    public successfulAlert = () =>{
        const wishlistAddAlertBox = document.getElementById("wishlistAddAlert");
        const wishlistInnerText = document.getElementById("wishlistTextWrapper");
        wishlistAddAlertBox.style.display = "block";
    }
    
    public setWishlistID = (newID) => {
        this.wishlistTemplateID = newID;
    }
    
    public setWishlistName = (newName) => {
        this.wishlistTemplateName = newName;
    }
    
    public addToCart =(index)=>{
        
    }
    
    public search =()=>{
    }
    
    
    public onAddItemSuccess = (skuid) => {
        
        // Set the heart to be filled on the product details page
        $('#skuID_' + skuid).removeClass('far').addClass('fas');
        
        // Close the modal
        if(!this.close) return;
     	this.close(null); // close, but give 100ms to animate
    };
    
    public redirectPageToShop(){
        this.monatService.redirectToProperSite('/shop')
    }
    
}

class SWFWishlist  {
    
    
    public require          = {
        ngModel:'?^ngModel'    
    };
    public priority = 1000;
    public scope = true;
	public templateUrl:string;
    public restrict:string;

   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
        pageRecordsShow:"@?",
        currentPage:"@?",
        sku:"<?",
        productName:"<?",
        showWishlistModal:"<?",
        close:'=' //injected by angularModalService;
    };
    public controller       = SWFWishlistController;
    public controllerAs     = "swfWishlist";
    
        /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive: any = (monatFrontendBasePath) => new SWFWishlist(
			monatFrontendBasePath,
        );
		directive.$inject = ['monatFrontendBasePath'];
        return directive;
    }
    
    // @ngInject
	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/swfwishlist.html';
		this.restrict = "AE";
	}
    /**
        * Sets the context of this form
        */
    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController) =>
    {
    }

  
}
export{
    SWFWishlist,
    SWFWishlistController
}