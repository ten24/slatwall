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
component extends="HibachiService" accessors="true" output="false" hint="Contains all public API scope process methods"
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
	
	/** A description of each method in this public service */
	ArrayAppend(variables.publicContexts, {Name="Account", Description="Returns the account associated with the authentication token"});
	ArrayAppend(variables.publicContexts, {Name="SubscriptionUsage", Description="Returns the subscription usage associated with the authentication token."});
	ArrayAppend(variables.publicContexts, {Name="Order", Description="Returns the order usage associated with the authentication token."});
	ArrayAppend(variables.publicContexts, {Name="Login", Description="Login a user account."});
	ArrayAppend(variables.publicContexts, {Name="Logout", Description="Logout a user account."});
	
	/** Returns a JSON list of all public methods available to this request. */
	any function getPublicContexts( required struct rc ) {
		arguments.rc.apiResponse.content["Response"] = serializeJson(variables.publicContexts);
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	
	
	any function login( required struct rc ){
		
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'login' );
		arguments.rc.$.slatwall.addActionResult( "public:account.login", account.hasErrors() );
		
		if (account.hasErrors()){
			setResponse(false, 500, account.getErrors(), arguments.rc);
			return;
		}
		setResponse(true, 200, account, arguments.rc);	
		return account;
	}	
	
	/** Logout -  Account  */
	any function logout( required struct rc ){
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'logout' );
		arguments.rc.$.slatwall.addActionResult( "public:account.logout", false );
		if (account.hasErrors()){
			setResponse(false, 500, account.getErrors(), arguments.rc);
		}
		setResponse(true, 200, account, arguments.rc);		
		return account;
	}	
	
	/** Account - Forgot Password */
	public void function forgotPassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'forgotPassword');
		arguments.rc.$.slatwall.addActionResult( "public:account.forgotPassword", account.hasErrors() );
	}
	
	/** Account - Reset Password */
	public void function resetPassword( required struct rc ) {
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
		
		// Populate the current account with this processObject so that any errors, ect are there.
		arguments.rc.$.slatwall.account().setProcessObject( account.getProcessObject( "resetPassword" ) );
	}
	
	/** Account - Change Password */
	public void function changePassword( required struct rc ) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'changePassword');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.changePassword", account.hasErrors() );
	}
	
	/** Account - Create */
	public void function createAccount( required struct rc ) {
		param name="arguments.rc.createAuthenticationFlag" default="1";
		
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'create');
		
		arguments.rc.$.slatwall.addActionResult( "public:account.create", account.hasErrors() );
	}
	
	/** Account - Update */
	public void function updateAccount( required struct rc ) {
		var account = getAccountService().saveAccount( rc.$.slatwall.getAccount(), arguments.rc );
		
		arguments.rc.$.slatwall.addActionResult( "public:account.update", account.hasErrors() );
	}
	
	/** Account Email Address - Delete */
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
	
	// ------------------------ Helper Methods ---------------------------- //
	/* sets the status message, header and response */
	any function setStatusMsg(struct rc){
		arguments.rc.headers.contentType = "application/json";
		arguments.rc.apiResponse.content.success = true;
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		response.setStatus(200);
	}
	
	any function setResponse(any success=false, any statusCode=400, any data, required struct rc, any returnJson=true){
		//Grab the passed in arguments.
		if (isNull(arguments.rc.apiResponse.content.data)){
				arguments.rc.apiResponse.content.data = "";
		}
		if (isNull(arguments.rc.apiResponse.content.response_message)){
				arguments.rc.apiResponse.content.response_message = "";
		}
		arguments.rc.headers.contentType = "application/json";
		arguments.rc.apiResponse.content.success = arguments.success;
		arguments.rc.apiResponse.content["response_message"] = getHTTPMsgByStatus(arguments.statusCode);
		if (!isNull(arguments.data) && arguments.returnJson){
			try {	
			arguments.rc.apiResponse.content["data"] = serializeJson(arguments.data, true);
			}catch(any e){
				//can't serialize the data so just return it.
				setResponse(true, arguments.statusCode, arguments.data, arguments.rc, false);
			}
		}else{
			arguments.rc.apiResponse.content["data"] = arguments.data;
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
		Returns the API Response Message that goes with the 
		@param statusCode any valid REST status code.
	 */
	private any function getHTTPMsgByStatus(any statusCode){
		var msg = "";
		switch (statusCode){
			case 200:
				msg = "Request is valid.";
				break;
			case 215:
				msg = "Bad or Missing Authentication Data";
				break;
			case 400:
				msg = "Bad Input Data";
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
				msg = "Invalid Endpoint, Internal Server Error, or Operation Timeout";
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