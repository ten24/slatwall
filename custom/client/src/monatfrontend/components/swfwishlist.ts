/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />

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
    public SKUID:string;
    public newTemplateID:string;

    
    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public observerService,
        public $timeout,
        public orderTemplateService,
    ){
        if(!this.pageRecordsShow){
            this.pageRecordsShow = 6;
        }
        
        if(!this.currentPage){
            this.currentPage = 1;
        }
        
        this.observerService.attach(this.refreshList,"myAccountWishlistSelected");        
        this.observerService.attach(this.successfulAlert,"OrderTemplateAddOrderTemplateItemSuccess");

    }
    
    private refreshList = (option:Option)=>{
        this.loading = true;
        this.currentList = option;
        
        this.orderTemplateService
        .getWishlistItems(option.value,this.pageRecordsShow,this.currentPage,this.wishlistTypeID)
        .then(result=>{
            this.orderTemplateItems = result['orderTemplateItems'];
            if(this.orderTemplateItems.length){
                if(this.orderTemplateItems[0].accountPriceGroup.includes(3)){
                    this.isVIPAccount = true;                   
                }
            }

            this.loading = false;
        });
    }
    
    public deleteItem =(index):Promise<any>=>{
        this.loading = true;
        const item = this.orderTemplateItems[index];
        
        return this.$rootScope.hibachiScope.doAction("deleteOrderTemplateItem",item).then(result=>{
            
            this.orderTemplateItems.splice(index, 1);
            this.refreshList(this.currentList);
            return result;
            
        });
    }
    
    public addWishlistItem =()=>{ 
        this.loading = true;
        this.setSkuIDFromAttribute();
        this.orderTemplateService.addOrderTemplateItem(this.SKUID, this.wishlistTemplateID)
        .then(result=>{
            this.loading = false;
            return result;
        });
    }
    
    public addItemAndCreateWishlist = (orderTemplateName:string, quantity:number = 1)=>{
        this.loading = true;
        this.setSkuIDFromAttribute();
        const data = {
           orderTemplateName:orderTemplateName,
           skuID:this.SKUID,
           quantity:quantity
        };
        this.setWishlistName(orderTemplateName)
        
        return this.$rootScope.hibachiScope.doAction("addItemAndCreateWishlist",data).then(result=>{
            this.loading = false;
            this.getAllWishlists();
            this.observerService.attach(this.successfulAlert,"createWishlistSuccess");
            return result;
        });
    }
    
    public setSkuIDFromAttribute = ()=>{
        let newSKUID = document.getElementById('wishlist-product-title').getAttribute('data-skuid');
        this.SKUID = newSKUID;
    }
    
    public getAllWishlists = (pageRecordstoShow:number = this.pageRecordsShow, setNewTemplates:boolean = true, setNewTemplateID:boolean = false) => {
        this.loading = true;
        
        this.orderTemplateService
        .getOrderTemplates(pageRecordstoShow,this.currentPage,this.wishlistTypeID)
        .then(result=>{
            
            if(setNewTemplates){
                this.orderTemplates = result['orderTemplates'];                
            } else if(setNewTemplateID){
                this.newTemplateID = result.orderTemplates[0].orderTemplateID;
                console.log(this.newTemplateID);
            }
            this.loading = false;
        });
    }
    
    public successfulAlert = () =>{
       let wishlistAlert = document.getElementById("wishlistAddAlert");
       wishlistAlert.textContent += this.wishlistTemplateName;
       wishlistAlert.style.display = "block";
    }
    
    public setWishlistID = (newID) => {
        this.wishlistTemplateID = newID;
    }
    
    public setWishlistName = (newName) => {
        this.wishlistTemplateName = newName;
    }
    
    public addToCart =(index)=>{
        
    }
    
    public search =(index)=>{
        
    }

}

class SWFWishlist  {
    
    
    public require          = {
        ngModel:'?^ngModel'    
    };
    public priority=1000;
    public restrict         = "A";
    public scope            = true;
   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
        pageRecordsShow:"@?",
        currentPage:"@?",
    };
    public controller       = SWFWishlistController;
    public controllerAs     = "swfWishlist";
    // @ngInject
    constructor() {
    }
    /**
        * Sets the context of this form
        */
    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController) =>
    {
    }

    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive = () => new SWFWishlist();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    SWFWishlist,
    SWFWishlistController
}