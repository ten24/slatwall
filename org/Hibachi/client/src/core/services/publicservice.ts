/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class PublicService {
    public formType = {'Content-Type':"application/x-www-form-urlencoded"};
    public ajaxRequestParam:string = "?ajaxRequest=1";
    public account:any; 
    public cart:any;
    public states:any;
    public countries:any;
    public addressOptions:any;
    public success:boolean;
    public hasErrors:boolean;
    public errors:string;
    public http:ng.IHttpService;
    public header:any;
    private baseActionPath = "";
    public months = [{name:'JAN',value:1},{name:'FEB',value:2},{name:'MAR',value:3},{name:'APR',value:4},{name:'MAY',value:5},{name:'JUN',value:6},{name:'JUL',value:7},{name:'AUG',value:8},{name:'SEP',value:9},{name:'OCT',value:10},{name:'NOV',value:11},{name:'DEC',value:12}];
    public years = [];
    public shippingAddress = "";
    public billingAddress = "";
    ///index.cfm/api/scope/
    //@ngInject
    constructor(public $http:ng.IHttpService, public $q:ng.IQService) { 
        
        this.baseActionPath = "/index.cfm/api/scope/"; //default path
        this.$http = $http;
        this.$q = $q
        this.getExpirationYears();
    }
    
    /** grab the valid expiration years for credit cards  */
    public getExpirationYears=():any =>{
        
        var baseDate = new Date();
        var today = baseDate.getFullYear();
        var start = today;
        for (var i = 0; i<= 5; i++){
            console.log("I:", start + i);
            this.years.push(start + i);
        }
        console.log("This Years", this.years);
    }
    /** accessors for account */
    public getAccount=():any =>  {
        let urlBase = '/index.cfm/api/scope/getAccount/';
        return this.getData(urlBase, "account", "");
    }
    /** accessors for cart */
    public getCart=():any =>  {
        let urlBase = '/index.cfm/api/scope/getCart/';
        return this.getData(urlBase, "cart", "");
    }
    /** accessors for countries */
    public getCountries=():any =>  {
        let urlBase = '/index.cfm/api/scope/getCountries/';
        return this.getData(urlBase, "countries", "");
    }
    
    /** accessors for states */
    public getStates=(countryCode:string):any =>  {
       if (!angular.isDefined(countryCode)) countryCode = "US";
       let urlBase = '/index.cfm/api/scope/getStateCodeOptionsByCountryCode/';
       return this.getData(urlBase, "states", "&countryCode="+countryCode);
    }
    /** accessors for states */
    public getAddressOptions=(countryCode:string):any =>  {
       if (!angular.isDefined(countryCode)) countryCode = "US";
       let urlBase = '/index.cfm/api/scope/getAddressOptionsByCountryCode/';
       return this.getData(urlBase, "addressOptions", "&countryCode="+countryCode);
    }
    
    /** accessors for states */
    public getData=(url, setter, param):any =>  {
        let urlBase = url + this.ajaxRequestParam + param;
        var deferred = this.$q.defer();
        this.$http.get(urlBase).success((result:any)=>{
            //don't need account and cart for anything other than account and cart calls.
            if (setter.indexOf('account') == -1 || setter.indexOf('cart') == -1){
                if (result['account']){delete result['account'];}
                if (result['cart']){delete result['cart'];}
                console.log("Result Sans", result);
            }
            this[setter] = result;
            console.log("Data:", this[setter]);
            deferred.resolve(result);
        }).error((reason)=>{
            deferred.reject(reason);  
        });
        return deferred.promise;
    }
    
    /** sets the current shipping address */
    public setShippingAddress=(shippingAddress) => {
        this.shippingAddress = shippingAddress;
    }
    
    /** sets the current shipping address */
    public setBillingAddress=(billingAddress) => {
        this.billingAddress = billingAddress;
    }
    
    /** this is the generic method used to call all server side actions.
        *  @param action {string} the name of the action (method) to call in the public service.
        *  @param data   {object} the params as key value pairs to pass in the post request.
        *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
        */
    public doAction=(action:string, data?:any) => {
        let method = "";
        if (!action) {throw "Action is required exception";}
        
        if (action != undefined && data == undefined){method = "get";}else{method = "post"}
        
        //check if the caller is defining a path to hit, otherwise use the public scope.
        if (action.indexOf("/") !== -1){
            this.baseActionPath = action; //any path
        }else{
            this.baseActionPath = "/index.cfm/api/scope/" + action;//public path
        }
        
        this.hasErrors = false;
        this.success = false;
        this.errors = undefined;
        this.header = {headers: this.formType};
        var deferred = this.$q.defer();
        
        let urlBase = this.baseActionPath + this.ajaxRequestParam;
        
        if (method == "post"){
             data.returnJsonObjects = "cart,account";
            //post
            let promise =  this.$http.post(urlBase, this.toFormParams(data), this.header).then((result:any)=>{
                
                /** update the account and the cart */
                this.account = result.data.account;
                this.cart = result.data.cart;
                //if the action that was called was successful, then success is true.
                if (result.data.successfulActions.length){
                    this.success = true;
                }
                if (result.data.failureActions.length){
                    this.hasErrors = true;
                    console.log("Errors:", result.data.errors);
                }
                deferred.resolve(result);
            }).catch((response)=>{
                console.log("There was an error making this http call", response.status, response.data);
                deferred.reject(response);
            });
            return deferred.promise;
        }else{
            //get
            var url = urlBase + "&returnJsonObject=cart,account";
            var deferred = this.$q.defer();
            this.$http.get(url).success((result:any)=>{
              deferred.resolve(result);
            }).error((reason)=>{
              deferred.reject(reason);
            });
            return deferred.promise;
        }
        
        
    }
    /** used to turn data into a correct format for the post */
    public toFormParams= (data):string => {
        return data = $.param(data) || "";
    }
    
    /**
     * Helper methods so that everything in account and cart can be accessed using getters.
     */
    public userIsLoggedIn = ():boolean =>{
        if (this.account !== undefined && this.account.accountID !== ''){
            return true;
        }
        return false;
    }
    /**
     * Helper methods for getting errors from the cart
     */
    public getErrors = ():{} =>{
        if (this.errors !== undefined){
            return this.errors;
        }
        return {};
    }
    
}
export {PublicService};

