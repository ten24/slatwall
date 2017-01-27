/*

    Slatwall - An Open Source eCommerce Platform
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
    provided that you include the source code of that other code when and as the 
    GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService"  accessors="true" output="false" 
{
    property name="accountService" type="any";
    property name="addressService" type="any";
    property name="formService" type="any";
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
     @ProcessMethod Account_Login           
     */
    
    public any function login( required struct data ){
        var accountProcess = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'login' );
        getHibachiScope().addActionResult( "public:account.login", accountProcess.hasErrors() );
        if (accountProcess.hasErrors()){
            if (getHibachiScope().getAccount().hasErrors()){
                acountProcess.$errors = getHibachiScope().getAccount().getErrors();
            }
            addErrors(data, getHibachiScope().getAccount().getProcessObject("login").getErrors());
        }
        return accountProcess;
    }
    
    /** returns meta data as well as validation information for a process object. This is
        the default behavior for a GET request to process context /api/scope/process/ 
     
     */ 
    public any function getProcessObjectDefinition(required struct data){
        
        try{
            if (structKeyExists(data, entityName) && lCase(data.entityName) == "account"){
                var processObject = evaluate("getHibachiScope().getAccount().getProcessObject('#data.processObject#')");
            }else if(structKeyExists(data, entityName) && (lCase(data.entityName) == "order" || lCase(data.entityName) == "cart")){
                var processObject = evaluate("getHibachiScope().cart().getProcessObject('#data.processObject#')");
            }else{
                var processObject = evaluate("getHibachiScope().#data.entityName#().getProcessObject('#data.processObject#')");
            }
            
            arguments.data.ajaxResponse['processObject'] = processObject.getThisMetaData();
            arguments.data.ajaxResponse['processObject']['validations'] = processObject.getValidations();
            arguments.data.ajaxResponse['processObject']['hasErrors']     = processObject.hasErrors();
            arguments.data.ajaxResponse['processObject']['errors']        = processObject.getErrors();
        }catch(any e){}
        
        var entity = evaluate('getHibachiScope().get#data.entityName#()');
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
     * @ProcessMethod Account_Logout
     */
    public any function logout( required struct data ){ 
        
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'logout' );
        getHibachiScope().addActionResult( "public:account.logout", account.hasErrors() );
        if(account.hasErrors()){
            addErrors(data, getHibachiScope().getAccount().getProcessObject("logout").getErrors());
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
     *  @ProcessMethod Account_Create
     */
    public any function createAccount( required struct data ) {
        param name="arguments.data.createAuthenticationFlag" default="1";
        
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'create');
        getHibachiScope().addActionResult( "public:account.create", account.hasErrors() );
        
        if(account.hasErrors()){
            addErrors(data, getHibachiScope().getAccount().getProcessObject("create").getErrors());
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
      * @ProcessMethod Account_ForgotPassword
      **/
    public any function forgotPassword( required struct data ) {
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'forgotPassword');
        getHibachiScope().addActionResult( "public:account.forgotPassword", account.hasErrors() );
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
      * @ProcessMethod Account_ResetPassword
      **/
    public void function resetPassword( required struct data ) {
        param name="data.accountID" default="";
        var account = getAccountService().getAccount( data.accountID );
        if(!isNull(account)) {
            var account = getAccountService().processAccount(account, data, "resetPassword");
            getHibachiScope().addActionResult( "public:account.resetPassword", account.hasErrors() );   
            // As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
            if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
                form.emailAddress = account.getEmailAddress();
            }
        } else {
            getHibachiScope().addActionResult( "public:account.resetPassword", true );
        }
        // Populate the current account with this processObject so that any errors are there.
        getHibachiScope().account().setProcessObject( account.getProcessObject( "resetPassword" ) );
        return account.getProcessObject( "resetPassword" ) ;
    }
    
    /**
      * @method changePassword
      * @http-context changePassword
      * @http-verb POST
      * @description  Change a users password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod Account_ChangePassword
      **/
    public any function changePassword( required struct data ) {
        
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'changePassword');
        getHibachiScope().addActionResult( "public:account.changePassword", account.hasErrors() );
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
      * @ProcessMethod Account_Save
      **/
    public any function updateAccount( required struct data ) {
        
        var account = getAccountService().saveAccount( getHibachiScope().getAccount(), arguments.data );
        getHibachiScope().addActionResult( "public:account.update", account.hasErrors() );
        return account;
    }
    
    /**
      * @method deleteAccountEmailAddress
      * @http-context deleteAccountEmailAddress
      * @http-verb POST
      * @description delete a users account email address
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod AccountEmailAddress_Delete
      **/
    public void function deleteAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
            getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", true );  
        }
        return accountEmailAddress;
    }
    
    /** 
      * @method sendAccountEmailAddressVerificationEmail
      * @http-context send AccountEmailAddressVerificationEmail
      * @description Account Email Address - Send Verification Email 
      * @param accountEmailAddressID The ID of the email address
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @ProcessMethod AccountEmailAddress_SendVerificationEmail
      */
    public void function sendAccountEmailAddressVerificationEmail() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'sendVerificationEmail' );
            getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", accountEmailAddress.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", true );
        }
        
        return accountEmailAddress;
    }
    
    /** 
     * @method verifyAccountEmailAddress
     * @http-context verifyAccountEmailAddress
     * @http-resoudatae /api/scope/verifyAccountEmailAddress
     * @description Account Email Address - Verify 
     * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountEmailAddress_Verify
     */
    public void function verifyAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress)) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'verify' );
            getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", accountEmailAddress.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", true );
        }
        handlePublicAPICall(200, 400, accountEmailAddress, "Email Address Verified", "",  arguments.data);
    }
    
    /** 
     * @http-context deleteAccountPhoneNumber
     * @http-verb Delete
     * @description Deletes an Account Phone Number by an accountID 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPhoneNumber_Delete
     */
    public void function deleteAccountPhoneNumber() {
        param name="data.accountPhoneNumberID" default="";
        
        var accountPhoneNumber = getAccountService().getAccountPhoneNumber( data.accountPhoneNumberID );
        
        if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
            getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", true );   
        }
    }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Address - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountAddress_Delete
     */
    public void function deleteAccountAddress() {
        param name="data.accountAddressID" default="";
        
        var accountAddress = getAccountService().getAccountAddress( data.accountAddressID );
        
        if(!isNull(accountAddress) && accountAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
            getHibachiScope().addActionResult( "public:account.deleteAccountAddress", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountAddress", true );   
        }
    }
    
     /**
      * Adds a new account address.
      */
     public void function addNewAccountAddress(required data){
     	param name="data.countrycode" default="US";
     	
     	var accountAddress = getService("AccountService").newAccountAddress();
     	if (structKeyExists(data, "accountAddressName")){
     		accountAddress.setAccountAddressName(data.accountAddressName);
     	}
     	
     	var newAddress = getService("AddressService").newAddress();
     	newAddress = getService("AddressService").saveAddress(newAddress, data, "full");
      	
      	if (!newAddress.hasErrors()){
      		accountAddress.setAddress(newAddress);
      		accountAddress.setAccount(getHibachiScope().getAccount());	
      		var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
 	     	if (!savedAccountAddress.hasErrors()){
 	     		getHibachiScope().addActionResult( "public:account.addNewAccountAddress", savedAccountAddress.hasErrors() ); 
  	     		getDao('hibachiDao').flushOrmSession();; 
 	     	}
      	}else{
      		getHibachiScope().addActionResult( "public:account.addNewAccountAddress", true ); 
      	}
     }
     
     /**
      * Updates an address.
      */
     public void function updateAddress(required data){
     	param name="data.countrycode" default="US";
     	param name="data.addressID" default="";
     	param name="data.phoneNumber" default="";
     	
     	var newAddress = getService("AddressService").getAddress(data.addressID, true);
     	if (!isNull(newAddress) && !newAddress.hasErrors()){
       		newAddress = getService("AddressService").saveAddress(newAddress, data, "full");
       		
       		//save the order.
  	     	getService("OrderService").saveOrder(getHibachiScope().getCart());
  	     	getHibachiScope().addActionResult( "public:cart.updateAddress", false ); 
       	}
     }
     
     /**
      * Updates an address.
      */
     public void function updateAccountAddress(required data){
     	
      	var accountAddress = getService("AddressService").getAccountAddress(data.accountAddressID, true);
      	accountAddress = getService("AddressService").saveAccountAddress(accountAddress, data, "save");
     	if (!isNull(accountAddress) && !accountAddress.hasErrors()){
       		//save the order.
  	     	getService("OrderService").saveAccount(getHibachiScope().getAccount());
  	     	getHibachiScope().addActionResult( "public:cart.updateAccountAddress", false );
  	    } 
     }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Payment Method - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPaymentMethod_Delete
     */
    public void function deleteAccountPaymentMethod() {
        param name="data.accountPaymentMethodID" default="";
        
        var accountPaymentMethod = getAccountService().getAccountPaymentMethod( data.accountPaymentMethodID );
        
        if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
            getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", true ); 
        }
    }
    
    public any function addOrderShippingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0";
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
                var order = getHibachiScope().cart();
                order.setShippingAddress(savedAddress);
                
                if (structKeyExists(data, "saveShippingAsBilling") && data.saveShippingAsBilling){
                    order.setBillingAddress(savedAddress);
                }
                
                if (structKeyExists(data, "saveAsAccountAddressFlag") && data.saveAsAccountAddressFlag){
                   
                 	var accountAddress = getService("AccountService").newAccountAddress();
                 	accountAddress.setAddress(shippingAddress);
                 	accountAddress.setAccount(getHibachiScope().getAccount());
                 	var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                 	if (!savedAddress.hasErrors()){
                 		getDao('hibachiDao').flushOrmSession();;
                 	}
                  
                }
                
                getOrderService().saveOrder(order);
                
            }else{
                    
                    this.addErrors(data, savedAddress.getErrors()); //add the basic errors
                    getHibachiScope().addActionResult( "public:cart.AddShippingAddress", savedAddress.hasErrors());
            }
        }
    }
    
    /** Adds a shipping address to an order using an account address */
    public void function addShippingAddressUsingAccountAddress(required data){
        var accountAddressId = data.accountAddressID;
        if (isNull(accountAddressID)){
            this.addErrors(arguments.data, "Could not add account address. address id empty."); //add the basic errors
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
       		return;
        }
        var accountAddress = getService('AddressService').getAccountAddress(accountAddressID);
        
        if (!isNull(accountAddress) && !accountAddress.hasErrors()){
            //save the address at the order level.
            var order = getHibachiScope().cart();
            for (var orderFulfillment in order.getOrderFulfillments()){
             	orderFulfillment.setShippingAddress(accountAddress.getAddress());
             	getService("OrderService").saveOrderFulfillment(orderFulfillment);
            }
            order.setBillingAddress(accountAddress.getAddress());
            getOrderService().saveOrder(order);     
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", accountAddress.hasErrors());           
        }else{
            this.addErrors(arguments.data, accountAddress.getErrors()); //add the basic errors
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", accountAddress.hasErrors());
        }
    }
    
    /** Sets the shipping method to an order shippingMethodID */
    public void function addShippingMethodUsingShippingMethodID(required data){
        var shippingMethodId = data.shippingMethodID;
        var orderFulfillmentWithShippingMethodOptions = 1;
        if (!isNull(data.orderFulfillmentWithShippingMethodOptions)){
        	orderFulfillmentWithShippingMethodOptions = data.orderFulfillmentWithShippingMethodOptions + 1; //from js to cf
        }
        if (isNull(shippingMethodId)){
            return;
        }
        var shippingMethod = getService('ShippingService').getShippingMethod(shippingMethodId);
        
        if (!isNull(shippingMethod) && !shippingMethod.hasErrors()){
            var order = getHibachiScope().cart();
            var orderFulfillment = order.getOrderFulfillments()[orderFulfillmentWithShippingMethodOptions];
            orderFulfillment.setShippingMethod(shippingMethod);
            getOrderService().saveOrder(order); 
            getDao('hibachiDao').flushOrmSession();;           
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());
        }else{
            this.addErrors(arguments.data, shippingMethod.getErrors()); //add the basic errors
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());
        }
        
    }
    
    /** adds a billing address to an order. 
    @ProcessMethod Address_Save
    */
    public void function addBillingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0"; 
        //if we have that data and don't have any suggestions to make, than try to populate the address
            billingAddress = getService('AddressService').newAddress();    
            
            //get a new address populated with the data.
            var savedAddress = getService('AddressService').saveAddress(billingAddress, arguments.data, "full");
            
            if (!isNull(savedAddress) && !savedAddress.hasErrors()){
                //save the address at the order level.
                var order = getHibachiScope().cart();
                order.setBillingAddress(savedAddress);
                
                getOrderService().saveOrder(order);
            }
            if(savedAddress.hasErrors()){
                    this.addErrors(arguments.data, savedAddress.getErrors()); //add the basic errors
            	    getHibachiScope().addActionResult( "public:cart.AddBillingAddress", true);
            }
    }
    
    /** 
     * @http-context addAccountPaymentMethod
     * @description Account Payment Method - Add 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPaymentMethod_Save
     */
    public void function addAccountPaymentMethod(required any data) {
        
        if (!isNull(data) && !structKeyExists(data, 'accountPaymentMethod') && structKeyExists(data, "selectedPaymentMethod")){
        	data['accountPaymentMethod'] = {};
        	data['accountPaymentMethod']['accountPaymentMethodID']  = data.selectedPaymentMethod;
        }
        if (!isNull(data) && !structKeyExists(data, 'paymentMethod')){
         	data['paymentMethod'] = {};
         	data['paymentMethod'].paymentMethodID = '444df303dedc6dab69dd7ebcc9b8036a';
        }
        if (!isNull(data) && !structKeyExists(data, 'billingAddress')){
         	data['newOrderPayment'] = data;
         	data['newOrderPayment']['billingAddress'] = data;
        }	
        
        if(getHibachiScope().getLoggedInFlag()) {
            
            // Fodatae the payment method to be added to the current account
           if (structKeyExists(data, "selectedPaymentMethod")){
             	var accountPaymentMethod = getHibachiScope().getService("AccountService").getAccountPaymentMethod( data.selectedPaymentMethod );
           }else{
             	var accountPaymentMethod = getHibachiScope().getService("AccountService").newAccountPaymentMethod(  );	
             	accountPaymentMethod.setAccount( getHibachiScope().getAccount() );
           }
            
            accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.data );
            
            getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", accountPaymentMethod.hasErrors() );
            data['ajaxResponse']['errors'] = accountPaymentMethod.getErrors();
            // If there were no errors then we can clear out the
            
        } else {
            
            getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", true );
                
        }
        
    }
    
    /** 
     * @http-context guestAccount
     * @description Logs in a user with a guest account 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Account_Create
     */
    public void function guestAccount(required any data) {
        param name="arguments.data.createAuthenticationFlag" default="0";
        
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'create');
        
        if( !account.hasErrors() ) {
            if( !isNull(getHibachiScope().getCart().getAccount())) {
                var newCart = getOrderService().duplicateOrderWithNewAccount( getHibachiScope().getCart(), account );
                getHibachiScope().getSession().setOrder( newCart );
            } else {
                getHibachiScope().getCart().setAccount( account );    
            }
            getHibachiScope().addActionResult( "public:cart.guestCheckout", false );
        } else {
            getHibachiScope().addActionResult( "public:cart.guestCheckout", true ); 
        }
        
    }
    
    /** 
     * @http-context guestAccountCreatePassword
     * @description Save Guest Account
     * @http-return <b>(200)</b> Successfully Created Password or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Account_CreatePassword
     */
    public void function guestAccountCreatePassword( required struct data ) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.accountID" default="";

        var order = getOrderService().getOrder( arguments.data.orderID );
        
        // verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
        if(!isNull(order) && arguments.data.orderID == getHibachiScope().getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.data.accountID && order.getAccount().getGuestAccountFlag()) {
            
            var account = getAccountService().processAccount( order.getAccount(), arguments.data, "createPassword" );
            getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", account.hasErrors() );
            return account;
        } else {
            
            getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", true );
        }
        
    }
    /** 
     * @http-context updateSubscriptionUsage
     * @description Subscription Usage - Update
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Save
     */
    public void function updateSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.data );
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
            return subscriptionUsage;
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
        
    }
    
    /** 
     * @http-context renewSubscriptionUsage
     * @description Subscription Usage - Renew
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Renew
     */
    public void function renewSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'renew' );
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
            return subscriptionUsage;
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
    }
    
    /** exposes the cart and account */
    public void function getCartData(any data) {
        arguments.data.ajaxResponse = getHibachiScope().getCartData();
    }
    
    public void function getAccountData(any data) {
        arguments.data.ajaxResponse = getHibachiScope().getAccountData();
    }
    
    /** 
     * @http-context duplicateOrder
     * @description Duplicate - Order
     * @http-return <b>(200)</b> Successfully Created Duplicate Order or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_DuplicateOrder
     */
    public void function duplicateOrder() {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.setAsCartFlag" default="0";
        
        var order = getOrderService().getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            
            var data = {
                saveNewFlag=true,
                copyPersonalDataFlag=true
            };
            
            var duplicateOrder = getOrderService().processOrder(order,data,"duplicateOrder" );
            
            if(isBoolean(arguments.data.setAsCartFlag) && arguments.data.setAsCartFlag) {
                getHibachiScope().getSession().setOrder( duplicateOrder );
            }
            getHibachiScope().addActionResult( "public:account.duplicateOrder", false );
        } else {
            getHibachiScope().addActionResult( "public:account.duplicateOrder", true );
        }
    }
    
    /** 
     * @http-context updateOrder
     * @description  Update Order Data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_ForceItemQuantityUpdate
     */
    public void function updateOrder( required struct data ) {
        var cart = getOrderService().saveOrder( getHibachiScope().cart(), arguments.data );
        
        // Insure that all items in the cart are within their max constraint
        if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
            cart = getOrderService().processOrder(cart, 'forceItemQuantityUpdate');
        }
        
        getHibachiScope().addActionResult( "public:cart.update", cart.hasErrors() );
    }
    
    /** 
     * @http-context clearOrder
     * @description  Clear the order data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Clear
     */
    public void function clearOrder( required struct data ) {
        var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'clear');
        
        getHibachiScope().addActionResult( "public:cart.clear", cart.hasErrors() );
    }
    
    /** 
     * @http-context changeOrder
     * @description Change Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function changeOrder( required struct data ){
        param name="arguments.data.orderID" default="";
        
        var order = getOrderService().getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            getHibachiScope().getSession().setOrder( order );
            getHibachiScope().addActionResult( "public:cart.change", false );
        } else {
            getHibachiScope().addActionResult( "public:cart.change", true );
        }
    }
    
    /** 
     * @http-context deleteOrder
     * @description Delete an Order
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Delete
     */
    public void function deleteOrder( required struct data ) {
        param name="arguments.data.orderID" default="";
        
        var order = getOrderService().getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            var deleteOk = getOrderService().deleteOrder(order);
            getHibachiScope().addActionResult( "public:cart.delete", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:cart.delete", true );
        }
    }
    
    /**
     * Will add multiple orderItems at once given a list of skuIDs or skuCodes.
     */
    public void function addOrderItems(required any data){
    	param name="data.skuIds" default="";
    	param name="data.skuCodes" default="";
    	
    	
    	//add skuids
    	if (!isNull(data.skuIds)){
    		for (var sku in data.skuIds){
    			data["skuID"]=sku; data["quantity"]=1;
    			addOrderItem(data=data);
    		}
    	}
    	//add skuCodes
    	if (!isNull(data.skuCodes)){
    		for (var sku in data.skuCodes){
    			data["skuCode"]=sku; data["quantity"]=1;
    			addOrderItem(data=data);
    		}
    	}
    }
    
    /** 
     * @http-context addOrderItem
     * @description Add Order Item to an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Order_addOrderItem
     */
    public void function addOrderItem(required any data) {
        // Setup the frontend defaults
        param name="data.preProcessDisplayedFlag" default="true";
        param name="data.saveShippingAccountAddressFlag" default="false";
        
        var cart = getHibachiScope().cart();
        
        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
            cart.setAccount( getHibachiScope().getAccount() );
        }
        
        cart = getOrderService().processOrder( cart, arguments.data, 'addOrderItem');
        
        getHibachiScope().addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            // If the cart doesn't have errors then clear the process object
            cart.clearProcessObject("addOrderItem");
            
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
            
        }else{
            addErrors(data, getHibachiScope().getCart().getProcessObject("addOrderItem").getErrors());
        }
        
    }
    /** 
     * @http-context updateOrderItemQuantity
     * @description Update Order Item on an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Save
     */
    public void function updateOrderItemQuantity(required any data) {
        
        var cart = getHibachiScope().cart();
        
        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
            cart.setAccount( getHibachiScope().getAccount() );
        }
        
        if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "sku") && structKeyExists(data.orderItem.sku, "skuID") && structKeyExists(data.orderItem, "qty") && data.orderItem.qty > 0 ){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getSku().getSkuID() == data.orderItem.sku.skuID){
                    orderItem.setQuantity(data.orderItem.qty);
                }
            }
        }
        getHibachiScope().addActionResult( "public:cart.updateOrderItem", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            //Persist the quantity change
            getOrderService().saveOrder(cart);
            
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
            
        }else{
            addErrors(data, getHibachiScope().getCart().getErrors());
        }
    }
    /** 
     * @http-context removeOrderItem
     * @description Remove Order Item from an Order
     * @http-return <b>(200)</b> Successfully Removed or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_RemoveOrderItem
     */
    public void function removeOrderItem(required any data) {
        var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderItem');
        
        getHibachiScope().addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderFulfillment
     * @description Update Order Fulfillment 
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      @ProcessMethod Order_UpdateOrderFulfillment
     */
    public void function updateOrderFulfillment(required any data) {
        var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'updateOrderFulfillment');
        
        getHibachiScope().addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
    }
    
    /** 
     * @http-context addPromotionCode
     * @description Add Promotion Code
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_addPromotionCode
     */
    public void function addPromotionCode(required any data) {
        var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'addPromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            cart.clearProcessObject("addPromotionCode");
        }else{
            addErrors(data, getHibachiScope().getCart().getProcessObject("AddPromotionCode").getErrors());
        }
    }
    
    /** 
     * @http-context removePromotionCode
     * @description Remove Promotion Code
     @ProcessMethod Order_RemovePromotionCode
     */
    public void function removePromotionCode(required any data) {
        var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'removePromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
    }
    
    /** 
     * @http-context addOrderPayment
     * @description Add Order Payment
     @ProcessMethod Order_AddOrderPayment
     */
    public void function addOrderPayment(required any data) {
        param name="data.newOrderPayment" default="#structNew()#";
        param name="data.newOrderPayment.orderPaymentID" default="";
        param name="data.newOrderPayment.saveShippingAsBilling" default="0";
        param name="data.accountAddressID" default="";
        param name="data.accountPaymentMethodID" default="";
        param name="data.newOrderPayment.paymentMethod.paymentMethodID" default="444df303dedc6dab69dd7ebcc9b8036a";
       
        // Make sure that someone isn't trying to pass in another users orderPaymentID
        if(len(data.newOrderPayment.orderPaymentID)) {
            var orderPayment = getOrderService().getOrderPayment(data.newOrderPayment.orderPaymentID);
            if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                data.newOrderPayment.orderPaymentID = "";
            }
        }
        
        if (data.newOrderPayment.saveShippingAsBilling == true){
            //use this billing information
            this.addBillingAddress(data.newOrderPayment.billingAddress, "billing");
        }
        
        var addOrderPayment = getService('OrderService').processOrder( getHibachiScope().cart(), arguments.data, 'addOrderPayment');
        getHibachiScope().addActionResult( "public:cart.addOrderPayment", addOrderPayment.hasErrors() );
        
    }
    /**
     Adds an order payment and then calls place order.
    */
    public void function addOrderPaymentAndPlaceOrder(required any data) {
        addOrderPayment(arguments.data);
        if (!getHibachiScope().cart().hasErrors()){
            placeOrder(arguments.data);
        }
        
    }
    
    
    /** 
     * @http-context removeOrderPayment
     * @description Remove Order Payment 
     */
    public void function removeOrderPayment(required any data) {
        var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderPayment');
        
        getHibachiScope().addActionResult( "public:cart.removeOrderPayment", cart.hasErrors() );
    }
    
    /** 
     * @http-context placeOrder
     * @description Place Order
     @ProcessMethod Order_PlaceOrder
     */
    public void function placeOrder(required any data) {
        
        // Insure that all items in the cart are within their max constraint
        if(!getHibachiScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
            getOrderService().processOrder(getHibachiScope().cart(), 'forceItemQuantityUpdate');
            getHibachiScope().addActionResult( "public:cart.placeOrder", true );
        } else {
            // Setup newOrderPayment requirements
            if(structKeyExists(data, "newOrderPayment")) {
                param name="data.newOrderPayment.orderPaymentID" default="";
                param name="data.accountAddressID" default="";
                param name="data.accountPaymentMethodID" default="";
                
                // Make sure that someone isn't trying to pass in another users orderPaymentID
                if(len(data.newOrderPayment.orderPaymentID)) {
                    var orderPayment = getOrderService().getOrderPayment(data.newOrderPayment.orderPaymentID);
                    if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                        data.newOrderPayment.orderPaymentID = "";
                    }
                }
                
                data.newOrderPayment.order.orderID = getHibachiScope().cart().getOrderID();
                data.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
            }
            
            var order = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'placeOrder');
            
            getHibachiScope().addActionResult( "public:cart.placeOrder", order.hasErrors() );
            
            if(!order.hasErrors()) {
                getHibachiScope().setSessionValue('confirmationOrderID', order.getOrderID());
                getHibachiScope().getSession().setLastPlacedOrderID( order.getOrderID() );
            }
            
        }
    
    }
    
    /** 
     * @http-context addProductReview
     *  @description Add Product Review
     @ProcessMethod Order_addProductReview
     */
    public void function addProductReview(required any data) {
        param name="data.newProductReview.product.productID" default="";
        
        var product = getProductService().getProduct( data.newProductReview.product.productID );
        
        if( !isNull(product) ) {
            product = getProductService().processProduct( product, arguments.data, 'addProductReview');
            
            getHibachiScope().addActionResult( "public:product.addProductReview", product.hasErrors() );
            
            if(!product.hasErrors()) {
                product.clearProcessObject("addProductReview");
            }
        } else {
            getHibachiScope().addActionResult( "public:product.addProductReview", true );
        }
    }
    
    public any function addErrors( required struct data , errors){
        
        if (!structKeyExists(arguments.data, "ajaxResponse")){
            arguments.data["ajaxResponse"] = {};
        }
        
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