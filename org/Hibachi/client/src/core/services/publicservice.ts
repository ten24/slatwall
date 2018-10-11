/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Cart} from "../model/entity/cart";
import {Account} from "../model/entity/account";
import {PublicRequest} from "../model/transient/publicrequest";

class PublicService {
    public account:Account;
    public cart:any;
    public states:any;
    public countries:any;
    public addressOptions:any;
    public requests:{ [action: string]: PublicRequest; }={};
    public messages:any;
    public errors:{[key:string]:any}={};
    public newBillingAddress:any;
    public newCardInfo:any;
    public loading:boolean;
    public accountDataPromise:any;
    public addressOptionData:any;
    public cartDataPromise:any;
    public countryDataPromise:any;
    public stateDataPromise:any;
    public addressZoneStateDataPromise:any;
    public lastSelectedShippingMethod:any;
    public http:ng.IHttpService;
    public confirmationUrl:string;
    public checkoutUrl:string;
    public header:any;
    public window:any;
    public finding:boolean;
    public rates:any;
    private baseActionPath = "";
    public months = [{name:'01 - JAN',value:1},{name:'02 - FEB',value:2},{name:'03 - MAR',value:3},{name:'04 - APR',value:4},{name:'05 - MAY',value:5},{name:'06 - JUN',value:6},{name:'07 - JUL',value:7},{name:'08 - AUG',value:8},{name:'09 - SEP',value:9},{name:'10 - OCT',value:10},{name:'11 - NOV',value:11},{name:'12 - DEC',value:12}];
    public years = [];
    public shippingAddress = "";
    public emailFulfillmentAddress:any;
    public billingAddress:any;
    public accountAddressEditFormIndex = [];
    public billingAddressEditFormIndex:any;
    public selectedBillingAddress:any;
    public editingAccountAddress:any;
    public editingBillingAddress:any;
    public shippingAddressErrors:any;
    public billingAddressErrors:any;
    public activePaymentMethod:string;
    public paymentMethods:any;
    public orderPlaced:boolean;
    public useShippingAsBilling:boolean;
    public saveShippingAsBilling:boolean;
	public readyToPlaceOrder:boolean;
    public saveCardInfo:boolean;
    public orderPaymentObject:any;
    public edit:String;
    public editPayment:boolean;
    public showCreateAccount:boolean;
    public showStoreSelector = [];
    public showEmailSelector = [];
    public lastRemovedPromoCode;
    public lastRemovedGiftCard;
    public imagePath:{[key:string]:any}={};
    public successfulActions = [];
    public failureActions = [];
    public addBillingAddressErrors;
    public uploadingFile;
    public orderItem;
    public cmsSiteID;

    ///index.cfm/api/scope/

