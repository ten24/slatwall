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
component  accessors="true" output="false" 
{
    property name="accountService" type="any";
    property name="addressService" type="any";
    property name="formService" type="any";
    property name="orderService" type="any";
    property name="userUtility" type="any";
    property name="paymentService" type="any";
    property name="subscriptionService" type="any";
    property name="hibachiCacheService" type="any";
    property name="hibachiSessionService" type="any";
    property name="hibachiUtilityService" type="any";
    property name="productService" type="any";
    property name="hibachiAuditService" type="any";
    property name="validationService" type="any";
    property name="hibachiService" type="any";

    variables.publicContexts = [];
    variables.responseType = "json";
    
    public any function getHibachiScope(){
        return getHibachiService().getHibachiScope();
    }
    
    public any function getDAO(required string daoName){
        return getHibachiService().getDAO(arguments.daoName);
    }
    
    public any function getService(required string serviceName){
        return getHibachiService().getService(arguments.serviceName);
    }
    
    public any function invokeMethod(required string methodName, struct methodArguments={}) {
        
		if(structKeyExists(this, arguments.methodName)) {
			var theMethod = this[ arguments.methodName ];
			return theMethod(argumentCollection = methodArguments);
		}
		
		throw("You have attempted to call the method #arguments.methodName# which does not exist in publicService");
	}
    
    /**
     * This will return the path to an image based on the skuIDs (sent as a comma seperated list)
     * and a 'profile name' that determines the size of that image.
     * /api/scope/getResizedImageByProfileName&profileName=large&skuIDs=8a8080834721af1a0147220714810083,4028818d4b31a783014b5653ad5d00d2,4028818d4b05b871014b102acb0700d5
     * ...should return three paths.
     */
    public any function getResizedImageByProfileName(required any data) {
        
        var imageHeight = 60;
        var imageWidth  = 60;
        
        if(arguments.data.profileName == "small"){
            imageHeight = getService('SettingService').getSettingValue('productImageSmallHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageSmallWidth');
            
        }else if (arguments.data.profileName == "medium"){
            imageHeight = getService('SettingService').getSettingValue('productImageMediumHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageMediumWidth');
        }
        else if (arguments.data.profileName == "large"){
            imageHeight = getService('SettingService').getSettingValue('productImageLargeHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageLargeWidth');
        }
        else if (arguments.data.profileName == "xlarge"){
            imageHeight = getService('SettingService').getSettingValue('productImageXLargeHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageXLargeWidth');
        }
        else if (arguments.data.profileName == "listing"){
            imageHeight = getService('SettingService').getSettingValue('productListingImageHeight');
            imageWidth  = getService('SettingService').getSettingValue('productListingImageWidth');
        }
        arguments.data.ajaxResponse['resizedImagePaths'] = {};
        var skus = [];
        
        //smart list to load up sku array
        var skuSmartList = getService('skuService').getSkuSmartList();
        skuSmartList.addInFilter('skuID',data.skuIDs);
        
        if( skuSmartList.getRecordsCount() > 0){
            var skus = skuSmartList.getRecords();
            
            for  (var sku in skus){
                arguments.data.ajaxResponse['resizedImagePaths'][sku.getSkuID()] = sku.getResizedImagePath(width=imageWidth, height=imageHeight);         
            }
        }
        arguments.data.returnJsonObjects = "";
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
        var accountProcess = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'login' );
        getHibachiScope().addActionResult( "public:account.login", accountProcess.hasErrors() );
        if (accountProcess.hasErrors()){
            if (getHibachiScope().getAccount().hasErrors()){
                acountProcess.$errors = getHibachiScope().getAccount().getErrors();
            }
            addErrors(data, getHibachiScope().getAccount().getProcessObject("login").getErrors());
        }
        return accountProcess;
    }
    
    /** returns the result of a processObject based action including error information. A form submit.
        This is the default behavior for a POST request to process context /api/scope/process/ */    
    public any function doProcess(required struct data){
        
        if (structKeyExists(data, "processObject")){
            try{
                var processObject = this.invokeMethod(data.processObject,{1=data});
                
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
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'logout' );
        getHibachiScope().addActionResult( "public:account.logout", account.hasErrors() );
        if(account.hasErrors()){
            addErrors(data, getHibachiScope().getAccount().getProcessObject("logout").getErrors());
        }
        arguments.data.ajaxResponse['token'] = '';
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
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'create');

        if(account.hasErrors()){
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject("create").getErrors());
        }

        getHibachiScope().addActionResult( "public:account.create", account.hasErrors() );
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
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'forgotPassword');
        //let's hard code the action to always be successful. Indicating failure exposes if the account exists and is a security issue
        getHibachiScope().addActionResult( "public:account.forgotPassword", false );
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
            var account = getService("AccountService").processAccount(account, data, "resetPassword");
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
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'changePassword');
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
        if(account.hasErrors()){
            var errorStruct = account.getErrors();
            for(var key in errorStruct){
                var messagesArray = errorStruct[key];
                for(var message in messagesArray){
                    getHibachiScope().showMessage(message,"error");
                }
            }
        }
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
    public any function deleteAccountEmailAddress() {
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
    
    public void function addEditAccountAddress(required data){
        if(structKeyExists(data,'accountAddressID') && len(data['accountAddressID'])){
            param name="data.countrycode" default="US";
     	
         	var accountAddress = getService("AccountService").getAccountAddress(data.accountAddressID);
         	if (structKeyExists(data, "accountAddressName")){
         		accountAddress.setAccountAddressName(data.accountAddressName);
         	}
         	var address = accountAddress.getAddress();
         	address = getService("AddressService").saveAddress(address, data, "full");
          	
          	if (!address.hasErrors()){
          		accountAddress.setAddress(address);
          		accountAddress.setAccount(getHibachiScope().getAccount());	
          		var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                getHibachiScope().addActionResult("public:account.addNewAccountAddress", savedAccountAddress.hasErrors());
       	     	if (!savedAccountAddress.hasErrors()){
       	     		getDao('hibachiDao').flushOrmSession();
                    data.accountAddressID = savedAccountAddress.getAccountAddressID();
       	     	}
          	}else{
              this.addErrors(data, address.getErrors());
              getHibachiScope().addActionResult("public:account.addNewAccountAddress", address.hasErrors());
            }
        }else{
            addNewAccountAddress(argumentCollection=arguments);
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
          getHibachiScope().addActionResult("public:account.addNewAccountAddress", savedAccountAddress.hasErrors());
   	     	if (!savedAccountAddress.hasErrors()){
   	     		getDao('hibachiDao').flushOrmSession();
            data.accountAddressID = savedAccountAddress.getAccountAddressID();
   	     	}
      	}else{
          this.addErrors(data, newAddress.getErrors());
          getHibachiScope().addActionResult("public:account.addNewAccountAddress", newAddress.hasErrors());
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
          if(!newAddress.hasErrors()){
  	     	   getService("OrderService").saveOrder(getHibachiScope().getCart());
           }else{
            this.addErrors(data, newAddress.getErrors());
           }
  	     	getHibachiScope().addActionResult( "public:cart.updateAddress", newAddress.hasErrors() ); 
    	}else{
        getHibachiScope().addActionResult( "public:cart.updateAddress", true );
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
                if(structKeyExists(arguments.data, 'orderID')){
                    var order = getOrderService().getOrder(arguments.data.orderID);
                    if(isNull(order) || order.getaccount().getAccountID() != getHibachiScope().getAccount().getAccountID() ){
                        this.addErrors(data, 'Could not find Order');
                        getHibachiScope().addActionResult( "public:cart.addShippingAddress", true);
                        return;
                    }
                }
                var order = getHibachiScope().cart();
                order.setShippingAddress(savedAddress);
                for(var fulfillment in order.getOrderFulfillments()){
                  if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                    var orderFulfillment = fulfillment;
                  }
                }
                if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
                  orderFulfillment.setShippingAddress(savedAddress);
                }
                if (structKeyExists(data, "saveShippingAsBilling") && data.saveShippingAsBilling){
                    order.setBillingAddress(savedAddress);
                }
                
                if (structKeyExists(data, "saveAsAccountAddressFlag") && data.saveAsAccountAddressFlag){
                   
                 	var accountAddress = getService("AccountService").newAccountAddress();
                 	accountAddress.setAddress(shippingAddress);
                 	accountAddress.setAccount(getHibachiScope().getAccount());
                 	var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                 	if (!savedAddress.hasErrors()){
                 		getDao('hibachiDao').flushOrmSession();
                 	}
                  
                }
                
                getService("OrderService").saveOrder(order);
                getHibachiScope().addActionResult( "public:cart.addShippingAddress", order.hasErrors());
                
            }else{
                    
                    this.addErrors(data, savedAddress.getErrors()); //add the basic errors
                    getHibachiScope().addActionResult( "public:cart.addShippingAddress", savedAddress.hasErrors());
            }
        }
    }
    
    /** Adds a shipping address to an order using an account address */
    public void function addShippingAddressUsingAccountAddress(required data){
        if(structKeyExists(data,'accountAddressID')){
          var accountAddressId = data.accountAddressID;
        }else{
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
          return;
        }

        var accountAddress = getService('AddressService').getAccountAddress(accountAddressID);
        if (!isNull(accountAddress) && !accountAddress.hasErrors()){
            //save the address at the order level.
            if(structKeyExists(arguments.data, 'orderID')){
                var order = getOrderService().getOrder(arguments.data.orderID);
                if(isNull(order) || order.getaccount().getAccountID() != getHibachiScope().getAccount().getAccountID() ){
                    this.addErrors(data, 'Could not find Order');
                    getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
                    return;
                }
            }
            var order = getHibachiScope().getCart();
            for(var fulfillment in order.getOrderFulfillments()){
              if(structKeyExists(data,'fulfillmentID') && fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                var orderFulfillment = fulfillment;
                break;
              }else if(!structKeyExists(data,'fulfillmentID')){
                fulfillment.setShippingAddress(accountAddress.getAddress());
                fulfillment.setAccountAddress(accountAddress);
                getService("OrderService").saveOrderFulfillment(fulfillment);
              }
            }
            if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
              orderFulfillment.setShippingAddress(accountAddress.getAddress());
              orderFulfillment.setAccountAddress(accountAddress);
            }
            getService("OrderService").saveOrder(order);
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", order.hasErrors());
        }else{
            if(!isNull(accountAddress)){
              this.addErrors(arguments.data, accountAddress.getErrors()); //add the basic errors
            }
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
        }
    }

    /** Sets an email address for email fulfillment */
    public void function addEmailFulfillmentAddress(required data){
      var emailAddress = data.emailAddress;
      var order = getHibachiScope().getCart();
      var orderFulfillments = order.getOrderFulfillments();

      for(var fulfillment in orderFulfillments){
        if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
          var orderFulfillment = fulfillment;
        }
      }

      if(!isNull(orderFulfillment)){
        orderFulfillment.setEmailAddress(emailAddress);
        orderFulfillment.validate("save");
        if(!orderFulfillment.hasErrors()){

          getService("OrderService").saveOrder(order);
          getDao('hibachiDao').flushOrmSession();
          getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', order.hasErrors());

        }else{
            this.addErrors(arguments.data, orderFulfillment.getErrors());
            entityReload(orderFulfillment);
            getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', orderFulfillment.hasErrors());
        }
      }
    }

    /** Set store pickup location */
    public void function addPickupFulfillmentLocation(required data){
      var locationID = data.value;
      var order = getHibachiScope().getCart();
      var orderFulfillments = order.getOrderFulfillments();

      for(var fulfillment in orderFulfillments){
        if(!isNull(data.fulfillmentID)){
          if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
            var orderFulfillment = fulfillment;
          }
        }else if(fulfillment.getFulfillmentMethod().getFulfillmentMethodType() == 'pickup'){
          var orderFulfillment = fulfillment;
        }
      }

      if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
        orderFulfillment.setPickupLocation(getService('LocationService').getLocation(locationID));
        getService("OrderService").saveOrder(order);
        getDao('hibachiDao').flushOrmSession();
        getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', order.hasErrors());
      }else{
        if(!isNull(orderFulfillment)){
          this.addErrors(arguments.data, orderFulfillment.getErrors());
        }
        getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
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

            var orderFulfillments = order.getOrderFulfillments();
            if (!isNull(data.fulfillmentID)){
              for(var fulfillment in orderFulfillments){
                if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                  var orderFulfillment = fulfillment;
                }
              }
            }else{
            	var orderFulfillment = order.getOrderFulfillments()[orderFulfillmentWithShippingMethodOptions];
            }
            orderFulfillment.setShippingMethod(shippingMethod);
            getService("OrderService").saveOrder(order); 
            getDao('hibachiDao').flushOrmSession();;           
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());          
        }else{
            this.addErrors(arguments.data, shippingMethod.getErrors()); //add the basic errors
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());
        }
        
    }
    
    public any function addBillingAddressUsingAccountAddress(required data){
        var accountAddress = getService('addressService').getAccountAddress(data.accountAddressID);
        
        if(!isNull(accountAddress)){
            getHibachiScope().getCart().setBillingAccountAddress(accountAddress);
            var addressData = {
                address=accountAddress.getAddress()  
            };
        }
        
        return addBillingAddress(addressData);
    }
    
    /** adds a billing address to an order. 
    @ProcessMethod Address_Save
    */
    public any function addBillingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0"; 
        //if we have that data and don't have any suggestions to make, than try to populate the address
        billingAddress = getService('AddressService').newAddress();    
        
        //if we have an address then copy it and validate it
        if(structKeyExists(data,'address')){
            var savedAddress = getService('AddressService').copyAddress(data.address);
            savedAddress = getService('AddressService').saveAddress(savedAddress, {}, "full");    
        //get a new address populated with the data.    
        }else{
            var savedAddress = getService('AddressService').saveAddress(billingAddress, arguments.data, "full");    
        }
        
        if (!isNull(savedAddress) && !savedAddress.hasErrors()){
            //save the address at the order level.
            var order = getHibachiScope().cart();
            order.setBillingAddress(savedAddress);
            
            var orderPayments = order.getOrderPayments();
            if(arrayLen(orderPayments)){
               orderPayments[1].setBillingAddress(savedAddress); 
            }
            
            getService("OrderService").saveOrder(order);
        }
        if(savedAddress.hasErrors()){
              this.addErrors(arguments.data, savedAddress.getErrors()); //add the basic errors
        	    getHibachiScope().addActionResult( "public:cart.addBillingAddress", true);
        }
        return savedAddress;
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
                var newCart = getService("OrderService").duplicateOrderWithNewAccount( getHibachiScope().getCart(), account );
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

        var order = getService("OrderService").getOrder( arguments.data.orderID );
        
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
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
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
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
    }
    
    /** 
     * @http-context cancelSubscriptionUsage
     * @description Subscription Usage - Cancel
     * @http-return <b>(200)</b> Successfully Cancelled or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Cancel
     */
    public void function cancelSubscriptionUsage(required struct data) {
        param name="arguments.data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( arguments.data.subscriptionUsageID );
        
        if(!structKeyExists(arguments.data,'effectiveDateTime')){
            arguments.data.effectiveDateTime = subscriptionUsage.getExpirationDate();
        }
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'cancel' );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.cancelSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.cancelSubscriptionUsage", true );
        }
    }
    
    /** exposes the cart and account */
    public void function getCartData(any data) {
        if(!structKeyExists(arguments.data,'cartDataOptions') || !len(arguments.data['cartDataOptions'])){
            arguments.data['cartDataOptions']='full';
        }
    
        arguments.data.ajaxResponse = getHibachiScope().getCartData(cartDataOptions=arguments.data['cartDataOptions']);
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
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            
            var data = {
                saveNewFlag=true,
                copyPersonalDataFlag=true
            };
            
            var duplicateOrder = getService("OrderService").processOrder(order,data,"duplicateOrder" );
            
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

        var cart = getService("OrderService").saveOrder( getHibachiScope().cart(), arguments.data );
        
        // Insure that all items in the cart are within their max constraint
        if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
            cart = getService("OrderService").processOrder(cart, 'forceItemQuantityUpdate');
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
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'clear');
        
        getHibachiScope().addActionResult( "public:cart.clear", cart.hasErrors() );
    }
    
    /** 
     * @http-context changeOrder
     * @description Change Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function changeOrder( required struct data ){
        param name="arguments.data.orderID" default="";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
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
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            var deleteOk = getService("OrderService").deleteOrder(order);
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
    	param name="data.quantities" default="";
    	
    	//add skuids
		var index = 1;
		var hasSkuCodes = false;
		
		//get the quantities being added
		if (structKeyExists(data, "quantities") && len(data.quantities)){
			var quantities = listToArray(data.quantities);
		}
		
		//get the skus being added
		if (structKeyExists(data, "skuIds") && len(data.skuIds)){
			var skus = listToArray(data.skuIds);
		}
		
		//get the skuCodes if they exist.
		if (structKeyExists(data, "skuCodes") && len(data.skuCodes)){
			var skus = listToArray(data.skuCodes);
			hasSkuCodes = true;
		}
		
		//if we have both skus and quantities, add them.
		if (!isNull(skus) && !isNull(quantities) && arrayLen(skus) && arrayLen(quantities)){
			if (arrayLen(skus) == arrayLen(quantities)){
				//we have a quantity fo each sku.
				for (var sku in skus){
					//send that sku and that quantity.
					if (hasSkuCodes == true){
						data["skuCode"]=sku; 
					}else{
						data["skuID"]=sku; 	
					}
	    			
	    			data["quantity"]=quantities[index];
	    			addOrderItem(data=data);
	    			index++;
	    		}
			}
		
		//If they did not pass in quantities, but we have skus, assume 1 for each quantity.
		}else if(!isNull(skus)){
    		for (var sku in skus){
    			if (hasSkuCodes == true){
					data["skuCode"]=sku; 
				}else{
					data["skuID"]=sku; 	
				}
    			data["quantity"]=1;
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
        
        cart = getService("OrderService").processOrder( cart, arguments.data, 'addOrderItem');
        
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
    
    /* @http-context updateOrderNotes
     * @description Set shipping instructions for order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateOrderNotes(required any data) {
        param name="arguments.data.orderNotes" default="";
        var cart = getHibachiScope().getCart();
        cart.setOrderNotes(arguments.data.orderNotes);
        getHibachiScope().addActionResult( "public:cart.updateOrderNotes", cart.hasErrors() );
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
        
        if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "orderItemID") && structKeyExists(data.orderItem, "quantity")){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getOrderItemID() == data.orderItem.orderItemID){
                    orderItem.setQuantity(data.orderItem.quantity);
                }
            }
		}else if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "sku") && structKeyExists(data.orderItem.sku, "skuID") && structKeyExists(data.orderItem, "qty") ){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getSku().getSkuID() == data.orderItem.sku.skuID){
                    orderItem.setQuantity(data.orderItem.qty);
                }
            }
        }
        
        if(!cart.hasErrors()) {
            //Persist the quantity change
            getService("OrderService").saveOrder(cart);
            
            // Insure that all items in the cart are within their max constraint
     	    	if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
    	 	        cart = getService("OrderService").processOrder(cart, 'forceItemQuantityUpdate');
    	 	    } 
    	 	    
    	 	    if(!cart.hasErrors()) {
              getService("OrderService").saveOrder(cart);
            }
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
            
        }else{
            addErrors(data, getHibachiScope().getCart().getErrors());
        }
		  getHibachiScope().addActionResult( "public:cart.updateOrderItem", cart.hasErrors() );
    }
    /** 
     * @http-context removeOrderItem
     * @description Remove Order Item from an Order
     * @http-return <b>(200)</b> Successfully Removed or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_RemoveOrderItem
     */
    public void function removeOrderItem(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderItem');
        if(!arraylen(cart.getOrderItems())){
            clearOrder(arguments.data);
        }
        getHibachiScope().addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderFulfillment
     * @description Update Order Fulfillment 
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      @ProcessMethod Order_UpdateOrderFulfillment
     */
    public void function updateOrderFulfillment(required any data) {
        param name="orderID" default="#getHibachiScope().getCart().getOrderID()#";
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'updateOrderFulfillment');
        
        getHibachiScope().addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
    }


    /** 
     * @http-context updateOrderFulfillmentAddressZone
     * @description Update Order Fulfillment Address Zone
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Order_UpdateOrderFulfillmentAddressZone
     */
    public any function updateOrderFulfillmentAddressZone(required any data) {
        
        var orderFulfillments = getHibachiScope().cart().getOrderFulfillments();
        //Find a shipping fulfillment.    
        for (var of in orderFulfillments){
            if (of.getFulfillmentMethodType() == "shipping"){
                var orderFulfillment = of; break;
            }
        }  
        
        if (structKeyExists(data, "addressZoneCode")){
            var addressZone = getService("AddressService").getAddressZoneByAddressZoneCode(data.addressZoneCode);
        }     
        
        if (!isNull(orderFulfillment) && !isNull(addressZone)){
            orderFulfillment.setAddressZone(addressZone);
            orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment);
            getService("ShippingService").updateOrderFulfillmentShippingMethodOptions(orderFulfillment);
            getHibachiScope().addActionResult( "public:cart.updateOrderFulfillmentAddressZone", false);
        } else {  
			getHibachiScope().addActionResult( "public:cart.updateOrderFulfillmentAddressZone", true);
        }
    }

    /** 
     * @http-context addPromotionCode
     * @description Add Promotion Code
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_addPromotionCode
     */
    public void function addPromotionCode(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'addPromotionCode');
        
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
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'removePromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
    }

    /** 
     * @http-context addGiftCardOrderPayment
     * @description Add Gift Card to Order
     @ProcessMethod Order_AddOrderPayment
     */
    public void function addGiftCardOrderPayment(required any data) {
        param name="data.newOrderPayment.paymentMethod.paymentMethodID" default="50d8cd61009931554764385482347f3a";
        param name="data.newOrderPayment.redeemGiftCardToAccount" default=true;
        param name="data.copyFromType" default="";
        param name="data.newOrderPayment.requireBillingAddress" default="0";
        var addOrderPayment = addOrderPayment(data, true);
        if(addOrderPayment.hasErrors()){
          addErrors(data, addOrderPayment.getProcessObject('addOrderPayment').getErrors());
        }
        getHibachiScope().addActionResult('public:cart.addGiftCardOrderPayment', addOrderPayment.hasErrors());
    }
    
    /** 
     * @http-context addOrderPayment
     * @description Add Order Payment
     @ProcessMethod Order_AddOrderPayment
     */
    public any function addOrderPayment(required any data, boolean giftCard = false) {
        param name = "data.newOrderPayment" default = "#structNew()#";
        param name = "data.newOrderPayment.orderPaymentID" default = "";
        param name = "data.newOrderPayment.requireBillingAddress" default = "1";
        param name = "data.newOrderPayment.saveShippingAsBilling" default = "0";
        param name = "data.accountAddressID" default = "";
        param name = "data.accountPaymentMethodID" default = "";
        param name = "data.newOrderPayment.paymentMethod.paymentMethodID" default = "444df303dedc6dab69dd7ebcc9b8036a";
        param name = "data.orderID" default = "";

        //Make sure orderID passed in belongs to logged in account
        var accountID = getHibachiScope().getAccount().getAccountID();
        if (len(data.orderID)) {
            if (isNull(accountID) || !len(accountID) || accountID != getOrderService().getOrder(data.orderID).getAccount().getAccountID()) {
                data.orderID = '';
            }
        }
        
        if (len(data.orderID)) {
            var order = getOrderService().getOrder(orderID);
        }
        else {
            var order = getHibachiScope().getCart();
        }

        if (structKeyExists(data, 'accountAddressID') && len(data.accountAddressID)) {
            var paymentMethod = getPaymentService().getPaymentMethod(data.newOrderPayment.paymentMethod.paymentMethodID);
            if(!isNull(paymentMethod) && paymentMethod.getPaymentMethodType() == 'termPayment'){
                data.newOrderPayment.termPaymentAccount.accountID = getHibachiScope().getAccount().getAccountID();
            }
            var accountAddress = getService('addressService').getAccountAddress(data.accountAddressID);
            var addOrderPayment = getService('OrderService').processOrder(order, arguments.data, 'addOrderPayment');
            for (var payment in addOrderPayment.getOrderPayments()) {
                addErrors(data, payment.getErrors());
            }
            getHibachiScope().addActionResult("public:cart.addOrderPayment", addOrderPayment.hasErrors());
            return addOrderPayment;
        }

        if (structKeyExists(data.newOrderPayment, 'billingAddress') && structKeyExists(data.newOrderPayment.billingAddress, 'accountAddressID')) {
            data.accountAddressID = data.newOrderPayment.billingAddress.accountAddressID;
        }


        // Make sure that someone isn't trying to pass in another users orderPaymentID
        if (len(data.newOrderPayment.orderPaymentID)) {
            var orderPayment = getService("OrderService").getOrderPayment(data.newOrderPayment.orderPaymentID);
            if (orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                data.newOrderPayment.orderPaymentID = "";
            }
        }


        if (data.newOrderPayment.requireBillingAddress || data.newOrderPayment.saveShippingAsBilling) {
            if (!structKeyExists(data.newOrderPayment, 'billingAddress')) {

                var orderPayment = getPaymentService().newOrderPayment();
                orderPayment.populate(data.newOrderPayment);
                orderPayment.setOrder(getHibachiScope().getCart());
                if (orderPayment.getPaymentMethod().getPaymentMethodType() == 'termPayment') {
                    orderPayment.setTermPaymentAccount(getHibachiScope().getAccount());
                }
                //Add billing address error
                orderPayment.addError('addBillingAddress', getHibachiScope().rbKey('validate.processOrder_addOrderPayment.billingAddress'));
                //Validate to get all errors
                orderPayment.validate('save');

                this.addErrors(data, orderPayment.getErrors());

                getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                return;
            }
            //use this billing information
            var newBillingAddress = this.addBillingAddress(data.newOrderPayment.billingAddress, "billing");
        }

        if (!isNull(newBillingAddress) && newBillingAddress.hasErrors()) {
            this.addErrors(arguments.data, newBillingAddress.getErrors());
            return;
        }

        
        var addOrderPayment = getService('OrderService').processOrder(order, arguments.data, 'addOrderPayment');

        if (!giftCard) {
            for (var payment in addOrderPayment.getOrderPayments()) {
                addErrors(data, payment.getErrors());
            }
            getHibachiScope().addActionResult("public:cart.addOrderPayment", addOrderPayment.hasErrors());
        }
        return addOrderPayment;
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
        var cart = getHibachiScope().getCart();
        cart = getService("OrderService").processOrder( cart, arguments.data, 'removeOrderPayment');
        
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
            getService("OrderService").processOrder(getHibachiScope().cart(), 'forceItemQuantityUpdate');
            getHibachiScope().addActionResult( "public:cart.placeOrder", true );
        } else {
            // Setup newOrderPayment requirements
            if(structKeyExists(data, "newOrderPayment")) {
                param name="data.newOrderPayment.orderPaymentID" default="";
                param name="data.accountAddressID" default="";
                param name="data.accountPaymentMethodID" default="";

                // Make sure that someone isn't trying to pass in another users orderPaymentID
                if(len(data.newOrderPayment.orderPaymentID)) {
                    var orderPayment = getService("OrderService").getOrderPayment(data.newOrderPayment.orderPaymentID);
                    if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                        data.newOrderPayment.orderPaymentID = "";
                    }
                }
                
                data.newOrderPayment.order.orderID = getHibachiScope().cart().getOrderID();
                data.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
            }
            
            var order = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'placeOrder');

            getHibachiScope().addActionResult( "public:cart.placeOrder", order.hasErrors() );
            
            if(!order.hasErrors()) {
                getHibachiScope().setSessionValue('confirmationOrderID', order.getOrderID());
                getHibachiScope().getSession().setLastPlacedOrderID( order.getOrderID() );
            }else{
              this.addErrors(data,order.getErrors());
            }
            if(getHibachiScope().getAccount().getGuestAccountFlag()){
                getHibachiScope().getSession().removeAccount();
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
        var cacheKey = "PublicService.getStateCodeOptionsByCountryCode#arguments.data.countryCode#";
        var stateCodeOptions = [];
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
        	stateCodeOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
        	var country = getAddressService().getCountry(data.countryCode);
        	stateCodeOptions = country.getStateCodeOptions();
        	getHibachiCacheService().setCachedValue(cacheKey,stateCodeOptions);
        }
        
         arguments.data.ajaxResponse["stateCodeOptions"] = stateCodeOptions;
        //get the address options.
        if (!isNull(arguments.data.countryCode)){
          getAddressOptionsByCountryCode(arguments.data);
        }
    }
    
    public void function getStateCodeOptionsByAddressZoneCode( required struct data ) {
        if(!structKeyExists(data,addressZoneCode) || data.addressZoneCode == 'undefined'){
            data.addressZoneCode = 'US';
        }
        var addressZoneLocations = getAddressService().getAddressZoneByAddressZoneCode('US').getAddressZoneLocations();
        cacheKey = "PublicService.getStateCodeOptionsByAddressZoneCode#arguments.data.addressZoneCode#";
        stateCodeOptions = "";
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
            stateCodeOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
            for(var addressZoneLocation in addressZoneLocations){
                stateCodeOptions = listAppend(stateCodeOptions,addressZoneLocation.getStateCode());
            }
            getHibachiCacheService().setCachedValue(cacheKey,stateCodeOptions);
        }
          arguments.data.ajaxResponse["stateCodeOptions"] = listSort(stateCodeOptions,'text');
    }
    
    /** Given a country - this returns all of the address options for that country */
    public void function getAddressOptionsByCountryCode( required data ) {
        param name="data.countryCode" type="string" default="US";
        
        var addressOptions = {};
        var cacheKey = 'PublicService.getAddressOptionsByCountryCode#arguments.data.countryCode#';
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
          addressOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
          var country = getAddressService().getCountry(data.countryCode);
          addressOptions = {
            
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
          getHibachiCacheService().setCachedValue(cacheKey,addressOptions);
        }
        arguments.data.ajaxResponse["addressOptions"] = addressOptions;
        
    }
    
    /** returns the list of country code options */
     public void function getCountries( required struct data ) {
        arguments.data.ajaxResponse['countryCodeOptions'] = getService('HibachiCacheService').getOrCacheFunctionValue('PublicService.getCountries',getAddressService(),'getCountryCodeOptions');
    }
    
    /** Given a skuCode, returns the estimated shipping rates for that sku. */
    public any function getEstimatedShippingCostBySkuCode(any data){
    	if (!isNull(data.skuCode)){
    		
    		//data setup.
    		var orderFulfillment = getService("OrderService").newOrderFulfillment();
    		var orderItem = getService("OrderService").newOrderItem();
    		var sku = getService("SkuService").getSkuBySkuCode(data.skuCode);
    		
    		//set the sku so we have data for the rates.
    		orderItem.setSku(sku);
    		var shippingMethodOptions = [];
    		
    		//set the order so it doesn't stall when updating options.
    		orderFulfillment.setOrder(getHibachiScope().getCart());
    		
    		var eligibleFulfillmentMethods = listToArray(sku.setting("skuEligibleFulfillmentMethods"));
    		
    		var options = {};
    		
    		//iterate through getting the options.
    		for (var eligibleFulfillmentMethod in eligibleFulfillmentMethods){
    			//get the fulfillment methods for this item.
    			var fulfillmentMethod = getService("FulfillmentService").getFulfillmentMethod(eligibleFulfillmentMethod);
    			if (!isNull(fulfillmentMethod) &&!isNull(fulfillmentMethod.getFulfillmentMethodType()) &&  fulfillmentMethod.getFulfillmentMethodType() == "shipping"){
    				
    				//set the method so we can update with the options.
    				orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
    				getService("ShippingService").updateOrderFulfillmentShippingMethodOptions(orderFulfillment);
    				if (!isNull(orderFulfillment.getShippingMethodOptions())){
    					for (var rate in orderFulfillment.getShippingMethodOptions()){
    						options['#rate.shippingMethodCode#'] = rate;
    					}
    				}
    			}
    		}
    		
    		//remove the orderfulfillment that we used to get the rates because it will disrupt other entities saving.
    		getService("OrderService").deleteOrderFulfillment(orderFulfillment);
    		data['ajaxResponse']['estimatedShippingRates'] = options;
    	}
    }
    
    public void function getSkuPriceByQuantity(required any data){
        if(isNull(arguments.data.skuID)){
            addErrors(arguments.data, [{'skuID':"Error retrieving price; skuID is required."}]);
        }
        if(isNull(arguments.data.quantity) || !isNumeric(arguments.data.quantity)){
            arguments.data.quantity = 1;
        }
        if(isNull(arguments.data.currencyCode)){
            arguments.data.currencyCode = 'USD';
        }
        
        var sku = getSkuService().getSku(arguments.data.skuID);
        data['ajaxResponse']['price'] = sku.getPriceByCurrencyCode(arguments.data.currencyCode, arguments.data.quantity);
    }
    
}
