/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Cart} from "../model/entity/cart";
import {Account} from "../model/entity/account";
import {PublicRequest} from "../model/transient/publicrequest";

class PublicService {

    public ajaxRequestParam:string = "?ajaxRequest=1";
    public account:Account;
    public cart:Cart;
    public states:any;
    public countries:any;
    public addressOptions:any;
    public requests:{ [action: string]: PublicRequest; }={};

    public http:ng.IHttpService;
    public confirmationUrl:string;
    public loading:boolean = false;
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
        public cartService
    ) {
        this.cartService = cartService;
        this.accountService = accountService;
        this.requestService = requestService;
        this.baseActionPath = "/index.cfm/api/scope/"; //default path
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
    }

    public hasErrors = ()=>{
        return this.errors.length;
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

    /** grab the valid expiration years for credit cards  */
    public getExpirationYears=():any =>{

        var baseDate = new Date();
        var today = baseDate.getFullYear();
        var start = today;
        for (var i = 0; i<= 5; i++){
            this.years.push(start + i);
        }
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
        this.loading = true;
        let urlBase = url + this.ajaxRequestParam + param;
        let request = this.requestService.newPublicRequest(urlBase);
        request.promise.then((result:any)=>{
            //don't need account and cart for anything other than account and cart calls.
            if (setter.indexOf('account') == -1 || setter.indexOf('cart') == -1){
                if (result['account']){delete result['account'];}
                if (result['cart']){delete result['cart'];}
            }
            if(setter == 'cart'||setter=='account'){

                this[setter].populate(result)
            }else{
                this[setter] = result;
            }

        }).catch((reason)=>{


        });
        this.requests[setter]=request;
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

        //check if the caller is defining a path to hit, otherwise use the public scope.
        if (action.indexOf("/") !== -1){
            this.baseActionPath = action; //any path
        }else{
            this.baseActionPath = "/index.cfm/api/scope/" + action;//public path
        }

        let urlBase = this.baseActionPath + this.ajaxRequestParam;

        if(data){
            data.returnJsonObjects = "cart,account";
        }else{
            urlBase += "&returnJsonObject=cart,account";
        }

        if (method == "post"){
             data.returnJsonObjects = "cart,account";
            //post
            let request = this.requestService.newPublicRequest(urlBase,data,method)
            request.promise.then((result:any)=>{

                /** update the account and the cart */
                this.account.populate(result.data.account);
                this.cart.populate(result.data.cart);
                //if the action that was called was successful, then success is true.
                if (request.isSuccess()){
                    for (var action in request.successfulActions){
                        if (request.successfulActions[action].indexOf('public:cart.placeOrder') !== -1){
                            this.$window.location.href = this.confirmationUrl;
                        }
                    }
                }
                if (!request.isSuccess()){
                    //this.hasErrors = true;
                }

                request.promise(result);
            }).catch((response)=>{

                request.promise(response);
            });
            this.requests[action] = request;
            return request.promise;
        }else{
            //get
            var url = urlBase + "&returnJsonObject=cart,account";

            let request = this.requestService.newPublicRequest(url);
            request.promise.then((result:any)=>{

            }).catch((reason)=>{

            });
            return request.promise;
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
    public orderRequiresFulfillment = ()=> {

        this.cart.orderRequiresFulfillment();
    };

    /**
     *  Returns true if the order requires a account
     *  Either because the user is not logged in, or because they don't have one.
     *
     */
    public orderRequiresAccount = ()=> {
        this.cart.orderRequiresAccount();
    };

    /** Returns true if the payment tab should be active */
    public hasShippingAddressAndMethod = () => {
        this.cart.hasShippingAddressAndMethod();
    };

    /**
     * Returns true if the user has an account and is logged in.
     */
    public hasAccount = ()=>{
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

        data = {
            'newOrderPayment.billingAddress.streetAddress': billingAddress.streetAddress,
            'newOrderPayment.billingAddress.street2Address': billingAddress.street2Address,
            'newOrderPayment.nameOnCreditCard': billingAddress.nameOnCreditCard,
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

        //Make sure we have required fields for a newOrderPayment.
        this.validateNewOrderPayment( data );
        if ( this.cart.orderPayments.hasErrors && Object.keys(this.cart.orderPayments.errors).length ){
            return -1;
        }

        //Post the new order payment and set errors as needed.
        this.$q.all([this.doAction('addOrderPayment', data, 'post')]).then(function(result){
            var serverData
            if (angular.isDefined(result['0'])){
                serverData = result['0'].data;
            }

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
                    var serverData
                    if (angular.isDefined(result['0'])){
                        serverData = result['0'].data;
                    }
                    if (serverData.cart.hasErrors || angular.isDefined(this.cart.orderPayments[this.cart.orderPayments.length-1]['errors']) && !this.cart.orderPayments[''+this.cart.orderPayments.length-1]['errors'].hasErrors){
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

    /** returns true if the loader should be on for that item.
    */
    public isLoading = function isLoading(section){
        if (angular.isUndefined(this.loaders)){
            this.loaders = [];
            this.loaders[section] = false;
        }
        if (this.loaders[section] == true){
            return true;
        }
        return false;
    }

    /** adds a loader to the loader list
    */
    //public addLoader = function(section){

//        if (angular.isUndefined(this.loaders)){
//            this.loaders = [];
//            this.loaders[section] = "";
//        }
//        var unloadLoader = this.$scope.$watch('this.loading', function(oldState, newState){
//            if (newState != undefined && newState == true){
//                this.loaders[section] = true;
//            }else{
//                this.loaders[section] = false;
//                unloadLoader();
//            }
//        });
    //}

    /** Allows an easy way to calling the service addOrderPayment.
    */
    public addOrderPaymentAndPlaceOrder = (formdata)=>{
        //reset the form errors.
        this.cart.hasErrors=false;
        this.cart.orderPayments.errors = {};
        this.cart.orderPayments.hasErrors = false;
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
        this.validateNewOrderPayment( data );
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
                        //console.log("Failure Action:", serverData.failureActions[action]);
                    }
                }
                this.edit = '';
                return true;
            } else if (serverData.successfulActions.length) {
                //console.log("Checking Successful Actions: ");
                this.cart.hasErrors = false;
                this.editPayment = false;
                this.edit = '';
                for (var action in serverData.successfulActions){
                    //console.log("Checking Action: ", serverData.successfulActions[action]);
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
        //console.log("Finding totals.");
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

}
export {PublicService};

