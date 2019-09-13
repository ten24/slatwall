/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />

class swfAccountController {
    public account;
    public accountData;
    public accountAge:number;

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
    ){
        this.account = this.$rootScope.hibachiScope.getAccount();
        
        //Do this when then account data returns
        this.account.then(()=>{
            this.accountData = this.account.$$state.value;
            this.checkAndApplyAccountAge();
            console.log('I ran')
        })
        
    }
    // Determine how many years old the account is
    public checkAndApplyAccountAge = () => {
        let accountCreatedYear = Date.parse(this.accountData.createdDateTime).getFullYear();
        let curDate = new Date
        let curYear = curDate.getFullYear();
        this.accountAge = accountCreatedYear - curYear;
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