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
component extends="HibachiService" accessors="true" output="false" hint="Contains all public API scope contexts"
{
	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="userUtility" type="any";
	property name="paymentService" type="any";
	property name="subscriptionService" type="any";
	property name="hibachiSessionService" type="any";
	property name="productService" type="any";
	property name="hibachiAuditService" type="any";
	property name="validationService" type="any";
	

	variables.publicContexts = [];
	variables.responseType = "json";
	
	/** A description of each method in this public service */
	ArrayAppend(variables.publicContexts, {Name="Account", Description="Returns the account associated with the authentication token"});
	ArrayAppend(variables.publicContexts, {Name="SubscriptionUsage", Description="Returns the subscription usage associated with the authentication token."});
	ArrayAppend(variables.publicContexts, {Name="Order", Description="Returns the order usage associated with the authentication token."});
	ArrayAppend(variables.publicContexts, {Name="Login", Description="Login a user account."});
	ArrayAppend(variables.publicContexts, {Name="Logout", Description="Logout a user account."});
	
	/* Gets API request data */
	public any function geAPIRequestData() {
		var headers = getHTTPRequestData();
		return headers.headers;
	}
	
	/* Sets if this is an API request */
	public any function setIsAPIRequest(truthValue) {
		variables.isAPIRequest = arguments.truthValue;
	}
	
	/** Returns a JSON list of all public contexts available to this request. */
	any function getPublicContexts( required struct rc ) {
		setResponse(true, 200, variables.publicContexts, arguments.rc, true);
		return "";
	}
	
	/** 
	 @method Login <b>Log a user account into Slatwall given the users emailAddress and password</b>
	 @http-context <b>Login</b> Use this context in conjunction with the listed http-verb to use this resource.
	 @http-verb POST
	 @http-return <b>(200)</b> Request Successful, <b>(400)</b> Bad or Missing Input Data
	 @description <p>Logs a user into a Slatwall account</p>
	 @param Required Header: emailAddress
	 @param Required Header: password
	 @description 
	 					<p>
	 						   Use this context to log a user into Slatwall. The required email address should be sent
							   bundled in a Basic Authorization header with the emailAddress and password 
							   appended together using an colon and then converted to base64.
						</p>
		<p>Example:</p>
		testuser@slatwalltest.com:Vah7cIxXe would become dGVzdHVzZXJAc2xhdHdhbGx0ZXN0LmNvbTpWYWg3Y0l4WGU=
						
	 */
	any function login( required struct rc ){
		//If this is an api request, decode the basic auth heading and put the email and password back into request context.
		if (arguments.rc.APIRequest){
			//Check for the basic auth heading
			try {
				if (StructKeyExists(arguments.rc.requestHeaderData.headers, "authorization")){
					var plaintextArray = ListToArray( ToString( ToBinary( arguments.rc.requestHeaderData.headers.authorization ) ), ":" );
					var email = plaintextArray[1];
					var password = plaintextArray[2];
					arguments.rc["emailAddress"] = email;
					arguments.rc["password"] = password;
				}
			} catch (any e){
				addDataToResponse("errors", "Unable to decode Basic Authorization Header to usable data", arguments.rc);		
			}
		}
		//Login the user
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'login' );
		arguments.rc.$.slatwall.addActionResult( "public:account.login", account.hasErrors() );
		
		//If this is a request from the api, setup the response header and populate it with data.
		//any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct rc
		handlePublicAPICall(200, 400, account, arguments.rc.$.slatwall.invokeMethod("getAccountData"), getHibachiScope().getSession().getSessionCookieNPSID(),  arguments.rc);
		return account;
	}	

	/** 
	 * @method Logout <b>Log a user account outof Slatwall given the users request_token and deviceID</b>
	 * @http-context <b>Logout</b> Use this context in conjunction with the listed http-verb to use this resource.
	 * @http-verb POST
	 * @http-return <b>(200)</b> Request Successful <b>(400)</b> Bad or Missing Input Data
	 * @description <p>Logs a user out of the given device</p>
	 * @param Required Header: request_token
	 * @param Required Header: deviceID
	 */
	any function logout( required struct rc ){ 
		
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'logout' );
		arguments.rc.$.slatwall.addActionResult( "public:account.logout", false );

		//any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct rc
		handlePublicAPICall(200, 500, account, arguments.rc.$.slatwall.invokeMethod("getAccountData"), "Logout Successful",  arguments.rc);
		return account;
	}	
	
	/** 
	 *	@method CreateAccount
	 *	@rest-context <b>CreateAccount</b> Use this context in conjunction with the listed http-verb to use this resource.
	 *	@http-verb POST
	 *	@description <p>CreateAccount Creates a new user account.</p>
	 *	@return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
	 *	@param firstName {string}
	 *	@param Header: firstName {string}
	 *	@param Header: lastName {string}
	 *	@param Header: company {string}
	 *	@param Header: phone {string}
	 *	@param Header: emailAddress {string}
	 *	@param Header: emailAddressConfirm {string}
	 *	@param Header: createAuthenticationFlag {string}
	 *	@param Header: password {string}
	 *	@param Header: passwordConfirm {string}
	 */
	public any function createAccount( required struct rc ) {
		param name="arguments.rc.createAuthenticationFlag" default="1";
		
		//If sending through headers, use those headers.
		if (arguments.rc.APIRequest && StructKeyExists(arguments.rc.requestHeaderData.headers, "emailAddress")){
			try {
			arguments.rc["firstName"] = arguments.rc.requestHeaderData.headers.lastName;
			arguments.rc["lastName"] = arguments.rc.requestHeaderData.headers.lastName;
			arguments.rc["company"] = arguments.rc.requestHeaderData.headers.company;
			arguments.rc["phone"] = arguments.rc.requestHeaderData.headers.phone;
			arguments.rc["emailAddress"] = arguments.rc.requestHeaderData.headers.emailAddress;
			arguments.rc["emailAddressConfirm"] = arguments.rc.requestHeaderData.headers.emailAddressConfirm;
			arguments.rc["password"] = arguments.rc.requestHeaderData.headers.password;
			arguments.rc["passwordConfirm"] = arguments.rc.requestHeaderData.headers.passwordConfirm;
			arguments.rc["createAuthenticationFlag"] = arguments.rc.requestHeaderData.headers.createAuthenticationFlag;
			} catch (any e){
				
			}
		}
		
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'create');
		arguments.rc.$.slatwall.addActionResult( "public:account.create", account.hasErrors() );
		
		//If this is a request from the api, setup the response header and populate it with data.
		//any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct rc
		handlePublicAPICall(201, 400, account, arguments.rc.$.slatwall.invokeMethod("getAccountData"), "",  arguments.rc);
		return account;
	}
	
	public any function createDeviceID( required struct rc ){
		param name="arguments.rc.deviceID" default="";
		param name="arguments.rc.header.request_token" default="";

		var sessionEntity = getService("HibachiSessionService").getSessionBySessionCookieNPSID( arguments.rc.header.request_token, true );
		sessionEntity.setDeviceID(arguments.rc.header.deviceID);
		
		//If this is a request from the api, setup the response header and populate it with data.
		//any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct rc
		handlePublicAPICall(201, 400, account, arguments.rc.$.slatwall.invokeMethod("getAccountData"), "",  arguments.rc);
		return "_createDevice";
		
	}
	
	
	/**
	  *	@method forgotPassword
	  *	@rest-context <b>ForgotPassword</b> Use this context in conjunction with the listed http-verb to use this resource.
	  *	@http-verb POST
	  *	@description <p>Sends an email to a user to reset a password.</p>
	  *	@return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
	  *	@param emailAddress {string}
	  **/
    public any function forgotPassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'forgotPassword');
		arguments.rc.$.slatwall.addActionResult( "public:account.forgotPassword", account.hasErrors() );
		
		//If this is a request from the api, setup the response header and populate it with data.
		//any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct rc
		handlePublicAPICall(200, 400, account, "Forgotten Password Email Sent", "",  arguments.rc);
		return true;
		
	}
	
	/**
	  *	@method resetPassword
	  *	@rest-context <b>resetPassword</b> Use this context in conjunction with the listed http-verb to use this resource.
	  *	@http-verb POST
	  *	@description <p>Sends an email to a user to reset a password.</p>
	  *	@return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
	  *	@param accountID {string}
	  * @param emailAddress {string}
	  **/
	public any function resetPassword( required struct rc ) {
		param name="rc.accountID" default="";
		var account = getAccountService().getAccount( rc.accountID );
		if(!isNull(account)) {
			var account = getAccountService().processAccount(account, rc, "resetPassword");
			arguments.rc.$.slatwall.addActionResult( "public:account.resetPassword", account.hasErrors() );	
			// As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
			if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
				form.emailAddress = account.getEmailAddress();
			}
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.resetPassword", true );
		}
		// Populate the current account with this processObject so that any errors are there.
		arguments.rc.$.slatwall.account().setProcessObject( account.getProcessObject( "resetPassword" ) );
	}
	
	/**
	  *	@method changePassword
	  *	@rest-context <b>changePassword</b> Use this context in conjunction with the listed http-verb to use this resource.
	  *	@http-verb POST
	  *	@description <p>Change a users password.</p>
	  *	@return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
	  *	@param emailAddress {string}
	  **/
	public any function changePassword( required struct rc ) {
		
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'changePassword');
		arguments.rc.$.slatwall.addActionResult( "public:account.changePassword", account.hasErrors() );
	
	}
	
	/**
	  *	@method updateAccount
	  *	@rest-context <b>updateAccount</b> Use this context in conjunction with the listed http-verb to use this resource.
	  *	@http-verb POST
	  *	@description <p>Update a users account data.</p>
	  *	@return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
	  *	@param emailAddress {string}
	  **/
	public any function updateAccount( required struct rc ) {
		
		var account = getAccountService().saveAccount( rc.$.slatwall.getAccount(), arguments.rc );
		arguments.rc.$.slatwall.addActionResult( "public:account.update", account.hasErrors() );
		
		handlePublicAPICall(200, 400, account, arguments.rc.$.slatwall.invokeMethod("getAccountData"), "",  arguments.rc);
		return true;
		
	}
	
	/**
	  *	@method deleteAccountEmailAddress
	  *	@rest-context <b>deleteAccountEmailAddress</b> Use this context in conjunction with the listed http-verb to use this resource.
	  *	@http-verb POST
	  *	@description <p>delete a users account email address </p>
	  *	@return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
	  *	@param emailAddress {string}
	  **/
	public void function deleteAccountEmailAddress() {
		param name="rc.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountEmailAddress", true );	
		}
	}
	
	/** Account Email Address - Send Verification Email */
	public void function sendAccountEmailAddressVerificationEmail() {
		param name="rc.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
			accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, rc, 'sendVerificationEmail' );
			arguments.rc.$.slatwall.addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", accountEmailAddress.hasErrors() );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", true );
		}
	}
	
	/** Account Email Address - Verify */
	public void function verifyAccountEmailAddress() {
		param name="rc.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress)) {
			accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, rc, 'verify' );
			arguments.rc.$.slatwall.addActionResult( "public:account.verifyAccountEmailAddress", accountEmailAddress.hasErrors() );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.verifyAccountEmailAddress", true );
		}
	}
	
	/** Account Phone Number - Delete */
	public void function deleteAccountPhoneNumber() {
		param name="rc.accountPhoneNumberID" default="";
		
		var accountPhoneNumber = getAccountService().getAccountPhoneNumber( rc.accountPhoneNumberID );
		
		if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPhoneNumber", true );	
		}
	}
	
	/** Account Address - Delete */
	public void function deleteAccountAddress() {
		param name="rc.accountAddressID" default="";
		
		var accountAddress = getAccountService().getAccountAddress( rc.accountAddressID );
		
		if(!isNull(accountAddress) && accountAddress.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountAddress", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountAddress", true );	
		}
	}
	
	/** Account Payment Method - Delete */
	public void function deleteAccountPaymentMethod() {
		param name="rc.accountPaymentMethodID" default="";
		
		var accountPaymentMethod = getAccountService().getAccountPaymentMethod( rc.accountPaymentMethodID );
		
		if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.deleteAccountPaymentMethod", true );	
		}
	}
	
	/** Account Payment Method - Add */
	public void function addAccountPaymentMethod() {
		
		if(arguments.rc.$.slatwall.getLoggedInFlag()) {
			
			// Force the payment method to be added to the current account
			var accountPaymentMethod = arguments.rc.$.slatwall.getAccount().getNewPropertyEntity( 'accountPaymentMethods' );
			
			accountPaymentMethod.setAccount( arguments.rc.$.slatwall.getAccount() );
			
			accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.rc );
			
			arguments.rc.$.slatwall.addActionResult( "public:account.addAccountPaymentMethod", accountPaymentMethod.hasErrors() );
			
			// If there were no errors then we can clear out the
			
		} else {
			
			arguments.rc.$.slatwall.addActionResult( "public:account.addAccountPaymentMethod", true );
				
		}
		
	}
	
	/** Guest Account */
	public void function guestAccount(required any rc) {
		param name="arguments.rc.createAuthenticationFlag" default="0";
		
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'create');
		
		if( !account.hasErrors() ) {
			if( !isNull(rc.$.slatwall.getCart().getAccount())) {
				var newCart = getOrderService().duplicateOrderWithNewAccount( rc.$.slatwall.getCart(), account );
				rc.$.slatwall.getSession().setOrder( newCart );
			} else {
				rc.$.slatwall.getCart().setAccount( account );	
			}
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestCheckout", false );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestCheckout", true );	
		}
		
	}
	
	/** Save Guest Account */
	public void function guestAccountCreatePassword( required struct rc ) {
		param name="arguments.rc.orderID" default="";
		param name="arguments.rc.accountID" default="";

		var order = getOrderService().getOrder( arguments.rc.orderID );
		
		// verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
		if(!isNull(order) && arguments.rc.orderID == arguments.rc.$.slatwall.getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.rc.accountID && order.getAccount().getGuestAccountFlag()) {
			
			var account = getAccountService().processAccount( order.getAccount(), arguments.rc, "createPassword" );
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestAccountCreatePassword", account.hasErrors() );
			
		} else {
			
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestAccountCreatePassword", true );
		}
		
	}
	
	/** Subscription Usage - Update */
	public void function updateSubscriptionUsage() {
		param name="rc.subscriptionUsageID" default="";
		
		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( rc.subscriptionUsageID );
		
		if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.rc );
			arguments.rc.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
			
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", true );
		}
	}
	
	/** Subscription Usage - Renew */
	public void function renewSubscriptionUsage() {
		param name="rc.subscriptionUsageID" default="";
		
		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( rc.subscriptionUsageID );
		
		if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID() ) {
			var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.rc, 'renew' );
			arguments.rc.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
			
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.updateSubscriptionUsage", true );
		}
	}
	
	/** Duplicate - Order */
	public void function duplicateOrder() {
		param name="arguments.rc.orderID" default="";
		param name="arguments.rc.setAsCartFlag" default="0";
		
		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID()) {
			
			var data = {
				saveNewFlag=true,
				copyPersonalDataFlag=true
			};
			
			var duplicateOrder = getOrderService().processOrder(order,data,"duplicateOrder" );
			
			if(isBoolean(arguments.rc.setAsCartFlag) && arguments.rc.setAsCartFlag) {
				arguments.rc.$.slatwall.getSession().setOrder( duplicateOrder );
			}
			arguments.rc.$.slatwall.addActionResult( "public:account.duplicateOrder", false );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:account.duplicateOrder", true );
		}
	}
	
	/** Update Cart */
	public void function updateOrder( required struct rc ) {
		var cart = getOrderService().saveOrder( rc.$.slatwall.cart(), arguments.rc );
		
		// Insure that all items in the cart are within their max constraint
		if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
			cart = getOrderService().processOrder(cart, 'forceItemQuantityUpdate');
		}
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.update", cart.hasErrors() );
	}
	
	/** Clear */
	public void function clearOrder( required struct rc ) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'clear');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.clear", cart.hasErrors() );
	}
	
	/** Change */
	public void function changeOrder( required struct rc ){
		param name="arguments.rc.orderID" default="";
		
		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID()) {
			arguments.rc.$.slatwall.getSession().setOrder( order );
			arguments.rc.$.slatwall.addActionResult( "public:cart.change", false );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.change", true );
		}
	}
	
	/** Delete */
	public void function deleteOrder( required struct rc ) {
		param name="arguments.rc.orderID" default="";
		
		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID()) {
			var deleteOk = getOrderService().deleteOrder(order);
			arguments.rc.$.slatwall.addActionResult( "public:cart.delete", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.delete", true );
		}
	}
	
	/** Add Order Item */
	public void function addOrderItem(required any rc) {
		// Setup the frontend defaults
		param name="rc.preProcessDisplayedFlag" default="true";
		param name="rc.saveShippingAccountAddressFlag" default="false";
		
		var cart = rc.$.slatwall.cart();
		
		// Check to see if we can attach the current account to this order, required to apply price group details
		if( isNull(cart.getAccount()) && rc.$.slatwall.getLoggedInFlag() ) {
			cart.setAccount( rc.$.slatwall.getAccount() );
		}
		
		cart = getOrderService().processOrder( cart, arguments.rc, 'addOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
		
		if(!cart.hasErrors()) {
			// If the cart doesn't have errors then clear the process object
			cart.clearProcessObject("addOrderItem");
			
			// Also make sure that this cart gets set in the session as the order
			rc.$.slatwall.getSession().setOrder( cart );
			
			// Make sure that the session is persisted
			getHibachiSessionService().persistSession();
			
		}
	}
	
	/** Remove Order Item */
	public void function removeOrderItem(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'removeOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
	}
	
	/** Update Order Fulfillment */
	public void function updateOrderFulfillment(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'updateOrderFulfillment');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
	}
	
	/** Add Promotion Code */
	public void function addPromotionCode(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addPromotionCode');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );
		
		if(!cart.hasErrors()) {
			cart.clearProcessObject("addPromotionCode");
		}
	}
	
	/** Remove Promotion Code */
	public void function removePromotionCode(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'removePromotionCode');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
	}
	
	/** Add Order Payment */
	public void function addOrderPayment(required any rc) {
		param name="rc.newOrderPayment" default="#structNew()#";
		param name="rc.newOrderPayment.orderPaymentID" default="";
		param name="rc.accountAddressID" default="";
		param name="rc.accountPaymentMethodID" default="";
		
		// Make sure that someone isn't trying to pass in another users orderPaymentID
		if(len(rc.newOrderPayment.orderPaymentID)) {
			var orderPayment = getOrderService().getOrderPayment(rc.newOrderPayment.orderPaymentID);
			if(orderPayment.getOrder().getOrderID() != rc.$.slatwall.cart().getOrderID()) {
				rc.newOrderPayment.orderPaymentID = "";
			}
		}
		
		rc.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
		rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
		
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addOrderPayment');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderPayment", cart.hasErrors() );
	}
	
	/** Remove Order Payment */
	public void function removeOrderPayment(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'removeOrderPayment');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.removeOrderPayment", cart.hasErrors() );
	}
	
	/** Place Order */
	public void function placeOrder(required any rc) {
		
		// Insure that all items in the cart are within their max constraint
		if(!rc.$.slatwall.cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getOrderService().processOrder(rc.$.slatwall.cart(), 'forceItemQuantityUpdate');
			arguments.rc.$.slatwall.addActionResult( "public:cart.placeOrder", true );
		} else {
			// Setup newOrderPayment requirements
			if(structKeyExists(rc, "newOrderPayment")) {
				param name="rc.newOrderPayment.orderPaymentID" default="";
				param name="rc.accountAddressID" default="";
				param name="rc.accountPaymentMethodID" default="";
				
				// Make sure that someone isn't trying to pass in another users orderPaymentID
				if(len(rc.newOrderPayment.orderPaymentID)) {
					var orderPayment = getOrderService().getOrderPayment(rc.newOrderPayment.orderPaymentID);
					if(orderPayment.getOrder().getOrderID() != rc.$.slatwall.cart().getOrderID()) {
						rc.newOrderPayment.orderPaymentID = "";
					}
				}
				
				rc.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
				rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
			}
			
			var order = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'placeOrder');
			
			arguments.rc.$.slatwall.addActionResult( "public:cart.placeOrder", order.hasErrors() );
			
			if(!order.hasErrors()) {
				rc.$.slatwall.setSessionValue('confirmationOrderID', order.getOrderID());
				rc.$.slatwall.getSession().setLastPlacedOrderID( order.getOrderID() );
			}
			
		}
	
	}
	/** Add Product Review */
	public void function addProductReview(required any rc) {
		param name="rc.newProductReview.product.productID" default="";
		
		var product = getProductService().getProduct( rc.newProductReview.product.productID );
		
		if( !isNull(product) ) {
			product = getProductService().processProduct( product, arguments.rc, 'addProductReview');
			
			arguments.rc.$.slatwall.addActionResult( "public:product.addProductReview", product.hasErrors() );
			
			if(!product.hasErrors()) {
				product.clearProcessObject("addProductReview");
			}
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:product.addProductReview", true );
		}
	}
	
	/* sets the status message, header and response */
	any function setStatusMsg(struct rc){
		arguments.rc.headers.contentType = "application/json";
		arguments.rc.apiResponse.content.success = true;
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		response.setStatus(200);
	}
	
	/* Sets the API response 
	 * @param success @type Boolean
	 * @param statusCode @type Integer
	 * @param data @type Struct
	 * @param returnJson @type Boolean
	 */
	any function setResponse(any success=false, any statusCode=400, any data, required struct rc, any returnJson=true){
		//Setup defaults.
		if (!StructKeyExists(arguments.rc, "data") || isNull(arguments.rc.apiResponse.content.data)){
				arguments.rc.apiResponse.content["data"] = "";
		}
		if (!StructKeyExists(arguments.rc, "status_code_message") || isNull(arguments.rc.apiResponse.content.messages)){
				arguments.rc.apiResponse.content["status_code_message"] = "";
		}
		if (!StructKeyExists(arguments.rc, "errors") || isNull(arguments.rc.apiResponse.content.errors)){
				arguments.rc.apiResponse.content["errors"] = "";
		}
		if (!StructKeyExists(arguments.rc, "request_token") || isNull(arguments.rc.apiResponse.content.request_token)){
				arguments.rc.apiResponse.content["request_token"] = "";
		}
		arguments.rc.headers.contentType = "application/json";
		arguments.rc.apiResponse.content["success"] = arguments.success;
		//Add the status code message to our messages if success and to errors otherwise.
		if (arguments.success){
			arguments.rc.apiResponse.content['status_code_message'] &= "#serializeJson(getHTTPMsgByStatus(arguments.statusCode), true)#";
		}else{
			arguments.rc.apiResponse.content["errors"] = getHTTPMsgByStatus(arguments.statusCode);
		}
		if (!isNull(arguments.data) && arguments.returnJson){
			try {	
			arguments.rc.apiResponse.content["data"] = serializeJson(arguments.data, true);
			}catch(any e){
				//can't serialize the data so just return it.
				setResponse(true, arguments.statusCode, arguments.data, arguments.rc, false);
			}
		}else if ( isNull(arguments.data) || isNull(arguments.returnJson) || arguments.returnJson ){
			arguments.rc.apiResponse.content["data"] = "";
		}
		//Set the page context.
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		//Set the response code.
		response.setStatus(arguments.statusCode);
		return;
	}
	
	/*
		Handles calling the set response if this was an api call.
		
	*/
	private any function handlePublicAPICall(any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct rc){
		if (arguments.rc.APIRequest){
			if (!isNull(genericObject) && genericObject.hasErrors()){
				setResponse(false, onErrorCode, genericObject.getErrors(), arguments.rc, true);
				return "_error";
			}else {
				setResponse(false, onErrorCode, "", arguments.rc, true);
				return "_error";
			}
			//Add the account data to the response
			setResponse(true, onSuccessCode, arguments.responseData, arguments.rc, true);	
			if (Len(extraData)){
				addDataToResponse("request_token", arguments.extraData, arguments.rc);	
			}
		}
	}
	
	/* Add data to the http response 
		@param data The data to append to the response
		@key The key to access the data
	*/
	private any function addDataToResponse(string key, data, required struct rc){
		//Populate it with the data as JSON
		if (!StructKeyExists(arguments.rc, "#arguments.key#") || isNull(arguments.rc.apiResponse.content["#arguments.key#"])){
			arguments.rc.apiResponse.content["#arguments.key#"] = "";
		}
		
		arguments.rc.apiResponse.content["#arguments.key#"] = serializeJson(arguments.data, true);
		return true;	
	}
	
	/*
		Returns the API Response Message that goes with the 
		@param statusCode any valid REST status code.
	 */
	private any function getHTTPMsgByStatus(any statusCode){
		var msg = "";
		switch (statusCode){
			case 200:
				msg = "Request is valid.";
				break;
			case 201:
				msg = "Created Successfully";
				break;
			case 215:
				msg = "Bad or Missing Authentication Data";
				break;
			case 400:
				msg = "Bad or Missing Input Data";
				break;
			case 401:
				msg = "Invalid Protocol In Use";
				break;
			case 403:
				msg = "Context Not Allowed or No Such Resource";
				break;
			case 404:
				msg = "Resource Not Found";
				break;
			case 500:
				msg = "Internal Server Error, Invalid Endpoint, or Operation Timeout";
				break;
			case 503:
				msg = "Server Busy";
				break;
			default:
				msg = "Unknown Status Code";
				break;
		}
		return msg;
	}
	
	
}