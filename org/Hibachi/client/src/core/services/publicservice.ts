/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class PublicService {
    public formType = {'Content-Type':"application/x-www-form-urlencoded"};
    public ajaxRequestParam:string = "?ajaxRequest=1";
    public account:any; 
    public cart:any;
    public states:any;
    public countries:any;
    public success:boolean;
    public hasErrors:boolean;
    public errors:string;
    public http:ng.IHttpService;
    public header:any;
    private baseActionPath = "";
    public shippingAddress = "";
    public billingAddress = "";
    ///index.cfm/api/scope/
    //@ngInject
    constructor(public $http:ng.IHttpService, public $q:ng.IQService) { 
        
        this.baseActionPath = "/index.cfm/api/scope/"; //default path
        this.$http = $http;
        this.$q = $q
        
    }
    /** accessors for account */
    public getAccount=(refresh:boolean):any =>  {
        let urlBase = this.baseActionPath + 'getAccount/';
        var result = this.doAction(urlBase);
        console.log("Result: ", result);
        return result;
    }
    /** accessors for cart */
    public getCart=(refresh:boolean):any =>  {
        let urlBase = this.baseActionPath + 'getCart/';
        var result = this.doAction(urlBase);
        console.log("Result: ", result);
        return result;
    }
    /** accessors for countries */
    public getCountries=(refresh:boolean):any =>  {
        let urlBase = this.baseActionPath + 'getCountries/';
        var result = this.doAction(urlBase);
        console.log("Result: ", result);
        return result;
    }
    /** accessors for states */
    public getStates=(refresh:boolean):any =>  {
        let urlBase = this.baseActionPath + 'getStates/';
        var result = this.doAction(urlBase);
        console.log("Result: ", result);
        return result;
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
            this.baseActionPath = "/index.cfm/api/scope/" //public path
        }
        
        this.hasErrors = false;
        this.success = false;
        this.errors = undefined;
        this.header = {headers: this.formType};
        var deferred = this.$q.defer();
        
       
        
        let urlBase = this.baseActionPath + action + this.ajaxRequestParam;
        
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
            this.baseActionPath + this.ajaxRequestParam + "&returnJsonObject=cart,account";
            var deferred = this.$q.defer();
            this.$http.get(urlBase).success((result:any)=>{
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

