/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />


class swfAccountController {
    public account;
    public accountData;
    public accountAge:number;
    public loading:boolean;
    public monthOptions:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12];
    public yearOptions:Array<number> = [];
    public currentYear;
    public countryCodeOptions;
    public stateCodeOptions = [];
    public selectedCountry;
    public userIsLoggedIn:boolean = false;
    public ordersOnAccount;
    public orderItems = [];
    public urlParams = new URLSearchParams(window.location.search)

    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
    ){
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
        this.loading = true;
        let account = this.$rootScope.hibachiScope.getAccount();
        //Do this when then account data returns
        account.then((response)=>{
            this.accountData = response;
            this.checkAndApplyAccountAge();
            this.getOrdersOnAccount()
            this.userIsLoggedIn = true;
            this.loading = false;

        })
    }
    
    public getOrdersOnAccount = () => {
        this.loading = true;
        const accountID = this.accountData.accountID
        return this.$rootScope.hibachiScope.doAction("getOrdersOnAccount", {accountID}).then(result=>{
            console.log(result)
            this.ordersOnAccount = result.ordersOnAccount;
            this.getOrderItemsByOrderID();
            // Review why so much gets returned in this response 
            this.loading = false;
        });
    }
    
    public getOrderItemsByOrderID = (orderID = this.urlParams.get('orderid')) => {
        this.loading = true;
        console.log(orderID)
        return this.$rootScope.hibachiScope.doAction("getOrderItemsByOrderID", {orderID}).then(result=>{
            result.OrderItemsByOrderID.forEach(orderItem =>{
                this.orderItems.push(orderItem);
            });
        });
    }
    
    public getCountryCodeOptions = ():Promise<any>=>{
        this.loading = true;
        
        return this.$rootScope.hibachiScope.doAction("getCountries").then(result=>{
            this.countryCodeOptions = result.countryCodeOptions;
            this.loading = false;
        });
    }
    
    public getStateCodeOptions = (countryCode):Promise<any> =>{
        this.loading = true;
        
        return this.$rootScope.hibachiScope.doAction("getStateCodeOptionsByCountryCode",{countryCode}).then(result=>{
            //Reset the state code options on each click so they dont add up incorrectly
            if(this.stateCodeOptions.length){
                this.stateCodeOptions = [];
            }
            result.stateCodeOptions.forEach(stateCode =>{
                this.stateCodeOptions.push(stateCode);
            });

            this.loading = false;
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