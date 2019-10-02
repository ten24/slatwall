class VIPController {
    public Account_CreateAccount;
    public countryCodeOptions:any = [];
    public stateCodeOptions:any = [];
    public currentCountryCode:string = '';
    public currentStateCode:string = '';
    public mpSearchText:string = '';
    public currentMpPage:number = 1;
    public loading:boolean = false;

    // @ngInject
    constructor(
        public publicService,
        public orderTemplateService
    ){}
    
    public $onInit = () => {
        this.getCountryCodeOptions();
    }
    
    public getCountryCodeOptions = () => {
        if ( this.countryCodeOptions.length ) {
            return this.countryCodeOptions;
        }
        
        this.publicService.getCountries().then( data => {
            this.countryCodeOptions = data.countryCodeOptions;
        });
    }
    
    public getStateCodeOptions = countryCode => {
        this.currentCountryCode = countryCode;
        
        this.publicService.getStates( countryCode ).then( data => {
            this.stateCodeOptions = data.stateCodeOptions;
        });
    }
    
    public getMpResults = () => {
        this.publicService.marketPartnerResults = this.publicService.doAction(
            '/?slatAction=monat:public.getmarketpartners'
			+ '&search='+ this.mpSearchText 
			+ '&currentPage='+ this.currentMpPage 
			+ '&accountTypeCode=D'
			+ '&countryCode=' + this.currentCountryCode
			+ '&stateCode=' + this.currentStateCode
		);
    }
    
    public createOrderTemplate = (orderTemplateSystemCode:string) => {
        this.loading = true;
        this.orderTemplateService.createOrderTemplate(orderTemplateSystemCode).then(result => {
            this.loading = false;
            console.log(result)
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