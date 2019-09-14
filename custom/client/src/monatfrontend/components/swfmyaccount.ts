/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />


class swfAccountController {
    public account;
    public accountData;
    public accountAge:number;
    public loading:boolean;

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
    ){}
    // Determine how many years old the account is
    public checkAndApplyAccountAge = () => {
        if(this.accountData.createdDateTime){
            let accountCreatedYear = Date.parse(this.accountData.createdDateTime).getFullYear();
            let curDate = new Date;
            let curYear = curDate.getFullYear();
        }
    }
    
    public getAccount = () => {
        this.account = this.$rootScope.hibachiScope.getAccount();
        //Do this when then account data returns
        this.account.then((request)=>{
            console.log(request);
            this.$rootScope.accountData = request;
            
            this.accountData = request;
            this.checkAndApplyAccountAge();
            
        })
    }
    
    public deletePaymentMethod = (methodID) => {
        this.loading = true;
        
        return this.$rootScope.hibachiScope.doAction("deleteOrderTemplateItem",methodID).then(result=>{
            this.loading= false;
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