class MonatProductCardController {
	public product;
	public type;
	public loading;
	public newTemplateID;
	public orderTemplates:Array<any>;
	public pageRecordsShow = 5;
	public currentPage = 1;
    private wishlistTypeID:string = '2c9280846b712d47016b75464e800014';
    private allProducts:Array<any>;
    private wishlistTemplateID;
    private wishlistTemplateName;
    

    // @ngInject
    constructor(
    	//inject modal service
    	public orderTemplateService,
    	public $rootScope
    ){
    }
    
    public getAllWishlists = (pageRecordsToShow:number = this.pageRecordsShow, setNewTemplates:boolean = true, setNewTemplateID:boolean = false) => {
        this.loading = true;
        
        this.orderTemplateService
        .getOrderTemplates(pageRecordsToShow,this.currentPage,this.wishlistTypeID)
        .then(result=>{
            
            if(setNewTemplates){
                this.orderTemplates = result['orderTemplates'];                
            } else if(setNewTemplateID){
                this.newTemplateID = result.orderTemplates[0].orderTemplateID;
            }
            this.loading = false;
        });
    }
    
    public deleteItem =(index):Promise<any>=>{
        this.loading = true;
        const item = this.allProducts[index];
        
        return this.$rootScope.hibachiScope.doAction("deleteOrderTemplateItem",{orderTemplateItemID: item.orderItemID}).then(result=>{
            this.allProducts.splice(index, 1);
            this.loading = false;
            return result;
            
        });
    }
    
    public addItemAndCreateWishlist = (orderTemplateName:string, skuID, quantity:number = 1)=>{
        this.loading = true;
        const data = {
           orderTemplateName:orderTemplateName,
           skuID:skuID,
           quantity:quantity
        };
        
        return this.$rootScope.hibachiScope.doAction("addItemAndCreateWishlist",data).then(result=>{
            this.loading = false;
            this.getAllWishlists();
            return result;
        });
    }
    
    public addWishlistItem =(skuID)=>{ 
        this.loading = true;
        this.orderTemplateService.addOrderTemplateItem(skuID, this.wishlistTemplateID)
        .then(result=>{
            this.loading = false;
            return result;
        });
    }
    
    public launchModal =(type)=>{
        
        if(type === 'flexship'){
            //launch flexship modal 
      
        }else{
            //launch normal modal
        }
        
    }
    
    public setWishlistID = (newID) => {
        this.wishlistTemplateID = newID;
        
    }
    
    public setWishlistName = (newName) => {
        this.wishlistTemplateName = newName;
    }
    
    
}

class MonatProductCard {

	public restrict:string = 'EA';
	public templateUrl:string;
    public scope:boolean = true;
	
  public bindToController = {
		product: '=',
		type: '@',
		index: '@',
		allProducts: '<?',
	}
	

    public controller       = MonatProductCardController;
    public controllerAs     = "monatProductCard";
        
	public static Factory(){
		var directive:any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor( private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatproductcard.html";
	}
	
}

export {
	MonatProductCardController,
	MonatProductCard
};

