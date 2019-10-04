class EnrollmentMPController {
    public Account_CreateAccount;
    public contentId:string;
    public bundleHasErrors:boolean = false;
    public openedBundle:any;
    public selectedBundleID:string = '';
    public bundles:any = [];

    // @ngInject
    constructor(
        public publicService,
        public observerService,
    ){}

    public $onInit = () => {
        this.getStarterPacks();
    }

    public getStarterPacks = () => {
        this.publicService.doAction('getStarterPackBundleStruct', { contentID: this.contentId }).then( data => {
            this.bundles = data.bundles;
        });
    }
    
    public submitStarterPack = () => {
        if ( this.selectedBundleID.length ) {
            this.observerService.notify('onNext');
        } else {
            this.bundleHasErrors = true;
        }
    }
    
    public selectBundle = bundleID => {
        this.selectedBundleID = bundleID;
        this.bundleHasErrors = false;
        this.openedBundle = null;
    }
    
    private stripHtml = html => {
       let tmp = document.createElement('div');
       tmp.innerHTML = html;
       return tmp.textContent || tmp.innerText || '';
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