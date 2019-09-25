class MonatProductCardController {
	public product;
	public type;
	public loggedIn;
	public loading;
	public newTemplateID;
	public orderTemplates:Array<any>;
	public pageRecordsShow = 5;
	public currentPage = 1;
    private wishlistTypeID:string = '2c9280846b712d47016b75464e800014';
    private allProducts:Array<any>
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
        debugger;
        const item = this.allProducts[index];
        
        return this.$rootScope.hibachiScope.doAction("deleteOrderTemplateItem",{orderTemplateItemID: item.orderItemID}).then(result=>{
            
            this.allProducts.splice(index, 1);
            this.loading = false;
            return result;
            
        });
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
		loggedIn: '=',
		allProducts: '<?',
		cartButtonAction: '&',
		modalButtonAction: '&',
		cartButtonText: '@'
	}
	public require = '^swfWishlist';
	

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

