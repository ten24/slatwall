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
    public errors:{[key:string]:any}={};
    public newBillingAddress:any;
    public newCardInfo:any;
    public loading:boolean;
    public accountDataPromise:any;
    public addressOptionData:any;
    public cartDataPromise:any;
    public countryDataPromise:any;
    public stateDataPromise:any;
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
    public paymentMethods:any;
    public orderPlaced:boolean;
    public useShippingAsBilling:boolean;
    public saveShippingAsBilling:boolean;
    public saveCardInfo:boolean;
    public creditCardPayment:any;
    public edit:String;
    public editPayment:boolean;
    public showCreateAccount:boolean;
    public showStoreSelector = [];
    public showEmailSelector = [];
    public lastRemovedPromoCode;
    public lastRemovedGiftCard;
    public imagePath:{[key:string]:any}={};
    public successfulActions = [];
    public hibachiConfig:any;

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
        public cartService,
        public orderService,
        public observerService,
        public appConfig,
        public $timeout
    ) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.accountService = accountService;
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
       if (!angular.isDefined(countryCode)) countryCode = "US";

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
        console.log(request.getAction());
        this.requests[request.getAction()]=request;
        return request.promise;
    }

    /** sets the current shipping address */
    public setShippingAddress=(shippingAddress) => {
        this.shippingAddress = shippingAddress;
    }

    /** sets the current billing address */
    public selectBillingAddress=(key) => {
        if(this.creditCardPayment &&
            this.creditCardPayment.forms['addOrderPayment']){
            let address = this.account.accountAddresses[key].address
            for(let property in address){
                if(this.creditCardPayment.forms['addOrderPayment']['newOrderPayment.billingAddress.'+property] != undefined){
                    this.creditCardPayment.forms['addOrderPayment']['newOrderPayment.billingAddress.'+property].$setViewValue(address[property]);
                }
            }
            this.creditCardPayment.newOrderPayment.billingAddress = address;
        }
    }

    /** this is the generic method used to call all server side actions.
    *  @param action {string} the name of the action (method) to call in the public service.
    *  @param data   {object} the params as key value pairs to pass in the post request.
    *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
    */
    public doAction=(action:string, data?:any, method?:any) => {
        //Prevent sending the same request multiple times in parallel
        if(this.getRequestByAction(action) && this.loadingThisRequest(action, data, false)) return this.$q.when();

        if (!action) {throw "Action is required exception";}

        var urlBase = hibachiConfig.baseURL;

        //check if the caller is defining a path to hit, otherwise use the public scope.
        if (action.indexOf(":") !== -1){
            urlBase = urlBase + action; //any path
        }else{
            urlBase = urlBase + "index.cfm/api/scope/" + action;//public path
        }
        
        if(data){
            method = "post";
            data.returnJsonObjects = "cart,account";
        }else{
            urlBase += (urlBase.indexOf('?') == -1) ? '?' : '&';
            urlBase += "returnJsonObject=cart,account";
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
        this.uploadingFile = true;
        let url = hibachiConfig.baseURL + action;

        let formData = new FormData();

        formData.append("fileName", data.fileName);
        formData.append("uploadFile", data.uploadFile);

        var xhr = new XMLHttpRequest();
        xhr.open('POST', url, true);

        xhr.onload = (result)=>{
            var response = JSON.parse(xhr.response);
            if (xhr.status === 200) {
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
        //if the action that was called was successful, then success is true.
        if (request.hasSuccessfulAction()){
            this.successfulActions = [];
            for (var action in request.successfulActions){
                if (request.successfulActions[action].indexOf('public:cart.placeOrder') !== -1){
                    this.$window.location.href = this.confirmationUrl;
                }else if (request.successfulActions[action].indexOf('public:cart.finalizeCart') !== -1){
                    this.$window.location.href = this.checkoutUrl;
                }else if(request.successfulActions[action].indexOf('public:account.logout') !== -1){
                    this.account = this.$hibachi.newAccount();
                }
                this.successfulActions.push(request.successfulActions[action].split('.')[1]);
            }
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

    public logThis = (item)=>{
        console.log('LOGGING THIS: ',item);
    }

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
            this.cart.orderFulfillments[fulfillmentIndex].data.shippingAddress
        );
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
        this.$location.url(url);
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
         return (this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod && 
             this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod.shippingMethodID == option.value) || 
            (this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethodOptions.length == 1);
     }

     /** Select a shipping method - temporarily changes the selected method on the front end while awaiting official change from server
     */
     public selectShippingMethod = (option, fulfillmentIndex) =>{
         let data = {
             'shippingMethodID': option.value,
             'fulfillmentID':this.cart.orderFulfillments[fulfillmentIndex].orderFulfillmentID
         };
         this.doAction('addShippingMethodUsingShippingMethodID', data);
         if(!this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod){
             this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod = {};
         }
         this.cart.orderFulfillments[fulfillmentIndex].data.shippingMethod.shippingMethodID = option.value;
     }

     /** Removes promotional code from order*/
     public removePromoCode = (code)=>{
         this.doAction('removePromotionCode', {promotionCode:code});
     }

    public orderPaymentKeyCheck = (event) =>{
        if(event.event.keyCode == 13 ){
            event.swForm.clearErrors();
            this.setCreditCardPaymentInfo().then((result)=>{
                event.swForm.parseErrors(result.errors);
            });
        }
    }

    /** Prepare swAddressForm billing address / card info to be passed to addOrderPayment */
    public setCreditCardPaymentInfo = () => {
        let billingAddress;
        
        //if selected, pass shipping address as billing address
        if(this.useShippingAsBilling){
            billingAddress = this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingTypeIndex].data.shippingAddress;
        
        //If account address selected, use that
        }else if(this.billingAddressEditFormIndex == undefined){
            billingAddress = this.selectedBillingAddress;
        
        //If creating new address, get from form
        }else if(this.billingAddressEditFormIndex == 'new'){
            billingAddress = this.billingAddress.getData();
        
        //If editing existing account address, get from form
        }else{
            billingAddress = this.editingBillingAddress.getData();
        }

        //Add card info
        for(let key in this.newCardInfo){
            billingAddress[key] = this.newCardInfo[key];
        }
        this.newBillingAddress = billingAddress;
        return this.addCreditCardPayment();
    }

    /** Add a credit card order payment.*/
    public addCreditCardPayment = ()=>{

        //Grab all the data
        var billingAddress  = this.newBillingAddress;

        var processObject = this.orderService.newOrder_AddOrderPayment();
        var data = {
            'newOrderPayment.billingAddress.addressID':'',
            'newOrderPayment.billingAddress.streetAddress': billingAddress.streetAddress,
            'newOrderPayment.billingAddress.street2Address': billingAddress.street2Address,
            'newOrderPayment.nameOnCreditCard': billingAddress.nameOnCreditCard,
            'newOrderPayment.billingAddress.name': billingAddress.nameOnCreditCard,
            'newOrderPayment.expirationMonth': billingAddress.selectedMonth,
            'newOrderPayment.expirationYear': billingAddress.selectedYear,
            'newOrderPayment.billingAddress.countrycode': billingAddress.countrycode,
            'newOrderPayment.billingAddress.city': ''+billingAddress.city,
            'newOrderPayment.billingAddress.statecode': billingAddress.statecode,
            'newOrderPayment.billingAddress.locality': billingAddress.locality || '',
            'newOrderPayment.billingAddress.postalCode': billingAddress.postalCode,
            'newOrderPayment.securityCode': billingAddress.cvv,
            'newOrderPayment.creditCardNumber': billingAddress.cardNumber,
            'newOrderPayment.requireBillingAddress':true,
            'newOrderPayment.creditCardLastFour': billingAddress.cardNumber ? billingAddress.cardNumber.slice(-4) : '',
            'accountPaymentMethodID': billingAddress.accountPaymentMetgehodID,
            'copyFromType': billingAddress.copyFromType,
            'saveAccountPaymentMethodFlag': this.saveCardInfo
        };

        //Post the new order payment and set errors as needed.
        return this.doAction('addOrderPayment', data, 'post');
    };

    /** Removes a gift card from the order and sets variable tracking which gift card is being removed.*/
    public removeGiftCard = (payment) =>{
        this.doAction('removeOrderPayment', {orderPaymentID:payment.orderPaymentID});
    }

    /** Format saved payment method info for display in list*/
    public formatPaymentMethod = (paymentMethod) =>{
        return (paymentMethod.accountPaymentMethodName || paymentMethod.nameOnCreditCard) + ' - ' + paymentMethod.creditCardType + ' *' + paymentMethod.creditCardLastFour + ' exp. ' + ('0' + paymentMethod.expirationMonth).slice(-2) + '/' + paymentMethod.expirationYear.toString().slice(-2)
    }

    public getResizedImageByProfileName = (profileName, skuID)=>{
       this.loading = true;
       
       if (profileName == undefined){
           profileName = "medium";
       }
       
       this.doAction('getResizedImageByProfileName',{profileName:profileName,skuIds:skuID}).then((result:any)=>{
            if(!angular.isDefined(this.imagePath)){
                this.imagePath = {};
            }
            if (result.resizedImagePaths && result.resizedImagePaths[skuID]){
                this.imagePath[skuID] = result.resizedImagePaths[skuID]
                return this.imagePath[skuID];
                
            }
            
         });
        
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
     
    /** Removes request from list */
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
                address1.statecode == address2.statecode &&
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
            (this.cart.orderRequirementsList.indexOf('fulfillment') != -1) ||
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
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
        if ((this.cart.orderRequirementsList.indexOf('account') == -1) &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
            (this.cart.orderRequirementsList.indexOf('payment') != -1) && !this.edit ||
            (this.edit == 'payment')) {
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
            (!this.edit) || (this.edit == 'review')) {
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
    }

    /** Returns errors from placeOrder request*/
    public placeOrderError = () =>{
        if(this.cart.hasErrors && this.cart.errors.runPlaceOrderTransaction){
            return this.cart.errors.runPlaceOrderTransaction;
        }
    }

    /** Returns errors from addOrderPayment request. */
    public addOrderPaymentError = () =>{
        return this.cart.errors.addOrderPayment || this.errors && this.errors['ADDORDERPAYMENT'];
    }

    /** Returns errors from addBillingAddress request. */
    public billingAddressError = () =>{
        if(this.cart.hasErrors && this.cart.errors.addBillingAddress){
            return this.cart.errors.addBillingAddress;
        }
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
        this.accountAddressEditFormIndex[fulfillmentIndex] = key;
        this.editingAccountAddress = this.getAddressEntity(this.account.accountAddresses[key].address);
    }

    public editBillingAddress = (key) =>{
        this.billingAddressEditFormIndex = key;
        this.selectedBillingAddress = null
        this.billingAddress = this.getAddressEntity(this.account.accountAddresses[key].address);
    }

    public clearShippingAddressErrors = ()=>{
        this.shippingAddressErrors = undefined;
    }

    /**Hides shipping address form, clears shipping address errors*/
    public hideAccountAddressForm = (fulfillmentIndex)=>{
        this.accountAddressEditFormIndex[fulfillmentIndex] = undefined;
    }

    public hideBillingAddressForm = ()=>{
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
           this.cart.orderFulfillments[fulfillmentIndex].shippingAddress){
            return this.addressesMatch(this.account.accountAddresses[key].address, this.cart.orderFulfillments[fulfillmentIndex].shippingAddress);
        }        
        return false;
    }

    public accountAddressIsSelectedBillingAddress = (key) =>{
        if(this.account && 
           this.account.accountAddresses &&
           this.creditCardPayment &&
           this.creditCardPayment.newOrderPayment &&
           this.creditCardPayment.newOrderPayment.billingAddress){
            return this.addressesMatch(this.account.accountAddresses[key].address, this.creditCardPayment.newOrderPayment.billingAddress);
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
        return this.hasSuccessfulAction('addShippingAddressUsingAccountAddress,updateAddress,addShippingAddress');
    }

    public shippingMethodUpdateSuccess = () =>{
        return this.hasSuccessfulAction('addShippingMethodUsingShippingMethodID');
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

    public incrementItemQuantity = (orderItem, amount=1) =>{
        orderItem.quantity += amount;
        if(orderItem.quantity < 0){
            orderItem.quantity = 0;
        }
        this.updateOrderItemQuantity(orderItem);
    }

    public updateOrderItemQuantity = (event) =>{
        event.swForm.submit();
    }

    public getOrderAttributeValues = (allowedAttributeSets) =>{
        var attributeValues = {};
        var orderAttributeModel = JSON.parse(localStorage.attributeMetaData)["Order"];
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

}
export {PublicService};