    //@ngInject
    constructor(
        public $http:ng.IHttpService,
        public $q:ng.IQService,
        public $window:any,
        public $location:ng.ILocationService,
        public $hibachi:any,
        public $injector:ng.auto.IInjectorService,
        public requestService,
        public accountService,
        public accountAddressService,
        public cartService,
        public orderService,
        public observerService,
        public appConfig,
        public $timeout
    ) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.accountService = accountService;
        this.accountAddressService = accountAddressService;
        this.requestService = requestService;
        this.appConfig = appConfig;
        this.baseActionPath = this.appConfig.baseURL+"/index.cfm/api/scope/"; //default path
        this.confirmationUrl = "/order-confirmation";
        this.checkoutUrl = "/checkout";
        this.$http = $http;
        this.$location = $location;
        this.$q = $q;
        this.$injector=$injector;
        this.getExpirationYears();
        this.$window = $window;
        this.$hibachi = $hibachi;
        this.cart = this.cartService.newCart();
        this.account = this.accountService.newAccount();
        this.observerService = observerService;
        this.$timeout = $timeout;
    }

    // public hasErrors = ()=>{

    //     return this.errors.length;
    // }

    /**
     * Helper methods for getting errors from the cart
     */
    public getErrors = ():{} =>{
        this.errors = {};
        for(var key in this.requests){
            var request = this.requests[key];
            if(Object.keys(request.errors).length){
                this.errors[key] = request.errors;
            }
         }

        return this.errors;
    }

    /** grab the valid expiration years for credit cards  */
    public getExpirationYears=():any =>{

        var baseDate = new Date();
        var today = baseDate.getFullYear();
        var start = today;
        for (var i = 0; i<= 15; i++){
            this.years.push({
                name:start + i,
                value:start + i,
            });
        }
    }
    /** accessors for account */
    public getAccount=(refresh=false):any =>  {
        let urlBase = this.baseActionPath+'getAccount/';
        if(!this.accountDataPromise || refresh){
            this.accountDataPromise = this.getData(urlBase, "account", "");
        }
        return this.accountDataPromise;
    }
    /** accessors for cart */
    public getCart=(refresh=false):any =>  {
        let urlBase = this.baseActionPath+'getCart/';
        if(!this.cartDataPromise || refresh){
            this.cartDataPromise = this.getData(urlBase, "cart", "");
        }
        return this.cartDataPromise;
    }
    /** accessors for countries */
    public getCountries=(refresh=false):any =>  {
        let urlBase = this.baseActionPath+'getCountries/';
        if(!this.countryDataPromise || refresh){
            this.countryDataPromise = this.getData(urlBase, "countries", "");
        }
        return this.countryDataPromise;
    }

    /** accessors for states */
    public getStates=(countryCode:string, address:any, refresh=false):any =>  {
        
       if(address && address.data){
           countryCode = address.data.countrycode || address.countrycode;
       }
       if(typeof address === 'boolean' && !angular.isDefined(refresh)){
       		refresh = address;
       }
       if (!countryCode) countryCode = "US";
       
       let urlBase = this.baseActionPath+'getStateCodeOptionsByCountryCode/';

       if(!this.getRequestByAction('getStateCodeOptionsByCountryCode') || !this.getRequestByAction('getStateCodeOptionsByCountryCode').loading || refresh){
           
           this.stateDataPromise = this.getData(urlBase, "states", "?countryCode="+countryCode);
           return this.stateDataPromise;
       }

       return this.stateDataPromise;
    }

    public refreshAddressOptions = (address) =>{
        this.getStates(null, address);
        this.getAddressOptions(null,address);
    }

    public getStateByStateCode = (stateCode)=>{
        if (!angular.isDefined(this.states) || !angular.isDefined(this.states.stateCodeOptions) || !angular.isDefined(stateCode)){
            return;
        }
        for (var state in this.states.stateCodeOptions){
            if (this.states.stateCodeOptions[state].value == stateCode){
                return this.states.stateCodeOptions[state];
            }
        }
    }

    public getCountryByCountryCode = (countryCode)=>{
        if (!angular.isDefined(this.countries) || !angular.isDefined(this.countries.countryCodeOptions)){
            return;
        }
        if(!countryCode){
            countryCode = 'US';
        }
        for (var country in this.countries.countryCodeOptions){
            if (this.countries.countryCodeOptions[country].value == countryCode){
                return this.countries.countryCodeOptions[country];
            }
        }
    }

    /** accessors for states */
    public getAddressOptions=(countryCode:string, address:any, refresh=false):any =>  {
       if(address && address.data){
           countryCode = address.data.countrycode || address.countrycode;
       }
       if (!angular.isDefined(countryCode)) countryCode = "US";

       if(typeof address === 'boolean' && !angular.isDefined(refresh)){
       		refresh = address;
       }

       let urlBase = this.baseActionPath+'getAddressOptionsByCountryCode/';
       if(!this.getRequestByAction('getAddressOptionsByCountryCode') || !this.getRequestByAction('getAddressOptionsByCountryCode').loading || refresh){
           this.addressOptionData = this.getData(urlBase, "addressOptions", "?countryCode="+countryCode);
           return this.addressOptionData;
       }
       return this.addressOptionData;
    }

    /** accessors for states */
    public getData=(url, setter, param):any =>  {

        let urlBase = url + param;
        let request = this.requestService.newPublicRequest(urlBase);

        request.promise.then((result:any)=>{
            //don't need account and cart for anything other than account and cart calls.
            if (setter.indexOf('account') == -1 || setter.indexOf('cart') == -1){
                if (result['account']){delete result['account'];}
                if (result['cart']){delete result['cart'];}
            }

            if(setter == 'cart'||setter=='account' && this[setter] && this[setter].populate){
                //cart and account return cart and account info flat
                this[setter].populate(result);

            }else{
                //other functions reutrn cart,account and then data
                if(setter == 'states'){
                    this[setter]={};
                    this.$timeout(()=>{
                        this[setter]=(result);
                    });
                }else{
                    this[setter]=(result);
                }
            }

        }).catch((reason)=>{


        });

        this.requests[request.getAction()]=request;
        return request.promise;
    }

    /** sets the current shipping address */
    public setShippingAddress=(shippingAddress) => {
        this.shippingAddress = shippingAddress;
    }

    /** sets the current shipping address */
    public setBillingAddress=(billingAddress) => {
        this.billingAddress = billingAddress;
    }

    /** sets the current billing address */
    public selectBillingAddress=(key) => {

        if(this.orderPaymentObject && this.orderPaymentObject.forms){
            let address = this.account.accountAddresses[key].address
            address.accountAddressID = this.account.accountAddresses[key].accountAddressID;
            for(let property in address){
                for(let form in this.orderPaymentObject['forms']){
                    form = this.orderPaymentObject['forms'][form];
                    if(form['newOrderPayment.billingAddress.'+property] != undefined){
                        form['newOrderPayment.billingAddress.'+property].$setViewValue(address[property]);
                    }
                }
            }
            this.orderPaymentObject.newOrderPayment.billingAddress = address;

        }
    }

    /** this is the generic method used to call all server side actions.
    *  @param action {string} the name of the action (method) to call in the public service.
    *  @param data   {object} the params as key value pairs to pass in the post request.
    *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
    */
    public doAction=(action:string, data?:any, method?:any) => {
        //purge angular $ prefixed propertie
        //Prevent sending the same request multiple times in parallel
        if(this.getRequestByAction(action) && this.loadingThisRequest(action, data, false)) return this.$q.when();

        if (!action) {throw "Action is required exception";}

        var urlBase = this.appConfig.baseURL;

        //check if the caller is defining a path to hit, otherwise use the public scope.
        if (action.indexOf(":") !== -1){
            urlBase = urlBase + action; //any path
        }else{
            urlBase = this.baseActionPath + action;//public path
        }


        if(data){
            method = "post";
            data.returnJsonObjects = "cart,account";
            if(this.cmsSiteID){
                data.cmsSiteID = this.cmsSiteID;
            }
        }else{
            urlBase += (urlBase.indexOf('?') == -1) ? '?' : '&';
            urlBase += "returnJsonObject=cart,account";
            if(this.cmsSiteID){
                urlBase += "&cmsSiteID=" + this.cmsSiteID;
            }
        }
        if (method == "post"){

             data.returnJsonObjects = "cart,account";
            //post
            let request:PublicRequest = this.requestService.newPublicRequest(urlBase,data,method)

            request.promise.then((result:any)=>{
                this.processAction(result,request);
            }).catch((response)=>{

            });
            this.requests[request.getAction()]=request;
            return request.promise;
        }else{
            //get
            var url = urlBase;
            let request = this.requestService.newPublicRequest(url,data,method);

            request.promise.then((result:any)=>{
                this.processAction(result,request);
            }).catch((reason)=>{

            });

            this.requests[request.getAction()]=request;
            return request.promise;
        }

    }

    public uploadFile = (action, data) =>{
        this.$timeout(()=>{
            this.uploadingFile = true;
        });

        let url = this.appConfig.baseURL + action;

        let formData = new FormData();

        formData.append("fileName", data.fileName);
        formData.append("uploadFile", data.uploadFile);

        var xhr = new XMLHttpRequest();
        xhr.open('POST', url, true);

        xhr.onload = (result)=>{
            var response = JSON.parse(xhr.response);
            if (xhr.status === 200) {
               this.processAction(response, null);
               this.successfulActions = response.successfulActions;
               this.failureActions = response.failureActions;
            }
            this.$timeout(()=>{
                this.uploadingFile = false;
            });
        };
        xhr.send(formData);
    }

    private processAction = (response,request:PublicRequest)=>{

        //Run any specific adjustments needed
        this.runCheckoutAdjustments(response);

        //if the action that was called was successful, then success is true.
        if (request && request.hasSuccessfulAction()){
            this.successfulActions = [];
            for (var action in request.successfulActions){
                this.successfulActions.push(request.successfulActions[action].split('.')[1]);
                if (request.successfulActions[action].indexOf('public:cart.placeOrder') !== -1){
                    this.$window.location.href = this.confirmationUrl;
                    return;
                }else if (request.successfulActions[action].indexOf('public:cart.finalizeCart') !== -1){
                    this.$window.location.href = this.checkoutUrl;
                    return;
                }else if(request.successfulActions[action].indexOf('public:account.logout') !== -1){
                    this.account = this.$hibachi.newAccount();
                }
            }
        }

        if(request && request.hasFailureAction()){
            this.failureActions = [];
            for (var action in request.failureActions){
                this.failureActions.push(request.failureActions[action].split('.')[1]);
            }
        }

        /** update the account and the cart */
        if(response.account){
            this.account.populate(response.account);
            this.account.request = request;
        }
        if(response.cart){
            this.cart.populate(response.cart);
            this.cart.request = request;
        }
        this.errors = response.errors;
        if(response.messages){
            this.messages = response.messages;
        }
    }

    public runCheckoutAdjustments = (response) =>{
        this.filterErrors(response);
        if(response.cart){
            this.removeInvalidOrderPayments(response.cart);
        }
    }

    public getRequestByAction = (action:string)=>{
        return this.requests[action];
    }

    /**
     * Helper methods so that everything in account and cart can be accessed using getters.
     */
    public userIsLoggedIn = ():boolean =>{
       return this.account.userIsLoggedIn();
    }

    public getActivePaymentMethods = ()=>{
        let urlString = "/?"+this.appConfig.action+"=admin:ajax.getActivePaymentMethods";
        let request = this.requestService.newPublicRequest(urlString)
        .then((result:any)=>{
            if (angular.isDefined(result.data.paymentMethods)){
                this.paymentMethods = result.data.paymentMethods;
            }
        });
        this.requests[request.getAction()]=request;
    };

    public filterErrors = (response)=>{
        if(!response || !response.cart || !response.cart.errors) return;
        let cartErrors = response.cart.errors;
        if(cartErrors.addOrderPayment){
            cartErrors.addOrderPayment = cartErrors.addOrderPayment.filter((error)=>error != 'billingAddress');
        }
    }

    /** Uses getRequestByAction() plus an identifier to distinguish between different functionality using the same route*/
    public loadingThisRequest = (action, conditions, strict) =>{
        let request = this.getRequestByAction(action);
        if(!request || !request.loading) return false;

        for(let identifier in conditions){
            if (!((conditions[identifier] === true && !strict) || request.data[identifier] == conditions[identifier])){
                return false;
            }
        }
        return true;
    }

    public removeInvalidOrderPayments = (cart) =>{
        cart.orderPayments = cart.orderPayments.filter((payment)=>!payment.hasErrors);
    }

    /**
     * Given a payment method name, returns the id.
     */
    public getPaymentMethodID = (name)=>{
        for (var method in this.paymentMethods){
            if (this.paymentMethods[method].paymentMethodName == name && this.paymentMethods[method].activeFlag == "Yes "){
                return this.paymentMethods[method].paymentMethodID;
            }
        }
    }

    /** Returns a boolean indicating whether or not the order has the named payment method.*/
    public hasPaymentMethod = (paymentMethodName)=>{
        for (var payment of this.cart.orderPayments){
            if(payment.paymentMethod.paymentMethodName === paymentMethodName) return true;
        }
        return false;
    }

    public hasCreditCardPaymentMethod = ()=>{
        return this.hasPaymentMethod("Credit Card");
    }

    public hasPaypalPaymentMethod = ()=>{
        return this.hasPaymentMethod("PayPal Express");
    }

    public hasGiftCardPaymentMethod = ()=>{
        return this.hasPaymentMethod("Gift Card");
    }

    public hasMoneyOrderPaymentMethod = ()=>{
        return this.hasPaymentMethod("Money Order");
    }
    public hasCashPaymentMethod = ()=>{
        return this.hasPaymentMethod("Cash");
    }

    /** Returns a boolean indicating whether or not the order has the named fulfillment method.*/
    public hasFulfillmentMethod = (fulfillmentMethodName) => {
        for (var fulfillment of this.cart.orderFulfillments){
            if(fulfillment.fulfillmentMethod.fulfillmentMethodName === fulfillmentMethodName) return true;
        }
        return false;
    }

    public hasShippingFulfillmentMethod = ()=>{
        return this.hasFulfillmentMethod("Shipping");
    }

    public hasEmailFulfillmentMethod = ()=>{
        return this.hasFulfillmentMethod("Email");
    }

    public hasPickupFulfillmentMethod = ()=>{
        return this.hasFulfillmentMethod("Pickup");
    }

    public getFulfillmentType = (fulfillment)=>{
        return fulfillment.fulfillmentMethod.fulfillmentMethodType;
    }

    public isShippingFulfillment = (fulfillment) =>{
        return this.getFulfillmentType(fulfillment) === 'shipping';
    }

    public isEmailFulfillment = (fulfillment) =>{
        return this.getFulfillmentType(fulfillment) === 'email';
    }

    public isPickupFulfillment = (fulfillment) =>{
        return this.getFulfillmentType(fulfillment) === 'pickup';
    }

    /** Returns true if the order fulfillment has a shipping address selected. */
    public hasShippingAddress = (fulfillmentIndex) => {
        return (
            this.cart.orderFulfillments[fulfillmentIndex] &&
            this.isShippingFulfillment(this.cart.orderFulfillments[fulfillmentIndex]) && 
            this.cart.orderFulfillments[fulfillmentIndex].data.shippingAddress &&
            this.cart.orderFulfillments[fulfillmentIndex].data.shippingAddress.addressID
        );
    }

    public hasShippingMethodOptions = (fulfillmentIndex) => {
        let shippingMethodOptions = this.cart.orderFulfillments[fulfillmentIndex].shippingMethodOptions;
        return shippingMethodOptions && shippingMethodOptions.length && (shippingMethodOptions.length > 1 || (shippingMethodOptions[0].value && shippingMethodOptions[0].value.length));
    }

    /** Returns true if the order fulfillment has a shipping address selected. */
    public hasPickupLocation = (fulfillmentIndex) => {
        return (
            this.cart.orderFulfillments[fulfillmentIndex] &&
            this.isPickupFulfillment(this.cart.orderFulfillments[fulfillmentIndex]) && 
            this.cart.orderFulfillments[fulfillmentIndex].pickupLocation
        );
    }

    /** Returns true if the order requires a fulfillment */
    public orderRequiresFulfillment = ():boolean=> {

        return this.cart.orderRequiresFulfillment();
    };

    /**
     *  Returns true if the order requires a account
     *  Either because the user is not logged in, or because they don't have one.
     *
     */
    public orderRequiresAccount = ():boolean=> {
        return this.cart.orderRequiresAccount();
    };

    /** Returns true if the payment tab should be active */
    public hasShippingAddressAndMethod = ():boolean => {
        return this.cart.hasShippingAddressAndMethod();
    };

    /**
     * Returns true if the user has an account and is logged in.
     */
    public hasAccount = ():boolean=>{
        if ( this.account.accountID ) {
            return true;
        }
        return false;
    }

    /** Redirects to the passed in URL
    */
    public redirectExact = (url:string)=>{
        this.$window.location.href= url ;
    }

    // /** Returns true if a property on an object is undefined or empty. */
    public isUndefinedOrEmpty = (object, property)=> {
        if (!angular.isDefined(object[property]) || object[property] == ""){
            return true;
        }
        return false;
    }

    /** A simple method to return the quantity sum of all orderitems in the cart. */
    public getOrderItemQuantitySum = ()=>{
        var totalQuantity = 0;
        if (angular.isDefined(this.cart)){
            return this.cart.getOrderItemQuantitySum();
        }
        return totalQuantity;
    }
    /** Returns the index of the state from the list of states */
    public getSelectedStateIndexFromStateCode = (stateCode, states)=>{
        for (var state in states){
            if (states[state].value == stateCode){
                return state;
            }
        }
    }
    
    /** Selects shippingAddress*/
    public selectShippingAccountAddress = (accountAddressID,orderFulfillmentID)=>{
        this.doAction('addShippingAddressUsingAccountAddress', {accountAddressID:accountAddressID,fulfillmentID:orderFulfillmentID});
    }
    
     /** Selects shippingAddress*/
    public selectBillingAccountAddress = (accountAddressID)=>{
        this.doAction('addBillingAddressUsingAccountAddress', {accountAddressID:accountAddressID});
    }

    /**
     * Returns true if on a mobile device. This is important for placeholders.
     */
     public isMobile = ()=>{
           if(this.$window.innerWidth <= 800 && this.$window.innerHeight <= 600) {
             return true;
           }
           return false;
     };

     /** returns true if the shipping method option passed in is the selected shipping method
     */
     public isSelectedShippingMethod = (option, fulfillmentIndex) =>{
 	// DEPRECATED LOGIC
     	if(typeof option === 'number' || typeof option === 'string'){
     		let index = option, value = fulfillmentIndex;
     		let orderFulfillment;
     		for(let fulfillment of this.cart.orderFulfillments){
     			if(this.isShippingFulfillment(fulfillment)){
     				orderFulfillment = fulfillment;
     			}
     		}
     		if (this.cart.fulfillmentTotal &&
                value == orderFulfillment.shippingMethod.shippingMethodID ||
                orderFulfillment.shippingMethodOptions.length == 1){
                return true;
            }
            return false;

     	}
 	//NEW LOGIC
         return (this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod && 
             this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod.shippingMethodID == option.value) || 
            (this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethodOptions.length == 1);
     }

     /** Select a shipping method - temporarily changes the selected method on the front end while awaiting official change from server
     */
     public selectShippingMethod = (option, orderFulfillment:any) =>{
         let fulfillmentID = '';
         if(typeof orderFulfillment == 'string'){
             orderFulfillment = this.cart.orderFulfillments[orderFulfillment];
         }
         let data = {
             'shippingMethodID': option.value,
             'fulfillmentID':orderFulfillment.orderFulfillmentID
         };
         this.doAction('addShippingMethodUsingShippingMethodID', data);
         if(!orderFulfillment.data.shippingMethod){
             orderFulfillment.data.shippingMethod = {};
         }
         orderFulfillment.data.shippingMethod.shippingMethodID = option.value;
     }

     /** Removes promotional code from order*/
     public removePromoCode = (code)=>{
         this.doAction('removePromotionCode', {promotionCode:code});
     }
     
     public deleteAccountAddress = (accountAddressID:string)=>{
         this.doAction('deleteAccountAddress',{accountAddressID:accountAddressID})
     }

    //gets the calcuated total minus the applied gift cards.
    public getTotalMinusGiftCards = ()=>{
        var total = this.getAppliedGiftCardTotals();
        return this.cart.calculatedTotal - total;
    };

    /** Format saved payment method info for display in list*/
    public formatPaymentMethod = (paymentMethod) =>{
        return (paymentMethod.accountPaymentMethodName || paymentMethod.nameOnCreditCard) + ' - ' + paymentMethod.creditCardType + ' *' + paymentMethod.creditCardLastFour + ' exp. ' + ('0' + paymentMethod.expirationMonth).slice(-2) + '/' + paymentMethod.expirationYear.toString().slice(-2)
    }

    public getOrderItemSkuIDs = (cart) =>{
        return cart.orderItems.map(item=>{
            return item.sku.skuID;
        }).join(',');
    }

    public getResizedImageByProfileName = (profileName, skuIDs)=>{
       this.loading = true;
       
       if (profileName == undefined){
           profileName = "medium";
       }
       
       this.doAction('getResizedImageByProfileName',{profileName:profileName,skuIds:skuIDs}).then((result:any)=>{
            if(!angular.isDefined(this.imagePath)){
                this.imagePath = {};
            }
            if (result.resizedImagePaths){
                for(var skuID in result.resizedImagePaths){
                    this.imagePath[skuID] = result.resizedImagePaths[skuID]
                }
            }
        })
    };

    /** Returns the amount total of giftcards added to this order.*/
    public getPaymentTotals = ()=>{
        //
        var total = 0;
        for (var index in this.cart.orderPayments){
            total = total + Number(this.cart.orderPayments[index]['amount'].toFixed(2));
        }
        return total;
     };

    /** Gets the calcuated total minus the applied gift cards. */
    public getTotalMinusPayments = ()=>{
        var total = this.getPaymentTotals();
        return this.cart.calculatedTotal - total;
    };

    /** Boolean indicating whether the total balance has been accounted for by order payments.*/
    public paymentsEqualTotalBalance = () =>{
        return this.getTotalMinusPayments() == 0;
    }

    /**View logic - Opens review panel if no more payments are due.*/
    public checkIfFinalPayment = () =>{
        if((this.getRequestByAction('addOrderPayment') && this.getRequestByAction('addOrderPayment').hasSuccessfulAction() || 
            this.getRequestByAction('addGiftCardOrderPayment') && this.getRequestByAction('addGiftCardOrderPayment').hasSuccessfulAction()
            ) && this.paymentsEqualTotalBalance()){
            this.edit = 'review';
        }
    }

    public getAddressEntity = (address) =>{
        let addressEntity = this.$hibachi.newAddress();
        if(address){
            for(let key in address){
                if(address.hasOwnProperty(key)){
                    addressEntity[key] = address[key];
                }
			}
		}
        return addressEntity;
	}

    public resetRequests = (request) => {
         delete this.requests[request];
    }

    /** Returns true if the addresses match. */
    public addressesMatch = (address1, address2) => {
        if (angular.isDefined(address1) && angular.isDefined(address2)){
            if ( (address1.streetAddress == address2.streetAddress &&
                address1.street2Address == address2.street2Address &&
                address1.city == address2.city &&
                address1.postalCode == address2.postalCode &&
                address1.stateCode == address2.stateCode &&
                address1.countrycode == address2.countrycode)){
                return true;
            }
        }
        return false;
    }

      /**
     *  Returns true when the fulfillment body should be showing
     *  Show if we don't need an account but do need a fulfillment
     *
     */
    public showFulfillmentTabBody = ()=> {
        if(!this.hasAccount()) return false;
        if ((this.cart.orderRequirementsList.indexOf('account') == -1) &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') != -1) && !this.edit ||
            (this.edit == 'fulfillment')) {
            return true;
        }
        return false;
    };
    /**
     *  Returns true when the fulfillment body should be showing
     *  Show if we don't need an account,fulfillment, and don't have a payment - or
     *  we have a payment but are editting the payment AND nothing else is being edited
     *
     */

    public showPaymentTabBody = ()=> {
        if(!this.hasAccount()) return false;
        if (((this.cart.orderRequirementsList.indexOf('account') == -1) &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
            (this.cart.orderRequirementsList.indexOf('payment') != -1) && !this.edit) ||
            ((this.cart.orderRequirementsList.indexOf('account') == -1) &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
            (this.edit == 'payment'))) {
            return true;
        }
        return false;
    };

    /**
     *  Returns true if the review tab body should be showing.
     *  Show if we don't need an account,fulfillment,payment, but not if something else is being edited
     *
     */
    public showReviewTabBody = ()=> {
        if(!this.hasAccount()) return false;
        if ((this.cart.orderRequirementsList.indexOf('account') == -1) &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
            (this.cart.orderRequirementsList.indexOf('payment') == -1) &&
            ((!this.edit) || (this.edit == 'review'))) {
            return true;
        }
        return false;
    };
    /** Returns true if the fulfillment tab should be active */
    public fulfillmentTabIsActive = ()=> {
        if(!this.hasAccount()) return false;

        if ((this.edit == 'fulfillment') ||
            (!this.edit && ((this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID) &&
                (this.cart.orderRequirementsList.indexOf('fulfillment') != -1))) {
            return true;
        }
        return false;
    };

    /** Returns true if the payment tab should be active */
    public paymentTabIsActive = ()=> {
        if(!this.hasAccount()) return false;
        if ((this.edit == 'payment') ||
            (!this.edit &&
                (this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID &&
                (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                (this.cart.orderRequirementsList.indexOf('payment') != -1))) {
            return true;
        }
        return false;
    };



    public isCreatingAccount = () =>{
        return !this.hasAccount() && this.showCreateAccount;
    }

    public isSigningIn = () =>{
        return !this.hasAccount() && !this.showCreateAccount;
    }

    public loginError = () => {
        if(this.account.processObjects && this.account.processObjects.login && this.account.processObjects.login.hasErrors){
            return this.account.processObjects.login.errors.emailAddress['0'];
        };
    }

    public createAccountError = () =>{
        if(this.account.processObjects && this.account.processObjects.create && this.account.processObjects.create.hasErrors){
            return this.account.processObjects.create.errors;
        }
    }

    public forgotPasswordNotSubmitted = () =>{
        return !this.account.processObjects || (!this.account.hasErrors && !this.account.processObjects.forgotPassword);
    }
    public forgotPasswordSubmitted = () =>{
        return this.account.processObjects && this.account.processObjects.forgotPassword;
    }
    public forgotPasswordHasNoErrors = ()=>{
        return this.account.processObjects && this.account.processObjects.forgotPassword && !this.account.processObjects.forgotPassword.hasErrors
    }

    public forgotPasswordError = ()=>{
        if(this.forgotPasswordSubmitted() && !this.forgotPasswordHasNoErrors()){
            return this.account.processObjects.forgotPassword.errors.emailAddress['0']
        }
    }

    /** Consolidate response errors on cart.errors.runPlaceOrderTransaction*/
    public placeOrderFailure = () =>{
        let errors = [];
        for(let key in this.cart.errors){
            let errArray = this.cart.errors[key];
            errors = errors.concat(errArray);
        }
        this.cart.errors.runPlaceOrderTransaction = errors;
        this.edit = '';
    }

    /** Returns errors from placeOrder request*/
    public placeOrderError = () =>{
        if(this.cart.hasErrors && this.cart.errors.runPlaceOrderTransaction){
            return this.cart.errors.runPlaceOrderTransaction;
        }
    }

    /** Returns errors from addOrderPayment request. */
    public addOrderPaymentError = () =>{
        if(this.cart.errors.addOrderPayment) return this.cart.errors.addOrderPayment;
        if(this.cart.errors.runPlaceOrderTransaction) return this.cart.errors.runPlaceOrderTransaction;
        return angular.isDefined(this.errors) ? this.errors['ADDORDERPAYMENT'] : false;
    }

    /** Returns errors from addBillingAddress request. */
    public addBillingAddressError = () =>{
        if(this.loadingThisRequest('addOrderPayment',{},false)) return false;
        if(this.errors && this.errors.copied) return this.addBillingAddressErrors;
        
        this.addBillingAddressErrors = this.cart.errors.addBillingAddress || (angular.isDefined(this.errors) ? this.errors['addBillingAddress'] : false);

        if(!this.billingAddressEditFormIndex && this.errors && this.hasFailureAction('addBillingAddress')){
            let addressProperties = this.$hibachi.newAddress().data;
            for(let property in this.errors){
                if(addressProperties.hasOwnProperty(property)){

                    this.addBillingAddressErrors = this.addBillingAddressErrors || [];

                    this.errors[property].forEach((error)=>{
                        this.addBillingAddressErrors.push(error);
                    })
                }
            }
            this.errors.copied = 1;
        }
        
        return this.addBillingAddressErrors;
    }

    /** Returns errors from addGiftCard request. */
    public giftCardError = () =>{
        if(this.cart.processObjects && 
            this.cart.processObjects.addOrderPayment &&
            this.cart.processObjects.addOrderPayment.errors &&
            this.cart.processObjects.addOrderPayment.errors.giftCardID){
            return this.cart.processObjects.addOrderPayment.errors.giftCardID[0];
        }
    }

    public editAccountAddress = (key, fulfillmentIndex) =>{
        this.clearShippingAddressErrors();
        this.accountAddressEditFormIndex[fulfillmentIndex] = key;
        this.editingAccountAddress = this.getAddressEntity(this.account.accountAddresses[key].address);
        this.editingAccountAddress.accountAddressName = this.account.accountAddresses[key].accountAddressName;
        this.editingAccountAddress.accountAddressID = this.account.accountAddresses[key].accountAddressID;
    }

    public editBillingAddress = (key, formName) =>{
        this.clearMessages();
        this.billingAddressEditFormIndex = key;
        this.selectedBillingAddress = null
        if(formName){
            this[formName + 'BillingAddress'] = this.getAddressEntity(this.account.accountAddresses[key].address);
            this[formName + 'BillingAddress'].accountAddressName = this.account.accountAddresses[key].accountAddressName;
            this[formName + 'BillingAddress'].accountAddressID = this.account.accountAddresses[key].accountAddressID;
        }else{
            this.billingAddress = this.getAddressEntity(this.account.accountAddresses[key].address);
            this.billingAddress.accountAddressName = this.account.accountAddresses[key].accountAddressName;
            this.billingAddress.accountAddressID = this.account.accountAddresses[key].accountAddressID;
        }
    }

    public clearShippingAddressErrors = ()=>{
        this.clearMessages();
        this.shippingAddressErrors = undefined;
    }

    public clearMessages = ()=>{
        this.successfulActions = [];
        this.failureActions = [];
    }

    public clearPaymentMethod = ()=>{
        this.activePaymentMethod = null;
    }

    /**Hides shipping address form, clears shipping address errors*/
    public hideAccountAddressForm = (fulfillmentIndex)=>{
        this.accountAddressEditFormIndex[fulfillmentIndex] = undefined;
    }

    public hideBillingAddressForm = ()=>{
        if(this.billingAddressEditFormIndex != undefined){
            let index = this.billingAddressEditFormIndex;
            if(this.billingAddressEditFormIndex == 'new'){
                index = this.account.accountAddresses.length - 1;
            }
            this.selectBillingAddress(index);
        }
        this.billingAddressEditFormIndex = undefined;
        this.billingAddress = {};
    }

    public editingDifferentAccountAddress = (fulfillmentIndex)=>{
        for(let index = 0; index < this.cart.orderFulfillments.length; index++){
            if(index !== fulfillmentIndex && this.accountAddressEditFormIndex[index] != undefined){
                return true;
            }
        }
    }

    public showEditAccountAddressForm = (fulfillmentIndex)=>{
        return this.accountAddressEditFormIndex[fulfillmentIndex] != undefined && this.accountAddressEditFormIndex[fulfillmentIndex] != 'new';
    }

    public showNewAccountAddressForm = (fulfillmentIndex)=>{
        return this.accountAddressEditFormIndex[fulfillmentIndex] == 'new';
    }

    public showNewBillingAddressForm = ()=>{
        return !this.useShippingAsBilling && this.billingAddressEditFormIndex == 'new';
    }

    public showEditBillingAddressForm = ()=>{
        return !this.useShippingAsBilling && this.billingAddressEditFormIndex != undefined && this.billingAddressEditFormIndex != 'new';
    }

    /** Adds errors from response to cart errors.*/
    public addBillingErrorsToCartErrors = ()=>{
        let cartErrors = this.cart.errors;
        if(cartErrors.addOrderPayment){
            let deleteIndex = cartErrors.addOrderPayment.indexOf('billingAddress');
            if(deleteIndex > -1){
                cartErrors.addOrderPayment.splice(deleteIndex,1);
            }
            if(cartErrors.addOrderPayment.length == 0){
                cartErrors.addOrderPayment = null;
            }
        }
        cartErrors.addBillingAddress = [];

        for(let key in this.errors){
            this.cart.errors.addBillingAddress = this.cart.errors.addBillingAddress.concat(this.errors[key]);
        }
    }

    public accountAddressIsSelectedShippingAddress = (key, fulfillmentIndex) =>{
        if(this.account && 
           this.account.accountAddresses &&
           this.cart.orderFulfillments[fulfillmentIndex].shippingAddress &&
           !this.cart.orderFulfillments[fulfillmentIndex].shippingAddress.hasErrors){
            return this.addressesMatch(this.account.accountAddresses[key].address, this.cart.orderFulfillments[fulfillmentIndex].shippingAddress);
        }        
        return false;
    }

    public accountAddressIsSelectedBillingAddress = (key) =>{
        if(this.account && 
           this.account.accountAddresses &&
           this.orderPaymentObject &&
           this.orderPaymentObject.newOrderPayment &&
           this.orderPaymentObject.newOrderPayment.billingAddress){
            return this.account.accountAddresses[key].accountAddressID == this.orderPaymentObject.newOrderPayment.billingAddress.accountAddressID;
        }
        return false;
    }

    public getOrderFulfillmentItemList(fulfillmentIndex){
        return this.cart.orderFulfillments[fulfillmentIndex].orderFulfillmentItems.map((item)=>item.sku.skuName ? item.sku.skuName : item.sku.product.productName).join(', ');
    }

    /** Returns true if order requires email fulfillment and email address has been chosen.*/
    public hasEmailFulfillmentAddress = (fulfillmentIndex)=>{
        return Boolean(this.cart.orderFulfillments[fulfillmentIndex].emailAddress)
    }

    public getEligiblePaymentMethodsForPaymentMethodType = (paymentMethodType) => {
        return this.cart.eligiblePaymentMethodDetails.filter(paymentMethod =>{
            return paymentMethod.paymentMethod.paymentMethodType == paymentMethodType;
        });
    }

    public getEligibleCreditCardPaymentMethods = () => {
        return this.getEligiblePaymentMethodsForPaymentMethodType('creditCard');
    }

    public getPickupLocation = (fulfillmentIndex) => {
        if(!this.cart.data.orderFulfillments[fulfillmentIndex]) return;
        return this.cart.data.orderFulfillments[fulfillmentIndex].pickupLocation;
    }

    public getShippingAddress = (fulfillmentIndex) => {
        if(!this.cart.data.orderFulfillments[fulfillmentIndex]) return;
        return this.cart.data.orderFulfillments[fulfillmentIndex].data.shippingAddress;
    }

    public getEmailFulfillmentAddress = (fulfillmentIndex) => {
        if(!this.cart.data.orderFulfillments[fulfillmentIndex]) return;
        return this.cart.data.orderFulfillments[fulfillmentIndex].emailAddress;
    }

    public getPickupLocations = () => {
        let locations = [];
        this.cart.orderFulfillments.forEach((fulfillment, index)=>{
            if(this.getFulfillmentType(fulfillment) == 'pickup' && fulfillment.pickupLocation && fulfillment.pickupLocation.locationID){
                fulfillment.pickupLocation.fulfillmentIndex = index;
                locations.push(fulfillment.pickupLocation);
            }
        })
        return locations;
    }

    public getShippingAddresses = () =>{
        let addresses = [];
        this.cart.orderFulfillments.forEach((fulfillment, index)=>{
            if(this.getFulfillmentType(fulfillment) == 'shipping' && fulfillment.data.shippingAddress && fulfillment.data.shippingAddress.addressID){
                fulfillment.data.shippingAddress.fulfillmentIndex = index;
                addresses.push(fulfillment.data.shippingAddress);
            }
        })
        return addresses;
    }

    public getEmailFulfillmentAddresses = () =>{
        let addresses = [];
        this.cart.orderFulfillments.forEach((fulfillment, index)=>{
            if(this.getFulfillmentType(fulfillment) == 'email' && fulfillment.emailAddress){
                fulfillment.fulfillmentIndex = index;
                addresses.push(fulfillment);
            }
        })
        return addresses;
    }
    /** Returns true if any action in comma-delimited list exists in this.successfulActions */
    public hasSuccessfulAction = (actionList:string) =>{
        for(let action of actionList.split(',')){
            if(this.successfulActions.indexOf(action) > -1){
                return true;
            }
        }
        return false;
    }

    /** Returns true if any action in comma-delimited list exists in this.failureActions */
    public hasFailureAction = (actionList:string) =>{
        for(let action of actionList.split(',')){
            if(this.failureActions.indexOf(action) > -1){
                return true;
            }
        }
        return false;
    }

    public shippingUpdateSuccess = () =>{
        return this.hasSuccessfulAction('addShippingAddressUsingAccountAddress,addShippingAddress');
    }

    public shippingMethodUpdateSuccess = () =>{
        return this.hasSuccessfulAction('addShippingMethodUsingShippingMethodID');
    }

    public updatedBillingAddress = () =>{
        return this.hasSuccessfulAction('updateAddress') && !this.hasSuccessfulAction('addShippingAddress');
    }

    public addedBillingAddress = () =>{
        return this.hasSuccessfulAction('addNewAccountAddress') && !this.hasSuccessfulAction('addShippingAddressUsingAccountAddress');
    }

    public addedShippingAddress = () =>{
        return this.hasSuccessfulAction('addNewAccountAddress') && this.hasSuccessfulAction('addShippingAddressUsingAccountAddress');
    }

    public emailFulfillmentUpdateSuccess = () =>{
        return this.hasSuccessfulAction('addEmailFulfillmentAddress');
    }

    public pickupLocationUpdateSuccess = () =>{
        return this.hasSuccessfulAction('addEmailFulfillmentAddress');
    }

    /** Returns true if selected pickup location has no name.*/
    public namelessPickupLocation = (fulfillmentIndex) => {
        if(!this.getPickupLocation(fulfillmentIndex)) return false;
        return this.getPickupLocation(fulfillmentIndex).primaryAddress != undefined && this.getPickupLocation(fulfillmentIndex).locationName == undefined
    }

    /** Returns true if no pickup location has been selected.*/
    public noPickupLocation = (fulfillmentIndex) => {
        if(!this.getPickupLocation(fulfillmentIndex)) return true;
        return this.getPickupLocation(fulfillmentIndex).primaryAddress == undefined && this.getPickupLocation(fulfillmentIndex).locationName == undefined
    }

    public disableContinueToPayment = () =>{
        return this.cart.orderRequirementsList.indexOf('fulfillment') != -1;
    }

    public hasAccountPaymentMethods = () => {
        return this.account && this.account.accountPaymentMethods && this.account.accountPaymentMethods.length
    }

    public showBillingAccountAddresses = () =>{
        return !this.useShippingAsBilling && this.billingAddressEditFormIndex == undefined;
    }

    public hasNoCardInfo = () =>{
        return !this.newCardInfo || !this.newCardInfo.nameOnCreditCard || !this.newCardInfo.cardNumber || !this.newCardInfo.cvv;
    }

    public isGiftCardPayment = (payment) =>{
        return payment.giftCard && payment.giftCard.giftCardCode;
    }

    public isPurchaseOrderPayment = (payment) =>{
        return payment.purchaseOrderNumber;
    }

    //Not particularly robust, needs to be modified for each project
    public isCheckOrMoneyOrderPayment = (payment) =>{
        return payment.paymentMethod.paymentMethodName == "Check or Money Order";
    }

    public orderHasNoPayments = () =>{
        let activePayments = this.cart.orderPayments.filter((payment)=> payment.amount != 0);
        return !activePayments.length;
    }

    public hasProductNameAndNoSkuName = (orderItem) =>{
        return !orderItem.sku.skuName && orderItem.sku.product && orderItem.sku.product.productName
    }

    public cartHasNoItems = () =>{
        return !this.getRequestByAction('getCart').loading && this.hasAccount() && this.cart && this.cart.orderItems && !this.cart.orderItems.length && !this.loading && !this.orderPlaced;
    }

    public hasAccountAndCartItems = () =>{
        return this.hasAccount() && !this.cartHasNoItems();
    }

    public hideStoreSelector = (fulfillmentIndex) =>{
        this.showStoreSelector[fulfillmentIndex] = false;
    }

    public hideEmailSelector = (fulfillmentIndex) =>{
        this.showEmailSelector[fulfillmentIndex] = false;
    }

    public updateOrderItemQuantity = (orderItemID:string,quantity:number=1) =>{
        this.doAction('updateOrderItemQuantity',{'orderItem.orderItemID':orderItemID,'orderItem.quantity':quantity});
    }
    
    public getOrderAttributeValues = (allowedAttributeSets) =>{
        var attributeValues = {};
        var orderAttributeModel = JSON.parse(localStorage.getItem('attributeMetaData'))["Order"];
        for(var attributeSetCode in orderAttributeModel){
            var attributeSet = orderAttributeModel[attributeSetCode];
            if(allowedAttributeSets.indexOf(attributeSetCode) !== -1){
                for(var attributeCode in attributeSet.attributes){
                    let attribute = attributeSet.attributes[attributeCode];

                    attributeValues[attribute.attributeCode] = {
                        attributeCode:attribute.attributeCode,
                        attributeName:attribute.attributeName,
                        attributeValue:this.cart[attribute.attributeCode],
                        inputType:attribute.attributeInputType,
                        requiredFlag:attribute.requiredFlag
                    };
                }
            }
        }
        return attributeValues;
    }

    //Use with bind, assigning 'this' as the temporary order item
    //a.k.a. slatwall.bind(tempOrderItem,slatwall.copyOrderItem,originalOrderItem);
    //gets you tempOrderItem.orderItem == originalOrderItem;
    public copyOrderItem(orderItem){
        this.orderItem = {orderItemID:orderItem.orderItemID,
            quantity:orderItem.quantity};
        return this;
    }

    public binder = (self, fn, ...args)=>{
        return fn.bind(self, ...args);
    }

    /*********************************************************************************/
    /*******************                                    **************************/
    /*******************         DEPRECATED METHODS         **************************/
    /*******************                                    **************************/
    /*********************************************************************************/
     /** DEPRECATED
     */
     public getSelectedShippingIndex = function(index, value){
        for (var i = 0; i <= this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingMethodOptionsIndex].shippingMethodOptions.length; i++){
            if (this.cart.fulfillmentTotal == this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingMethodOptionsIndex].shippingMethodOptions[i].totalCharge){
                return i;
            }
        }
     }
     /** simple validation just to ensure data is present and accounted for.
     */
    public validateNewOrderPayment =  (newOrderPayment)=> {
        var newOrderPaymentErrors = {};
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.streetAddress')){
            newOrderPaymentErrors['streetAddress'] = 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.countrycode')){
            newOrderPaymentErrors['countrycode'] = 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.statecode')){
            if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.locality')){
                newOrderPaymentErrors['statecode'] = 'Required *';
            }
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.city')){
            if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.city')){
                newOrderPaymentErrors['city'] = 'Required *';
            }
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.locality')){
            if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.statecode')){
                newOrderPaymentErrors['locality'] = 'Required *';
            }
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.billingAddress.postalcode')){
            newOrderPaymentErrors['postalCode'] = 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.nameOnCreditCard')){
            newOrderPaymentErrors['nameOnCreditCard']= 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.expirationMonth')){
            newOrderPaymentErrors['streetAddress'] = 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.expirationYear')){
            newOrderPaymentErrors['expirationYear'] = 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.creditCardNumber')){
            newOrderPaymentErrors['creditCardNumber'] = 'Required *';
        }
        if (this.isUndefinedOrEmpty(newOrderPayment, 'newOrderPayment.securityCode')){
            newOrderPaymentErrors['securityCode'] = 'Required *';
        }
        if (Object.keys(newOrderPaymentErrors).length){
            //this.cart.orderPayments.hasErrors = true;
            //this.cart.orderPayments.errors = newOrderPaymentErrors;
        }
    }

    /** Allows an easy way to calling the service addOrderPayment.
    */
    public addOrderPayment = (formdata)=>{
        //reset the form errors.

        //Grab all the data
        var billingAddress  = this.newBillingAddress;
        var expirationMonth = formdata.month;
        var expirationYear  = formdata.year;
        var country         = formdata.country;
        var state           = formdata.state;
        var accountFirst    = this.account.firstName;
        var accountLast     = this.account.lastName;
        var data = {};

        var processObject = this.orderService.newOrder_AddOrderPayment();


        data = {
            'newOrderPayment.billingAddress.addressID':'',
            'newOrderPayment.billingAddress.streetAddress': billingAddress.streetAddress,
            'newOrderPayment.billingAddress.street2Address': billingAddress.street2Address,
            'newOrderPayment.nameOnCreditCard': billingAddress.nameOnCreditCard,
            'newOrderPayment.billingAddress.name': billingAddress.nameOnCreditCard,
            'newOrderPayment.expirationMonth': expirationMonth,
            'newOrderPayment.expirationYear': expirationYear,
            'newOrderPayment.billingAddress.countrycode': country || billingAddress.countrycode,
            'newOrderPayment.billingAddress.city': ''+billingAddress.city,
            'newOrderPayment.billingAddress.statecode': state || billingAddress.statecode,
            'newOrderPayment.billingAddress.locality': billingAddress.locality || '',
            'newOrderPayment.billingAddress.postalcode': billingAddress.postalcode,
            'newOrderPayment.securityCode': billingAddress.cvv,
            'newOrderPayment.creditCardNumber': billingAddress.cardNumber,
            'newOrderPayment.saveShippingAsBilling':(this.saveShippingAsBilling == true),
        };

        //processObject.populate(data);


        //Make sure we have required fields for a newOrderPayment.
        this.validateNewOrderPayment( data );
        if ( this.cart.orderPayments.hasErrors && Object.keys(this.cart.orderPayments.errors).length ){
            return -1;
        }

        //Post the new order payment and set errors as needed.
        this.doAction('addOrderPayment', data, 'post').then((result)=>{
            
            var serverData = result;
            
            if (serverData.cart.hasErrors || angular.isDefined(this.cart.orderPayments[this.cart.orderPayments.length-1]['errors']) && !this.cart.orderPayments[this.cart.orderPayments.length-1]['errors'].hasErrors){
                this.cart.hasErrors = true;
                this.readyToPlaceOrder = true;
                this.edit = '';
            }else{
                this.editPayment = false;
                this.readyToPlaceOrder = true;
                this.edit = '';
            }
        });
    };

    /** Allows an easy way to calling the service addOrderPayment.
    */
    public addGiftCardOrderPayments = (redeemGiftCardToAccount)=>{
        //reset the form errors.
        this.cart.hasErrors=false;
        this.cart.orderPayments.errors = {};
        this.cart.orderPayments.hasErrors = false;

        //Grab all the data
        var giftCards = this.account.giftCards;
        var data = {};

        data = {
            'newOrderPayment.paymentMethod.paymentMethodID':'50d8cd61009931554764385482347f3a',
            'newOrderPayment.redeemGiftCardToAccount':redeemGiftCardToAccount,
        };

        //add the amounts from the gift cards
        for (var card in giftCards){
            if (giftCards[card].applied == true){

                data['newOrderPayment.giftCardNumber'] = giftCards[card].giftCardCode;
                if (giftCards[card].calculatedTotal < this.cart.calculatedTotal){
                    data['newOrderPayment.amount'] = giftCards[card].calculatedBalanceAmount; //will use once we have amount implemented.
                }else{
                    data['newOrderPayment.amount'] = this.cart.calculatedTotal;//this is so it doesn't throw the 100% error
                }
                data['copyFromType'] = "";

                //Post the new order payment and set errors as needed.
                this.$q.all([this.doAction('addOrderPayment', data, 'post')]).then(function(result){
                    var serverData;
                    if (angular.isDefined(result['0'])){
                        serverData = result['0'].data;
                    }
                    if (serverData.cart.hasErrors || angular.isDefined(this.cart.orderPayments[this.cart.orderPayments.length-1]['errors']) && !this.cart.orderPayments[''+(this.cart.orderPayments.length-1)]['errors'].hasErrors){
                        this.cart.hasErrors = true;
                        this.readyToPlaceOrder = true;
                        this.edit = '';
                    }else{

                    }
                });
            }
        }

    };

    /** Allows an easy way to calling the service addOrderPayment.
    */
    public addOrderPaymentAndPlaceOrder = (formdata)=>{
        //reset the form errors.
        this.orderPlaced = false;
        //Grab all the data
        var billingAddress  = this.newBillingAddress;
        var expirationMonth = formdata.month;
        var expirationYear  = formdata.year;
        var country         = formdata.country;
        var state           = formdata.state;
        var accountFirst    = this.account.firstName;
        var accountLast     = this.account.lastName;
        var data = {};

        data = {
            'orderid':this.cart.orderID,
            'newOrderPayment.billingAddress.streetAddress': billingAddress.streetAddress,
            'newOrderPayment.billingAddress.street2Address': billingAddress.street2Address,
            'newOrderPayment.nameOnCreditCard': billingAddress.nameOnCard || accountFirst + ' ' +accountLast,
            'newOrderPayment.expirationMonth': expirationMonth,
            'newOrderPayment.expirationYear': expirationYear,
            'newOrderPayment.billingAddress.countrycode': country || billingAddress.countrycode,
            'newOrderPayment.billingAddress.city': '' + billingAddress.city,
            'newOrderPayment.billingAddress.statecode': state || billingAddress.statecode,
            'newOrderPayment.billingAddress.locality': billingAddress.locality || '',
            'newOrderPayment.billingAddress.postalcode': billingAddress.postalcode,
            'newOrderPayment.securityCode': billingAddress.cvv,
            'newOrderPayment.creditCardNumber': billingAddress.cardNumber,
            'newOrderPayment.saveShippingAsBilling':(this.saveShippingAsBilling == true),
        };

        //Make sure we have required fields for a newOrderPayment.
        //this.validateNewOrderPayment( data );
        if ( this.cart.orderPayments.hasErrors && Object.keys(this.cart.orderPayments.errors).length ){

            return -1;
        }

        //Post the new order payment and set errors as needed.
        this.$q.all([this.doAction('addOrderPayment,placeOrder', data, 'post')]).then(function(result){
            var serverData
            if (angular.isDefined(result['0'])){
                serverData = result['0'].data;
            }else{

            }//|| angular.isDefined(serverData.cart.orderPayments[serverData.cart.orderPayments.length-1]['errors']) && slatwall.cart.orderPayments[''+slatwall.cart.orderPayments.length-1]['errors'].hasErrors
            if (serverData.cart.hasErrors || (angular.isDefined(serverData.failureActions) && serverData.failureActions.length && serverData.failureActions[0] == "public:cart.addOrderPayment")){
                if (serverData.failureActions.length){
                    for (var action in serverData.failureActions){
                        //
                    }
                }
                this.edit = '';
                return true;
            } else if (serverData.successfulActions.length) {
                //
                this.cart.hasErrors = false;
                this.editPayment = false;
                this.edit = '';
                for (var action in serverData.successfulActions){
                    //
                    if (serverData.successfulActions[action].indexOf("placeOrder") != -1){
                        //if there are no errors then redirect.
                        this.orderPlaced = true;
                        this.redirectExact('/order-confirmation/');
                    }
                }
            }else{
                this.edit = '';
            }
        });

    };

    //Applies a giftcard from the user account onto the payment.
    public applyGiftCard = (giftCardCode)=>{
        this.finding = true;

        //find the code already on the account.
        var found = false;
        for (var giftCard in this.account.giftCards){
            if (this.account.giftCards[giftCard].balanceAmount == 0){
                this.account.giftCards[giftCard]['error'] = "The balance is $0.00 for this card.";
                found = false;
            }
            if (this.account.giftCards[giftCard].giftCardCode == giftCardCode){
                this.account.giftCards[giftCard].applied = true;
                found = true;
            }
        }
        if (found){
            this.finding = false;
            this.addGiftCardOrderPayments(false);
        }else{
            this.finding = false;
            this.addGiftCardOrderPayments(true);
        }

    };

    //returns the amount total of giftcards added to this account.
    public getAppliedGiftCardTotals = ()=>{
        //
        var total = 0;
        for (var payment in this.cart.orderPayments){
            if (this.cart.orderPayments[payment].giftCardNumber != ""){
                total = total + parseInt(this.cart.orderPayments[payment]['amount']);
            }
        }
        return total;
    };

}
export {PublicService};
