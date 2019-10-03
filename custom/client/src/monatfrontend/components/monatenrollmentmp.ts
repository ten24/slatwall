class EnrollmentMPController {
    public Account_CreateAccount;
    public contentId;
    public bundles = [];

    // @ngInject
    constructor(
        public publicService
    ){}

    public $onInit = () => {
        this.getStarterPacks();
    }

    public getStarterPacks = () => {
        this.publicService.doAction('getStarterPackBundleStruct', { contentID: this.contentId }).then( data => {
            this.bundles = data.bundles;
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
        contentId: '@'
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