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
    public loading:boolean;

    public http:ng.IHttpService;
    public confirmationUrl:string;
    public header:any;
    public window:any;
    public finding:boolean;
    public rates:any;
    private baseActionPath = "";
    public months = [{name:'01 - JAN',value:1},{name:'02 - FEB',value:2},{name:'03 - MAR',value:3},{name:'04 - APR',value:4},{name:'05 - MAY',value:5},{name:'06 - JUN',value:6},{name:'07 - JUL',value:7},{name:'08 - AUG',value:8},{name:'09 - SEP',value:9},{name:'10 - OCT',value:10},{name:'11 - NOV',value:11},{name:'12 - DEC',value:12}];
    public years = [];
    public shippingAddress = "";
    public billingAddress = "";
    public paymentMethods;
    public orderPlaced:boolean;
    public saveShippingAsBilling:boolean;
    public readyToPlaceOrder:boolean;
    public edit:String;
    public editPayment:boolean;
    public imagePath:{[key:string]:any}={};
    
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
        public appConfig
    ) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.accountService = accountService;
        this.requestService = requestService;
        this.appConfig = appConfig;
        this.baseActionPath = this.appConfig.baseURL+"/index.cfm/api/scope/"; //default path
        this.confirmationUrl = "/order-confirmation";
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
            this.years.push(start + i);
        }
    }
    /** accessors for account */
    public getAccount=():any =>  {
        let urlBase = this.baseActionPath+'getAccount/';
        return this.getData(urlBase, "account", "");
    }
    /** accessors for cart */
    public getCart=():any =>  {
        let urlBase = this.baseActionPath+'getCart/';
        return this.getData(urlBase, "cart", "");
    }
    /** accessors for countries */
    public getCountries=():any =>  {
        let urlBase = this.baseActionPath+'getCountries/';
        return this.getData(urlBase, "countries", "");
    }

    /** accessors for states */
    public getStates=(countryCode:string):any =>  {
       if (!angular.isDefined(countryCode)) countryCode = "US";
       let urlBase = this.baseActionPath+'getStateCodeOptionsByCountryCode/';
       return this.getData(urlBase, "states", "?countryCode="+countryCode);
    }

    /** accessors for states */
    public getAddressOptions=(countryCode:string):any =>  {
       if (!angular.isDefined(countryCode)) countryCode = "US";
       let urlBase = this.baseActionPath+'getAddressOptionsByCountryCode/';
       return this.getData(urlBase, "addressOptions", "&countryCode="+countryCode);
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

            if(setter == 'cart'||setter=='account'){
                //cart and account return cart and account info flat
                this[setter].populate(result);

            }else{
                //other functions reutrn cart,account and then data
                this[setter]=(result);
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

    /** this is the generic method used to call all server side actions.
    *  @param action {string} the name of the action (method) to call in the public service.
    *  @param data   {object} the params as key value pairs to pass in the post request.
    *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
    */
    public doAction=(action:string, data?:any, method?:any) => {

        if (!action) {throw "Action is required exception";}

        var urlBase = "";
		
        //check if the caller is defining a path to hit, otherwise use the public scope.
        if (action.indexOf(":") !== -1){
            urlBase = action; //any path
        }else{
            urlBase = "/index.cfm/api/scope/" + action;//public path
        }

        if(data){
            method = "post";
            data.returnJsonObjects = "cart,account";
        }else{
            urlBase += "&returnJsonObject=cart,account";
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

            var url = urlBase + "&returnJsonObject=cart,account";

            let request = this.requestService.newPublicRequest(url);
            request.promise.then((result:any)=>{
                this.processAction(result,request);
            }).catch((reason)=>{

            });

            this.requests[request.getAction()]=request;
            return request.promise;
        }

    }

    private processAction = (response,request:PublicRequest)=>{
        /** update the account and the cart */

        this.account.populate(response.account);
        this.account.request = request;
        this.cart.populate(response.cart);
        this.cart.request = request;

        //if the action that was called was successful, then success is true.
        if (request.hasSuccessfulAction()){
            for (var action in request.successfulActions){
                if (request.successfulActions[action].indexOf('public:cart.placeOrder') !== -1){
                    this.$window.location.href = this.confirmationUrl;
                }
            }
        }
        if (!request.hasSuccessfulAction()){
            //this.hasErrors = true;
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
        let urlString = "/?slataction=admin:ajax.getActivePaymentMethods";
        let request = this.requestService.newPublicRequest(urlString)
        .then((result:any)=>{
            if (angular.isDefined(result.data.paymentMethods)){
                this.paymentMethods = result.data.paymentMethods;
            }
        });
        this.requests[request.getAction()]=request;
    };

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

    public hasPaymentMethod = (paymentMethodName)=>{
        for (var method in this.paymentMethods){
            if (this.paymentMethods[method].paymentMethodName == paymentMethodName && this.paymentMethods[method].activeFlag == "Yes "){
                return true;
            }
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

    /** Redirects to the order confirmation page if the order placed successfully
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
     public isMobile = function(){
           if(this.$window.innerWidth <= 800 && this.$window.innerHeight <= 600) {
             return true;
           }
           return false;
     };

     /** returns true if the shipping method is the selected shipping method
     */
     public isSelectedShippingMethod = function(index, value){
        if (this.cart.fulfillmentTotal &&
              value == this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingMethodOptionsIndex].shippingMethod.shippingMethodID ||
              this.cart.orderFulfillments[this.cart.orderFulfillmentWithShippingMethodOptionsIndex].shippingMethodOptions.length == 1){
                return true;
              }
              return false;
     }

     /** returns the index of the selected shipping method.
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
        // this.cart.hasErrors=false;
        // this.cart.orderPayments.errors = {};
        // this.cart.orderPayments.hasErrors = false;

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

        // processObject.newBillingAddress = this.newBillingAddress;
        // processObject.newBillingAddress.expirationMonth = formdata.month;
        // processObject.newBillingAddress.expirationYear = formdata.year;
        // processObject.newBillingAddress.billingAddress.country = formdata.country || processObject.data.newOrderPayment.billingAddress.country;
        // processObject.newBillingAddress.billingAddress.statecode = formdata.state || processObject.data.newOrderPayment.billingAddress.statecode;
        // processObject.newBillingAddress.saveShippingAsBilling=(this.saveShippingAsBilling == true);


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

        processObject.populate(data);


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

    /** returns the index of the last selected shipping method. This is used to get rid of the delay.
    */
    public selectShippingMethod = function(index){
        for (var method in this.lastSelectedShippingMethod){
            if (method != index){
                this.lastSelectedShippingMethod[method] = 'false';
            }
        }
        this.lastSelectedShippingMethod[index] = 'true';
    }

    /** returns true if this was the last selected method
    */
    public isLastSelectedShippingMethod = function(index){
        if (this.lastSelectedShippingMethod[index] === 'true'){
            return true;
        }
        return false;
    }

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

    //gets the calcuated total minus the applied gift cards.
    public getTotalMinusGiftCards = ()=>{
        var total = this.getAppliedGiftCardTotals();
        return this.cart.calculatedTotal - total;
    };

    //get estimated shipping rates given a weight, from to zips
    public getEstimatedRates = (zipcode)=>{

        var weight = 0;
        for (var item in this.cart.orderFulfillments){

            weight += this.cart.orderFulfillments[item].totalShippingWeight;
        }
        var shipFromAddress = {
            "postalcode": ""
        };
        var shipToAddress = {
            "postalcode": zipcode
        };
        var totalWeight = weight;

        //get the rates.
        let urlString = "?slataction=admin:ajax.getEstimatedShippingRates&shipFromAddress="+ JSON.stringify(shipFromAddress)
        +"&shipToAddress="+ JSON.stringify(shipToAddress) +"&totalWeight=" + JSON.stringify(weight);

        let request = this.requestService.newPublicRequest(urlString)
        .then((result:any)=>{

            this.rates = result.data;
        });
    }
    
    /** Returns the state from the list of states by stateCode */
    public getStateByStateCode = (stateCode) => {
     	for (var state in this.states.stateCodeOptions){
     		if (this.states.stateCodeOptions[state].value == stateCode){
     			return this.states.stateCodeOptions[state];
     		}
     	}
    }
     
    /** Returns the state from the list of states by stateCode */
    public resetRequests = (request) => {
     	delete this.requests[request];
    }
    
    /** Returns true if the addresses match. */
    public addressesMatch = (address1, address2) => {
    	if (angular.isDefined(address1) && angular.isDefined(address2)){
        	if ( (address1.streetAddress == address2.streetAddress && 
	            address1.street2Address == address2.street2Address &&
	            address1.city == address2.city &&
	            address1.postalcode == address2.postalcode &&
	            address1.countrycode == address2.countrycode)){
            	return true;
            }
        }
        return false;
    }
    
    /** Should be pushed down into core. Returns the profile image by name. */
   	public getResizedImageByProfileName = (profileName, skuIDList) => {
   		this.imagePath = {};
   		
   		if (profileName == undefined){
   			profileName = "medium";
   		}
   		
   		this.$http.get("/index.cfm/api/scope/?context=getResizedImageByProfileName&profileName="+profileName+"&skuIds="+skuIDList).success((result:any)=>{
   		 	
   		 	this.imagePath[skuIDList] = "";
   		 	
   		 	result = <any>angular.fromJson(result);
   		 	if (angular.isDefined(result.resizedImagePaths) && angular.isDefined(result.resizedImagePaths.resizedImagePaths) && result.resizedImagePaths.resizedImagePaths[0] != undefined){
   		 		
   		 		this.imagePath[skuIDList] = result.resizedImagePaths.resizedImagePaths[0];
   		 		this.loading = false;
   		 		return this.imagePath[skuIDList];
   		 		
   		 	}else{
   		 		return "";
   		 	}
   		 	
   		}); 
   	}

	
    /**
     *  Returns true when the fulfillment body should be showing
     *  Show if we don't need an account but do need a fulfillment
     *
     */
    public showFulfillmentTabBody = ()=> {
        if ((this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID &&
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
        if ((this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
            (this.cart.orderRequirementsList.indexOf('payment') != -1) && this.edit == '' ||
            (this.cart.orderRequirementsList.indexOf('payment') == -1) &&
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
        if ((this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID &&
            (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
            (this.cart.orderRequirementsList.indexOf('payment') == -1) &&
            (this.edit == '') || (this.edit == 'review')) {
            return true;
        }
        return false;
    };
    
    /** Returns true if the fulfillment tab should be active */
    public fulfillmentTabIsActive = ()=> {
        if ((this.edit == 'fulfillment') ||
            (this.edit == '' && ((this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID) &&
                (this.cart.orderRequirementsList.indexOf('fulfillment') != -1))) {
            return true;
        }
        return false;
    };
    
    /** Returns true if the payment tab should be active */
    public paymentTabIsActive = ()=> {
        if ((this.edit == 'payment') ||
            (this.edit == '' &&
                (this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID &&
                (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                (this.cart.orderRequirementsList.indexOf('payment') != -1))) {
            return true;
        }
        return false;
    };
    
    /** Returns true if the review tab should be active */
    public reviewTabIsActive =  ()=> {
        if ((this.edit == 'review' ||
            (this.edit == '' &&
                (this.cart.orderRequirementsList.indexOf('account') == -1) && this.account.accountID &&
                (this.cart.orderRequirementsList.indexOf('fulfillment') == -1) &&
                (this.cart.orderRequirementsList.indexOf('payment') == -1)))) {
            return true;
        }
        return false;
    };

	
	
}
export {PublicService};
