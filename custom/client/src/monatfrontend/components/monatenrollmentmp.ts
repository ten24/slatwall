class EnrollmentMPController {
    public Account_CreateAccount;
    public loading:boolean = false;
    public productList
    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public publicService

    ){}
    public $onInit = () =>{
        this.getProductList();
    }
    public getProductList = ()=>{
        this.loading = true;
        this.publicService.doAction("getproducts", {pageRecordsShow: 1, currentPage: 5}).then(result => {
            this.productList = result.productListing;
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