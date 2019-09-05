/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />

import {Option} from "../../../../../org/Hibachi/client/src/form/components/swfselect";



class SWFWishlistController {
    public orderTemplateItems:Array<any>;
    public pageRecordsShow:number;
    public currentPage:number;
    public currentList:Option;
    public loading:boolean;
    private wishlistTypeID:string = '2c9280846b712d47016b75464e800014';
    
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
    }
    
    private refreshList = (option:Option)=>{
        
        this.loading = true;
        this.currentList = option;
        
        this.orderTemplateService
        .getOrderTemplateItems(option.value,this.pageRecordsShow,this.currentPage,this.wishlistTypeID)
        .then(result=>{
            this.orderTemplateItems = result['orderTemplateItems'];
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