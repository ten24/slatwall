/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class PublicService {
    public formType = {'Content-Type':"application/x-www-form-urlencoded"};
    public ajaxRequestParam:string = "?ajaxRequest=1";
    public account:any; 
    public cart:any;
    public success:boolean;
    public hasErrors:boolean;
    public errors:string;
    public http:ng.IHttpService;
    public header:any;
    private baseUrl = "";
    public shippingAddress = "";
    public billingAddress = "";
    
    //@ngInject
    constructor(public $http:ng.IHttpService, public $q:ng.IQService) { 
        this.baseUrl = "/index.cfm/api/scope/";
        this.$http = $http;
        this.$q = $q
    }
    
    /** accessors for account */
    public getAccount=(refresh:boolean):any =>  {
        let urlBase = this.baseUrl + 'getAccount/' + this.ajaxRequestParam + "&returnJsonObject=cart,account";
        var deferred = this.$q.defer();
        this.$http.get(urlBase).success((result:any)=>{
            this.account = result;
            console.log("Account:", this.account);
            deferred.resolve(result);
        }).error((reason)=>{
            deferred.reject(reason);  
        });
        return deferred.promise
    }
    /** accessors for cart */
    public getCart=(refresh:boolean):any =>  {
        let urlBase = this.baseUrl + 'getCart/' + this.ajaxRequestParam;
        var deferred = this.$q.defer();
        this.$http.get(urlBase).success((result:any)=>{
            this.cart = result;
            console.log("Cart:", this.cart);
            deferred.resolve(result);
        }).error((reason)=>{
            deferred.reject(reason);  
        });
        return deferred.promise;
    }
    /** accessors for countries */
    public getCountries=(refresh:boolean):any =>  {
        let urlBase = this.baseUrl + 'getCountries/' + this.ajaxRequestParam;
        var deferred = this.$q.defer();
        this.$http.get(urlBase).success((result:any)=>{
            this.cart = result;
            console.log("Countries:", this.cart);
            deferred.resolve(result);
        }).error((reason)=>{
            deferred.reject(reason);  
        });
        return deferred.promise;
    }
    /** accessors for states */
    public getStates=(refresh:boolean):any =>  {
        let urlBase = this.baseUrl + 'getStates/' + this.ajaxRequestParam;
        var deferred = this.$q.defer();
        this.$http.get(urlBase).success((result:any)=>{
            this.cart = result;
            console.log("States:", this.cart);
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
    public doAction=(action:string, data:any) => {
        this.hasErrors = false;
        this.success = false;
        this.errors = undefined;
        this.header = {headers: this.formType};
        var deferred = this.$q.defer();
        if (!action) {throw "Action is required exception";}
        data.returnJsonObjects = "cart,account";
        let urlBase = this.baseUrl + action + this.ajaxRequestParam;
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
    
    /**
     * Helper method to get orderitems
     */
    public getOrderItems = ():any =>{
        let orderItems = [];
        if (this.cart.orderitems !== undefined && this.cart.orderitems.length){
            for (var item in this.cart.orderitems){
                orderItems.push(item);
            }
        }
        return orderItems;
    }
    
    /**
     * Helper method to get order fulfillments
     */
    public getOrderFulfillments = ():any =>{
        let orderFulfillments = [];
        if (this.cart.orderfulfillments !== undefined && this.cart.orderfulfillments.length){
            for (var item in this.cart.orderfulfillments){
                orderFulfillments.push(item);
            }
        }
        return orderFulfillments;
    }
    
    /**
     * Helper method to get promotion codes
     */
    public getPromotionCodeList = ():any =>{
        if (this.cart && this.cart.promotionCodeList !== undefined){
            return this.cart.promotionCodeList;
        }  
    }
    
    /**
     * Helper method to get promotion codes
     */
    public getPromotionCodes = ():any =>{
        let promoCodes = [];
        if (this.cart && this.cart.promotionCodes.length){
            for (var p in this.cart.promotionCodes){
                promoCodes.push(this.cart.promotionCodes[p].promotionCode);
                
            }
            return promoCodes;
        }  
    }
}
export {PublicService};

