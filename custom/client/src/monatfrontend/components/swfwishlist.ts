class WishListProduct {
    
}

class SWFWishlistController {
    public products:WishListProduct[];
    
    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public observerService,
    ){
        this.observerService.attach(this.getProducts,"myAccountWishlistSelected");
    }
    
    private refreshList = (wishlistOption)=>{
        this.getProducts(wishlistOption).then(products=>{
            debugger;
        });
    }
    
    public getProducts = (wishlistOption):Promise<WishListProduct[]>=>{
        return this.$rootScope.hibachiScope.doAction("getWishlist").then(result=>{
            let options = [];
            for(const option of result.accountWishlistOptions){
                if(option.value && option.name){ // if we have a struct with value and name, use that
                    options.push(new Option(option.value,option.name));
                    continue;
                }
                // otherwise, it's a simple string, so let's use that
                options.push(new Option(option));
            }
            return options;
        });
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