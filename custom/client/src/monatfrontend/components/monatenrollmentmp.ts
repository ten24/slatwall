class EnrollmentMPController {
    public Account_CreateAccount;
    public loading:boolean = false;
    public productList;
    public pageTracker:number = 1;
    public totalPages:Array<number>;

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public publicService
    ){}
    
    public $onInit = () =>{
        this.getProductList();
    }
    
    public getProductList = (pageNumber = 1, direction:any = false )=>{
        this.loading = true;
        const pageRecordsShow = 12;
        
        if(direction === 'prev'){
            if(this.pageTracker === 1){
                return pageNumber;
            }else{
                pageNumber = this.pageTracker -1;
            }
        }else if(direction === 'next'){
            if(this.pageTracker >= this.totalPages.length){
                pageNumber = this.totalPages.length;
                return pageNumber;
            }else{
                pageNumber = this.pageTracker +1;
            }
        }
        
        
        
        this.publicService.doAction("getproducts", {pageRecordsShow: pageRecordsShow, currentPage: pageNumber}).then(result => {
            this.productList = result.productListing;
            
            const holdingArray = [];
            const pages = Math.ceil(result.recordsCount / pageRecordsShow);
 

            for(var i = 0; i <= pages -1; i++){
                holdingArray.push(i);
            }
            
            this.totalPages = holdingArray;
            this.pageTracker = pageNumber;
            
            this.loading = false;
        });
   }
   
}

class MonatEnrollmentMP {
    
    
    public require          = {
        ngModel:'?^ngModel'    
    };
    public priority         =1000;
    public restrict         = "A";
    public scope            = true;
   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
    };
    public controller       = EnrollmentMPController;
    public controllerAs     = "enrollmentMp";
    // @ngInject
    constructor() {
    }

    public static Factory(){
        var directive = () => new MonatEnrollmentMP();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    MonatEnrollmentMP
}