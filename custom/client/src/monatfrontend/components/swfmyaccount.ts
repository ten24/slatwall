/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />


class swfAccountController {
    public account;
    public accountData;
    public accountAge:number;
    public loading:boolean;
    public monthOptions:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12];
    public yearOptions:Array<number> = [];
    public currentYear = 2018;
    public countryCodeOptions;
    public stateCodeOptions;
    public selectedCountry;
    public userIsLoggedIn:boolean = false;

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        //public accountService
    ){
        console.log("controller activatttteed");
        const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;
        
        do {
            this.yearOptions.push(manipulateableYear++)
        }
        while(this.yearOptions.length <= 9);
    }
    // Determine how many years old the account is
    public checkAndApplyAccountAge = () => {
        if(this.accountData.createdDateTime){
            let accountCreatedYear = Date.parse(this.accountData.createdDateTime).getFullYear();
            this.accountAge = this.currentYear - accountCreatedYear
        }
    }
    
    public getAccount = () => {
        console.log("I was calllllledd")
        this.account = this.$rootScope.hibachiScope.getAccount();
        //Do this when then account data returns
        this.account.then((request)=>{
            console.log(request);
            this.accountData = request;
            this.checkAndApplyAccountAge();
            this.userIsLoggedIn = true;
            
        })
    }
    
    public getCountryCodeOptions = ():Promise<any>=>{
        this.loading = true;
        
        return this.$rootScope.hibachiScope.doAction("getCountries").then(result=>{
            
            this.countryCodeOptions = result.countryCodeOptions;
            console.log(this.countryCodeOptions)
            this.loading = false;
            
        });
    }
    
    public getStateCodeOptions = (countryCode):Promise<any> =>{
        console.log(typeof(countryCode));
        this.loading = true;
        
        return this.$rootScope.hibachiScope.doAction("getStateCodeOptionsByCountryCode",{countryCode}).then(result=>{
            this.stateCodeOptions = result;
            this.loading = false;
            return result;
        });
    }
}

class swfAccount  {
    
    public controller       = swfAccountController;
    public controllerAs     = "swfAccount";
    public restrict         = "A";
    public scope            = true;
    public static Factory(){
        var directive = () => new swfAccount();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    swfAccount,
    swfAccountController
}