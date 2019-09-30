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
    public orderItemsLength:number;
    public urlParams = new URLSearchParams(window.location.search);
    public newAccountPaymentMethod
    public cachedCountryCode;
    public accountPaymentMethods;
    public editAddress;
    public isNewAddress:boolean;

    
    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public observerService
    ){
        const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;

        do {
            this.yearOptions.push(manipulateableYear++)
        }
        while(this.yearOptions.length <= 9);
        
        this.observerService.attach(this.getAccount,"loginSuccess");        

    }
    // Determine how many years old the account is
    public checkAndApplyAccountAge = () => {
        if(this.accountData.createdDateTime){
            const accountCreatedYear = Date.parse(this.accountData.createdDateTime).getFullYear();
            this.accountAge = this.currentYear - accountCreatedYear
        }
    }
	public $onInit = () =>{
        this.getAccount();
	}
	
    public getAccount = () => {
        this.loading = true;
        const account = this.$rootScope.hibachiScope.getAccount();
        //Do this when then account data returns
        //Optimize when get orders on account is called, only needed on account overview and orders overview
        account.then((response)=>{
            this.accountData = response;
            this.checkAndApplyAccountAge();
            this.getOrdersOnAccount()
            this.userIsLoggedIn = true;
            this.accountPaymentMethods = this.accountData.accountPaymentMethods;
            if(this.urlParams.get('orderid')){
                this.getOrderItemsByOrderID();
            };
            
            this.loading = false;
        });
    }
    
    public getOrdersOnAccount = (accountID = this.accountData.accountID) => {
        this.loading = true;
        
        return this.$rootScope.hibachiScope.doAction("getAllOrdersOnAccount", {'accountID' : accountID}).then(result=>{
            this.ordersOnAccount = result.ordersOnAccount;
            this.loading = false;
        });
    }
    
    public getOrderItemsByOrderID = (orderID = this.urlParams.get('orderid'), pageRecordsShow = 5, currentPage = 1, accountID = this.accountData.accountID) => {
        this.loading = true;
        return this.$rootScope.hibachiScope.doAction("getOrderItemsByOrderID", {orderID,accountID,currentPage,pageRecordsShow,}).then(result=>{
            result.OrderItemsByOrderID.forEach(orderItem =>{
                this.orderItems.push(orderItem);
            });
            this.orderItemsLength = result.OrderItemsByOrderID.length;
        });
    }
    
    public getCountryCodeOptions = ():Promise<any>=>{
        this.loading = true;
        if(this.countryCodeOptions){
            return this.countryCodeOptions;
        }

        return this.$rootScope.hibachiScope.doAction("getCountries").then(result=>{
            this.countryCodeOptions = result.countryCodeOptions;
            this.loading = false;
        });
    }
    
    public getStateCodeOptions = (countryCode) =>{
        this.loading = true;
        
        if(this.cachedCountryCode == countryCode ){
            return this.stateCodeOptions;
        }
        
        this.cachedCountryCode = countryCode;
        return this.$rootScope.hibachiScope.doAction("getStateCodeOptionsByCountryCode",{countryCode}).then(result=>{
            //Resets the state code options on each click so they dont add up incorrectly
            if(this.stateCodeOptions.length){
                this.stateCodeOptions = [];
            }
            result.stateCodeOptions.forEach(stateCode =>{
                this.stateCodeOptions.push(stateCode);
            });

            this.loading = false;
        });
    }
    
    public setPrimaryPaymentMethod = (methodID) => {
        window.location.href+=`?slatAction=public:account.update&primaryPaymentMethod.accountPaymentMethodID=${methodID}`;
    }
    
    public getDeleteItemPath = (ID) => {
       return `?slatAction=public:account.deleteAccountAddress&accountAddressID=${ID}`;
    }
    
    public setEditAddress = (newAddress = true, address) => {
       this.editAddress = address ? address : {};
       if(newAddress) {
           this.isNewAddress = true;
       }else{
           this.isNewAddress = false;
       }
    }
    
    public setPrimaryAddress = (addressID) => {
        this.loading = true;
        return this.$rootScope.hibachiScope.doAction("updatePrimaryAccountShippingAddress", {'accountAddressID' : addressID}).then(result=>{
            this.loading = false;
        });
    }
}

class SWFAccount  {
    
    public bindToController = {
        currentAccountPayment:"@?"
    };
    
    public controller       = swfAccountController;
    public controllerAs     = "swfAccount";
    public restrict         = "A";
    public scope            = true;
    public static Factory(){
        var directive = () => new SWFAccount();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    SWFAccount,
    swfAccountController
}