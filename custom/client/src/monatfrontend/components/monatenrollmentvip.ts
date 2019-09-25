class VIPController {
    public Account_CreateAccount;
    public countryCodeOptions:any = [];
    public stateCodeOptions:any = [];
    public currentCountryCode:string;
    public currentStateCode:string;

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
    ){}
    
    public $onInit = () => {
        this.getCountryCodeOptions();
    }
    
    public getCountryCodeOptions = () => {
        if ( this.countryCodeOptions.length ) {
            return this.countryCodeOptions;
        }
        
        this.$rootScope.slatwall.getCountries().then( data => {
            this.countryCodeOptions = data.countryCodeOptions;
        });
    }
    
    public getStateCodeOptions = countryCode => {
        if ( this.countryCodeOptions.length && countryCode === this.currentCountryCode ) {
            return this.countryCodeOptions;
        }
        
        this.currentCountryCode = countryCode;
        
        this.$rootScope.slatwall.getStates( countryCode ).then( data => {
            this.stateCodeOptions = data.stateCodeOptions;
        });
    }
    
}

class MonatEnrollmentVIPController  {
    
    
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
        var directive = () => new MonatEnrollmentVIPController();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    MonatEnrollmentVIPController,
    VIPController
}