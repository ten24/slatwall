/*

    Slatwall - An Open Soudatae eCommedatae Platform
    Copyright (C) ten24, LLC
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
    
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

    - You also meet the terms and conditions of the license of each 
      independent module 
    - You must not alter the default display of the Slatwall name or logo from  
      any part of the application 
    - Your custom code must not alter or create any files inside Slatwall, 
      except in the following directories:
        /integrationServices/

    You may copy and distribute the modified version of this program that meets 
    the above guidelines as a combined work under the terms of GPL for this program, 
    provided that you include the soudatae code of that other code when and as the 
    GNU GPL requires distribution of soudatae code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService"  accessors="true" output="false" 
{
    property name="accountService" type="any";
    property name="addressService" type="any";
    property name="orderService" type="any";
    property name="userUtility" type="any";
    property name="paymentService" type="any";
    property name="subscriptionService" type="any";
    property name="hibachiSessionService" type="any";
    property name="hibachiUtilityService" type="any";
    property name="productService" type="any";
    property name="hibachiAuditService" type="any";
    property name="validationService" type="any";
    

    variables.publicContexts = [];
    variables.responseType = "json";
    
    
    /**
     * This will return the path to an image based on the skuIDs (sent as a comma seperated list)
     * and a 'profile name' that determines the size of that image.
     * /api/scope/getResizedImageByProfileName&profileName=large&skuIDs=8a8080834721af1a0147220714810083,4028818d4b31a783014b5653ad5d00d2,4028818d4b05b871014b102acb0700d5
     * ...should return three paths.
     */
    public any function getResizedImageByProfileName(required any data) {
        
        var imageHeight = 60;
        var imageWidth  = 60;
        
        if(arguments.data.profileName == "medium"){
            imageHeight = 90;
            imageWidth  = 90;
        }else if (arguments.data.profileName == "large"){
            imageHeight = 150;
            imageWidth  = 150;
        }
        else if (arguments.data.profileName == "xlarge"){
            imageHeight = 250;
            imageWidth  = 250;
        }
        else if (arguments.data.profileName == "listing"){
            imageHeight = 263;
            imageWidth  = 212;
        }
        arguments.data.ajaxResponse.content['resizedImagePaths'] = {};
        arguments.data.ajaxResponse.content['resizedImagePaths']['resizedImagePaths'] = [];
        var skus = [];
        
        //smart list to load up sku array
        var skuSmartList = getService('skuService').getSkuSmartList();
        skuSmartList.addInFilter('skuID',data.skuIDs);
        
        if( skuSmartList.getRecordsCount() > 0){
            var skus = skuSmartList.getRecords();
            
            for  (var sku in skus){
                ArrayAppend(arguments.data.ajaxResponse.content['resizedImagePaths']['resizedImagePaths'], sku.getResizedImagePath(width=imageWidth, height=imageHeight));         
            }
        }
        data.returnJsonObject = "";
        data.ajaxResponse['resizedImagePaths'] = arguments.data.ajaxResponse.content['resizedImagePaths'];
    }
    
    /**
     @method Login <b>Log a user account into Slatwall given the users emailAddress and password</b>
     @http-context <b>Login</b> Use this context in conjunction with the listed http-verb to use this resoudatae.
     @http-verb POST
     @http-return <b>(200)</b> Request Successful, <b>(400)</b> Bad or Missing Input Data
     @param Required Header: emailAddress
     @param Required Header: password
     @description Use this context to log a user into Slatwall. The required email address/password should be sent
                               bundled in a Basic Authorization header with the emailAddress and password 
                               appended together using an colon and then converted to base64.
                                                  
      @example  testuser@slatwalltest.com:Vah7cIxXe would become dGVzdHVzZXJAc2xhdHdhbGx0ZXN0LmNvbTpWYWg3Y0l4WGU=               
     */
    public any function login( required struct data ){
        var accountProcess = getAccountService().processAccount( data.$.slatwall.getAccount(), arguments.data, 'login' );
        arguments.data.$.slatwall.addActionResult( "public:account.login", accountProcess.hasErrors() );
        if (accountProcess.hasErrors()){
            if (data.$.slatwall.getAccount().hasErrors()){
                acountProcess.$errors = data.$.slatwall.getAccount().getErrors();
            }
            addErrors(data, data.$.slatwall.getAccount().getProcessObject("login").getErrors());
        }
        return accountProcess;
    }
    
    /** returns meta data as well as validation information for a process object. This is
        the default behavior for a GET request to process context /api/scope/process/ 
     */ 
    public any function getProcessObjectDefinition(required struct data){
        
        try{
            if (structKeyExists(data, entityName) && lCase(data.entityName) == "account"){
                var processObject = evaluate("data.$.slatwall.getAccount().getProcessObject('#data.processObject#')");
            }else if(structKeyExists(data, entityName) && (lCase(data.entityName) == "order" || lCase(data.entityName) == "cart")){
                var processObject = evaluate("data.$.slatwall.cart().getProcessObject('#data.processObject#')");
            }else{
                var processObject = evaluate("data.$.slatwall.#data.entityName#().getProcessObject('#data.processObject#')");
            }
            
            arguments.data.ajaxResponse['processObject'] = processObject.getThisMetaData();
            arguments.data.ajaxResponse['processObject']['validations'] = processObject.getValidations();
            arguments.data.ajaxResponse['processObject']['hasErrors']     = processObject.hasErrors();
            arguments.data.ajaxResponse['processObject']['errors']        = processObject.getErrors();
        }catch(any e){}
        
        var entity = evaluate('data.$.slatwall.get#data.entityName#()');
        var entityMeta = entity.getThisMetaData();
        arguments.data.ajaxResponse['processObject']["entityMeta"] = entityMeta.properties;
    }
    
    /** returns the result of a processObject based action including error information. A form submit.
        This is the default behavior for a POST request to process context /api/scope/process/ */    
    public any function doProcess(required struct data){
        
        if (structKeyExists(data, "processObject")){
            try{
                var processObject = evaluate("this.#data.processObject#(data)");
                
            }catch(any e){
                arguments.data.ajaxResponse['processObject']['errors'] = "#e#";
            }
        }
        if (!isNull(processObject)){
            arguments.data.ajaxResponse['processObject']                  = processObject.getThisMetaData();
            arguments.data.ajaxResponse['processObject']['validations']   = processObject.getValidations();
            arguments.data.ajaxResponse['processObject']['hasErrors']     = processObject.hasErrors();
            arguments.data.ajaxResponse['processObject']['errors']        = processObject.getErrors();
            arguments.data.ajaxResponse['processObject']['messages']      = processObject.getMessages();    
        }
        
        
    }
    
    /** 
     * @method Logout <b>Log a user account outof Slatwall given the users request_token and deviceID</b>
     * @http-context Logout Use this context in conjunction with the listed http-verb to use this resoudatae.
     * @http-verb POST
     * @http-return <b>(200)</b> Request Successful <b>(400)</b> Bad or Missing Input Data
     * @description  Logs a user out of the given device  
     * @param Required request_token
     * @param Required deviceID
     * @example POST to /api/scope/logout with request_token and deviceID in headers
     */
    public any function logout( required struct data ){ 
        
        var account = getAccountService().processAccount( data.$.slatwall.getAccount(), arguments.data, 'logout' );
        arguments.data.$.slatwall.addActionResult( "public:account.logout", account.hasErrors() );
        if(account.hasErrors()){
            addErrors(data, data.$.slatwall.getAccount().getProcessObject("logout").getErrors());
        }
        return account;
    }   
    
    /** 
     *  @method CreateAccount
     *  @http-context createAccount
     *  @http-verb POST
     *  @description  CreateAccount Creates a new user account.  
     *  @http-return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
     *  @param firstName {string}
     *  @param lastName {string}
     *  @param company {string}
     *  @param phone {string}
     *  @param emailAddress {string}
     *  @param emailAddressConfirm {string}
     *  @param createAuthenticationFlag {string}
     *  @param password {string}
     *  @param passwordConfirm {string}
     */
    public void function createAccount( required struct data ) {
        param name="arguments.data.createAuthenticationFlag" default="1";
        var account = getAccountService().processAccount( data.$.slatwall.getAccount(), arguments.data, 'create');
        arguments.data.$.slatwall.addActionResult( "public:account.create", account.hasErrors() );
        if(account.hasErrors()){
            addErrors(data, data.$.slatwall.getAccount().getProcessObject("create").getErrors());
        }
    }
    
    /**
     * @http-context updateDeviceID
     * @description  Updates the device ID for a user account 
     * @http-return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateDeviceID( required struct data ){
        param name="arguments.data.deviceID" default="";
        param name="arguments.data.request_token" default="";

        var sessionEntity = getService("HibachiSessionService").getSessionBySessionCookieNPSID( arguments.data.request_token, true );
        sessionEntity.setDeviceID(arguments.data.deviceID);
        
        //If this is a request from the api, setup the response header and populate it with data.
        //any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct data
        handlePublicAPICall(201, 400, sessionEntity, "Device ID Added", "#arguments.data.deviceID#",  arguments.data);  
    }
    
    
    /**
      * @method forgotPassword
      * @http-context ForgotPassword
      * @http-verb POST
      * @description  Sends an email to a user to reset a password.  
      * @htt-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      **/
    public any function forgotPassword( required struct data ) {
        var account = getAccountService().processAccount( data.$.slatwall.getAccount(), arguments.data, 'forgotPassword');
        arguments.data.$.slatwall.addActionResult( "public:account.forgotPassword", account.hasErrors() );
        return account;
    }
    
    /**
      * @method resetPassword
      * @http-context resetPassword
      * @http-verb POST
      * @description  Sends an email to a user to reset a password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param accountID {string}
      * @param emailAddress {string}
      **/
    public void function resetPassword( required struct data ) {
        param name="data.accountID" default="";
        var account = getAccountService().getAccount( data.accountID );
        if(!isNull(account)) {
            var account = getAccountService().processAccount(account, data, "resetPassword");
            arguments.data.$.slatwall.addActionResult( "public:account.resetPassword", account.hasErrors() );   
            // As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
            if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
                form.emailAddress = account.getEmailAddress();
            }
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.resetPassword", true );
        }
        // Populate the current account with this processObject so that any errors are there.
        arguments.data.$.slatwall.account().setProcessObject( account.getProcessObject( "resetPassword" ) );
        return account.getProcessObject( "resetPassword" ) ;
    }
    
    /**
      * @method changePassword
      * @http-context changePassword
      * @http-verb POST
      * @description  Change a users password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      **/
    public any function changePassword( required struct data ) {
        
        var account = getAccountService().processAccount( data.$.slatwall.getAccount(), arguments.data, 'changePassword');
        arguments.data.$.slatwall.addActionResult( "public:account.changePassword", account.hasErrors() );
        return account;
    }
    
    /**
      * @method updateAccount
      * @http-context updateAccount
      * @http-verb POST
      * @description  Update a users account data.  
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param aFieldToUpdate {json key}
      * @param authToken {json key}
      **/
    public any function updateAccount( required struct data ) {
        
        var account = getAccountService().saveAccount( data.$.slatwall.getAccount(), arguments.data );
        arguments.data.$.slatwall.addActionResult( "public:account.update", account.hasErrors() );
        return account;
    }
    
    /**
      * @method deleteAccountEmailAddress
      * @http-context deleteAccountEmailAddress
      * @http-verb POST
      * @description delete a users account email address
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      **/
    public void function deleteAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountEmailAddress", true );  
        }
        return accountEmailAddress;
    }
    
    /** 
      * @method sendAccountEmailAddressVerificationEmail
      * @http-context send AccountEmailAddressVerificationEmail
      * @description Account Email Address - Send Verification Email 
      * @param accountEmailAddressID The ID of the email address
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      */
    public void function sendAccountEmailAddressVerificationEmail() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'sendVerificationEmail' );
            arguments.data.$.slatwall.addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", accountEmailAddress.hasErrors() );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", true );
        }
        
        return accountEmailAddress;
    }
    
    /** 
     * @method verifyAccountEmailAddress
     * @http-context verifyAccountEmailAddress
     * @http-resoudatae /api/scope/verifyAccountEmailAddress
     * @description Account Email Address - Verify 
     * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
     */
    public void function verifyAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress)) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'verify' );
            arguments.data.$.slatwall.addActionResult( "public:account.verifyAccountEmailAddress", accountEmailAddress.hasErrors() );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.verifyAccountEmailAddress", true );
        }
        handlePublicAPICall(200, 400, accountEmailAddress, "Email Address Verified", "",  arguments.data);
    }
    
    /** 
     * @http-context deleteAccountPhoneNumber
     * @http-verb Delete
     * @description Deletes an Account Phone Number by an accountID 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     */
    public void function deleteAccountPhoneNumber() {
        param name="data.accountPhoneNumberID" default="";
        
        var accountPhoneNumber = getAccountService().getAccountPhoneNumber( data.accountPhoneNumberID );
        
        if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountPhoneNumber", true );   
        }
    }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Address - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     */
    public void function deleteAccountAddress() {
        param name="data.accountAddressID" default="";
        
        var accountAddress = getAccountService().getAccountAddress( data.accountAddressID );
        
        if(!isNull(accountAddress) && accountAddress.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountAddress", !deleteOK );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountAddress", true );   
        }
    }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Payment Method - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     */
    public void function deleteAccountPaymentMethod() {
        param name="data.accountPaymentMethodID" default="";
        
        var accountPaymentMethod = getAccountService().getAccountPaymentMethod( data.accountPaymentMethodID );
        
        if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.deleteAccountPaymentMethod", true ); 
        }
    }
    
    public any function addOrderShippingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="1";
        param name="data.saveShippingAsBilling" default="1";
        
        
        /** add a shipping address */
        var shippingAddress = {};
        if (!isNull(data)){
            //if we have that data and don't have any suggestions to make, than try to populate the address
            shippingAddress = getService('AddressService').newAddress();    
            //get a new address populated with the data.
            var savedAddress = getService('AddressService').saveAddress(shippingAddress, data, "full");
            
            if (isObject(savedAddress) && !savedAddress.hasErrors()){
                //save the address at the order level.
                var order = data.$.slatwall.cart();
                order.setShippingAddress(savedAddress);
                
                if (structKeyExists(data, "saveShippingAsBilling") && data.saveShippingAsBilling){
                    order.setBillingAddress(savedAddress);
                }
                
                if (structKeyExists(data, "saveAsAccountAddressFlag") && data.saveAsAccountAddressFlag){
                
                    var accountAddress = getService('AddressService').getAccountAddress(data.$.slatwall.account().getAccountAddresses()[1].getAccountAddressID());
                    
                    accountAddress.setAccountAddressName(data.name); 
                    //get new saved address
                    var newAddress = getService("AddressService").newAddress();
                    var savedNewAddress = getService('AddressService').saveAddress(newAddress, data);
                    
                    //set the new address on the account address entity.
                    accountAddress.setAddress(savedNewAddress);
                    var savedNewAccountAddress = getService('AddressService').saveAccountAddress(accountAddress);
                
                }
                
                getOrderService().saveOrder(order);
                
            }else{
                    
                    this.addErrors(data, savedAddress.getErrors()); //add the basic errors
                    arguments.data.$.slatwall.addActionResult( "public:cart.AddShippingAddress", savedAddress.hasErrors());
            }
        }
    }
    
    /** adds a billing address to an order. */
    public void function addBillingAddress(required data, required slatwall){
        param name="data.saveAsAccountAddressFlag" default="1"; 
        //if we have that data and don't have any suggestions to make, than try to populate the address
            billingAddress = getService('AddressService').newAddress();    
            
            //get a new address populated with the data.
            var savedAddress = getService('AddressService').saveAddress(billingAddress, arguments.data, "billing");
            
            if (isObject(savedAddress) && !savedAddress.hasErrors()){
                //save the address at the order level.
                var order = slatwall.cart();
                order.setBillingAddress(savedAddress);
                
                getOrderService().saveOrder(order);
            }
            if(savedAddress.hasErrors()){
                    this.addErrors(arguments.data, savedAddress.getErrors()); //add the basic errors
                    arguments.slatwall.addActionResult( "public:cart.AddBillingAddress", savedAddress.hasErrors());
            }
    }
    
    /** 
     * @http-context addAccountPaymentMethod
     * @description Account Payment Method - Add 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     */
    public void function addAccountPaymentMethod() {
        
        if(arguments.data.$.slatwall.getLoggedInFlag()) {
            
            // Fodatae the payment method to be added to the current account
            var accountPaymentMethod = arguments.data.$.slatwall.getAccount().getNewPropertyEntity( 'accountPaymentMethods' );
            
            accountPaymentMethod.setAccount( arguments.data.$.slatwall.getAccount() );
            
            accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.data );
            
            arguments.data.$.slatwall.addActionResult( "public:account.addAccountPaymentMethod", accountPaymentMethod.hasErrors() );
            
            // If there were no errors then we can clear out the
            
        } else {
            
            arguments.data.$.slatwall.addActionResult( "public:account.addAccountPaymentMethod", true );
                
        }
        
    }
    
    /** 
     * @http-context guestAccount
     * @description Logs in a user with a guest account 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     */
    public void function guestAccount(required any data) {
        param name="arguments.data.createAuthenticationFlag" default="0";
        
        var account = getAccountService().processAccount( data.$.slatwall.getAccount(), arguments.data, 'create');
        
        if( !account.hasErrors() ) {
            if( !isNull(data.$.slatwall.getCart().getAccount())) {
                var newCart = getOrderService().duplicateOrderWithNewAccount( data.$.slatwall.getCart(), account );
                data.$.slatwall.getSession().setOrder( newCart );
            } else {
                data.$.slatwall.getCart().setAccount( account );    
            }
            arguments.data.$.slatwall.addActionResult( "public:cart.guestCheckout", false );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:cart.guestCheckout", true ); 
        }
        
    }
    
    /** 
     * @http-context guestAccountCreatePassword
     * @description Save Guest Account
     * @http-return <b>(200)</b> Successfully Created Password or <b>(400)</b> Bad or Missing Input Data
     */
    public void function guestAccountCreatePassword( required struct data ) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.accountID" default="";

        var order = getOrderService().getOrder( arguments.data.orderID );
        
        // verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
        if(!isNull(order) && arguments.data.orderID == arguments.data.$.slatwall.getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.data.accountID && order.getAccount().getGuestAccountFlag()) {
            
            var account = getAccountService().processAccount( order.getAccount(), arguments.data, "createPassword" );
            arguments.data.$.slatwall.addActionResult( "public:cart.guestAccountCreatePassword", account.hasErrors() );
            return account;
        } else {
            
            arguments.data.$.slatwall.addActionResult( "public:cart.guestAccountCreatePassword", true );
        }
        
    }
    /** 
     * @http-context updateSubscriptionUsage
     * @description Subscription Usage - Update
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.data );
            arguments.data.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
            return subscriptionUsage;
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", true );
        }
        
    }
    
    /** 
     * @http-context renewSubscriptionUsage
     * @description Subscription Usage - Renew
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function renewSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'renew' );
            arguments.data.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
            return subscriptionUsage;
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", true );
        }
    }
    
    /** exposes the cart and account */
    public void function getCartData(any data) {
        arguments.data.ajaxResponse = data.$.slatwall.getHibachiScope().getCartData();
    }
    
    public void function getAccountData(any data) {
        arguments.data.ajaxResponse = data.$.slatwall.getHibachiScope().getAccountData();
    }
    
    /** 
     * @http-context duplicateOrder
     * @description Duplicate - Order
     * @http-return <b>(200)</b> Successfully Created Duplicate Order or <b>(400)</b> Bad or Missing Input Data
     */
    public void function duplicateOrder() {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.setAsCartFlag" default="0";
        
        var order = getOrderService().getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID()) {
            
            var data = {
                saveNewFlag=true,
                copyPersonalDataFlag=true
            };
            
            var duplicateOrder = getOrderService().processOrder(order,data,"duplicateOrder" );
            
            if(isBoolean(arguments.data.setAsCartFlag) && arguments.data.setAsCartFlag) {
                arguments.data.$.slatwall.getSession().setOrder( duplicateOrder );
            }
            arguments.data.$.slatwall.addActionResult( "public:account.duplicateOrder", false );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:account.duplicateOrder", true );
        }
    }
    
    /** 
     * @http-context updateOrder
     * @description  Update Order Data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateOrder( required struct data ) {
        var cart = getOrderService().saveOrder( data.$.slatwall.cart(), arguments.data );
        
        // Insure that all items in the cart are within their max constraint
        if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
            cart = getOrderService().processOrder(cart, 'fodataeItemQuantityUpdate');
        }
        
        arguments.data.$.slatwall.addActionResult( "public:cart.update", cart.hasErrors() );
    }
    
    /** 
     * @http-context clearOrder
     * @description  Clear the order data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function clearOrder( required struct data ) {
        var cart = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'clear');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.clear", cart.hasErrors() );
    }
    
    /** 
     * @http-context changeOrder
     * @description Change Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function changeOrder( required struct data ){
        param name="arguments.data.orderID" default="";
        
        var order = getOrderService().getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID()) {
            arguments.data.$.slatwall.getSession().setOrder( order );
            arguments.data.$.slatwall.addActionResult( "public:cart.change", false );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:cart.change", true );
        }
    }
    
    /** 
     * @http-context deleteOrder
     * @description Delete an Order
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     */
    public void function deleteOrder( required struct data ) {
        param name="arguments.data.orderID" default="";
        
        var order = getOrderService().getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == arguments.data.$.slatwall.getAccount().getAccountID()) {
            var deleteOk = getOrderService().deleteOrder(order);
            arguments.data.$.slatwall.addActionResult( "public:cart.delete", !deleteOK );
        } else {
            arguments.data.$.slatwall.addActionResult( "public:cart.delete", true );
        }
    }
    
    /** 
     * @http-context addOrderItem
     * @description Add Order Item to an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function addOrderItem(required any data) {
        // Setup the frontend defaults
        param name="data.preProcessDisplayedFlag" default="true";
        param name="data.saveShippingAccountAddressFlag" default="false";
        
        var cart = data.$.slatwall.cart();
        
        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && data.$.slatwall.getLoggedInFlag() ) {
            cart.setAccount( data.$.slatwall.getAccount() );
        }
        
        cart = getOrderService().processOrder( cart, arguments.data, 'addOrderItem');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            // If the cart doesn't have errors then clear the process object
            cart.clearProcessObject("addOrderItem");
            
            // Also make sure that this cart gets set in the session as the order
            data.$.slatwall.getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
            
        }else{
            addErrors(data, data.$.slatwall.getCart().getProcessObject("addOrderItem").getErrors());
        }
        
    }
    /** 
     * @http-context updateOrderItemQuantity
     * @description Update Order Item on an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateOrderItemQuantity(required any data) {
        
        var cart = data.$.slatwall.cart();
        
        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && data.$.slatwall.getLoggedInFlag() ) {
            cart.setAccount( data.$.slatwall.getAccount() );
        }
        
        if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "sku") && structKeyExists(data.orderItem.sku, "skuID") && structKeyExists(data.orderItem, "qty") && data.orderItem.qty > 0 ){
            for (orderItem in cart.getOrderItems()){
                if (orderItem.getSku().getSkuID() == data.orderItem.sku.skuID){
                    orderItem.setQuantity(data.orderItem.qty);
                }
            }
        }
        arguments.data.$.slatwall.addActionResult( "public:cart.updateOrderItem", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            //Persist the quantity change
            getOrderService().saveOrder(cart);
            
            // Also make sure that this cart gets set in the session as the order
            data.$.slatwall.getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
            
        }else{
            addErrors(data, data.$.slatwall.getCart().getErrors());
        }
    }
    /** 
     * @http-context removeOrderItem
     * @description Remove Order Item from an Order
     * @http-return <b>(200)</b> Successfully Removed or <b>(400)</b> Bad or Missing Input Data
     */
    public void function removeOrderItem(required any data) {
        var cart = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'removeOrderItem');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderFulfillment
     * @description Update Order Fulfillment 
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateOrderFulfillment(required any data) {
        var cart = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'updateOrderFulfillment');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
    }
    
    /** 
     * @http-context addPromotionCode
     * @description Add Promotion Code
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function addPromotionCode(required any data) {
        var cart = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'addPromotionCode');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            cart.clearProcessObject("addPromotionCode");
        }else{
            addErrors(data, data.$.slatwall.getCart().getProcessObject("AddPromotionCode").getErrors());
        }
    }
    
    /** 
     * @http-context removePromotionCode
     * @description Remove Promotion Code
     */
    public void function removePromotionCode(required any data) {
        var cart = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'removePromotionCode');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
    }
    
    /** 
     * @http-context addOrderPayment
     * @description Add Order Payment
     */
    public void function addOrderPayment(required any data) {
        param name="data.newOrderPayment" default="#structNew()#";
        param name="data.newOrderPayment.orderPaymentID" default="";
        param name="data.newOrderPayment.saveShippingAsBilling" default="0";
        param name="data.accountAddressID" default="";
        param name="data.accountPaymentMethodID" default="";
        param name="data.newOrderPayment.orderPaymentType.typeID"  default='444df2f0fed139ff94191de8fcd1f61b';
        param name="data.newOrderPayment.paymentMethod.paymentMethodID" default="444df303dedc6dab69dd7ebcc9b8036a";
       
        // Make sure that someone isn't trying to pass in another users orderPaymentID
        if(len(data.newOrderPayment.orderPaymentID)) {
            var orderPayment = getOrderService().getOrderPayment(data.newOrderPayment.orderPaymentID);
            if(orderPayment.getOrder().getOrderID() != data.$.slatwall.cart().getOrderID()) {
                data.newOrderPayment.orderPaymentID = "";
            }
        }
        
        if (!data.newOrderPayment.saveShippingAsBilling){
            //use this billing information
            this.addBillingAddress(data.newOrderPayment.billingAddress, arguments.data.$.slatwall, "billing");
        }
        
        var addOrderPayment = getService('OrderService').processOrder( data.$.slatwall.cart(), arguments.data, 'addOrderPayment');
        arguments.data.$.slatwall.addActionResult( "public:cart.addOrderPayment", addOrderPayment.hasErrors() );
        
    }
    
    
    /** 
     * @http-context removeOrderPayment
     * @description Remove Order Payment 
     */
    public void function removeOrderPayment(required any data) {
        var cart = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'removeOrderPayment');
        
        arguments.data.$.slatwall.addActionResult( "public:cart.removeOrderPayment", cart.hasErrors() );
    }
    
    /** 
     * @http-context placeOrder
     * @description Place Order
     */
    public void function placeOrder(required any data) {
        
        // Insure that all items in the cart are within their max constraint
        if(!data.$.slatwall.cart().hasItemsQuantityWithinMaxOrderQuantity()) {
            getOrderService().processOrder(data.$.slatwall.cart(), 'fodataeItemQuantityUpdate');
            arguments.data.$.slatwall.addActionResult( "public:cart.placeOrder", true );
        } else {
            // Setup newOrderPayment requirements
            if(structKeyExists(data, "newOrderPayment")) {
                param name="data.newOrderPayment.orderPaymentID" default="";
                param name="data.accountAddressID" default="";
                param name="data.accountPaymentMethodID" default="";
                
                // Make sure that someone isn't trying to pass in another users orderPaymentID
                if(len(data.newOrderPayment.orderPaymentID)) {
                    var orderPayment = getOrderService().getOrderPayment(data.newOrderPayment.orderPaymentID);
                    if(orderPayment.getOrder().getOrderID() != data.$.slatwall.cart().getOrderID()) {
                        data.newOrderPayment.orderPaymentID = "";
                    }
                }
                
                data.newOrderPayment.order.orderID = data.$.slatwall.cart().getOrderID();
                data.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
            }
            
            var order = getOrderService().processOrder( data.$.slatwall.cart(), arguments.data, 'placeOrder');
            
            arguments.data.$.slatwall.addActionResult( "public:cart.placeOrder", order.hasErrors() );
            
            if(!order.hasErrors()) {
                data.$.slatwall.setSessionValue('confirmationOrderID', order.getOrderID());
                data.$.slatwall.getSession().setLastPlacedOrderID( order.getOrderID() );
            }
            
        }
    
    }
    
    /** 
     * @http-context addProductReview
     *  @description Add Product Review
     */
    public void function addProductReview(required any data) {
        param name="data.newProductReview.product.productID" default="";
        
        var product = getProductService().getProduct( data.newProductReview.product.productID );
        
        if( !isNull(product) ) {
            product = getProductService().processProduct( product, arguments.data, 'addProductReview');
            
            arguments.data.$.slatwall.addActionResult( "public:product.addProductReview", product.hasErrors() );
            
            if(!product.hasErrors()) {
                product.clearProcessObject("addProductReview");
            }
        } else {
            arguments.data.$.slatwall.addActionResult( "public:product.addProductReview", true );
        }
    }
    
    public any function addErrors( required struct data , errors){
        if (!structKeyExists(arguments.data.ajaxResponse, "errors")){
            arguments.data.ajaxResponse["errors"] = {};
        }
        arguments.data.ajaxResponse["errors"] = errors;
    } 
    
    /** returns a list of state code options either for us (default) or by the passed in countryCode */
    public void function getStateCodeOptionsByCountryCode( required struct data ) {
        param name="data.countryCode" type="string" default="US";
        
        var country = getAddressService().getCountry(data.countryCode);
        var stateCodeOptions = country.getStateCodeOptions();
        
        arguments.data.ajaxResponse["stateCodeOptions"] = stateCodeOptions;
        
    }
    
    /** Given a country - this returns all of the address options for that country */
    public void function getAddressOptionsByCountryCode( required data ) {
        param name="data.countryCode" type="string" default="US";
        
        var country = getAddressService().getCountry(data.countryCode);
        var addressOptions = {
            
            'streetAddressLabel' =  country.getStreetAddressLabel(),
            'streetAddressShowFlag' =  country.getStreetAddressShowFlag(),
            'streetAddressRequiredFlag' =  country.getStreetAddressRequiredFlag(),
            
            'street2AddressLabel' =  country.getStreet2AddressLabel(),
            'street2AddressShowFlag' =  country.getStreet2AddressShowFlag(),
            'street2AddressRequiredFlag' =  country.getStreet2AddressRequiredFlag(),
            
            'cityLabel' =  country.getCityLabel(),
            'cityShowFlag' =  country.getCityShowFlag(),
            'cityRequiredFlag' =  country.getCityRequiredFlag(),
            
            'localityLabel' =  country.getLocalityLabel(),
            'localityShowFlag' =  country.getLocalityShowFlag(),
            'localityRequiredFlag' =  country.getLocalityRequiredFlag(),
            
            'stateCodeLabel' =  country.getStateCodeLabel(),
            'stateCodeShowFlag' =  country.getStateCodeShowFlag(),
            'stateCodeRequiredFlag' =  country.getStateCodeRequiredFlag(),
            
            'postalCodeLabel' =  country.getPostalCodeLabel(),
            'postalCodeShowFlag' =  country.getPostalCodeShowFlag(),
            'postalCodeRequiredFlag' =  country.getPostalCodeRequiredFlag()
            
        };
        
        arguments.data.ajaxResponse["addressOptions"] = addressOptions;
        
    }
    
    /** returns the list of country code options */
    public void function getCountries( required struct data ) {
        arguments.data.ajaxResponse['countryCodeOptions'] = getAddressService().getCountryCodeOptions();
    }
    
}
