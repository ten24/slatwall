class VIPController {
    public Account_CreateAccount;

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
    ){}
    
}

class MonatEnrollmentVIP  {
    
    
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
    public controller       = VIPController;
    public controllerAs     = "vipController";
    // @ngInject
    constructor() {
    }

    public static Factory(){
        var directive = () => new MonatEnrollmentVIP();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    MonatEnrollmentVIP,
    VIPController
}