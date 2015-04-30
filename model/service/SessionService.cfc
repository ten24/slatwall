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

component  extends="HibachiService" accessors="true" {
	
	
	property name="hibachiAuditService" type="any";
	property name="validationService" type="any";
	property name="accountService" type="any";
	
	// ===================== START: Logical Methods ===========================
	
	// Account - Login
	public any function processSession_login( required struct data ) {
		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'login' );
		return account;
	}
	
	// Account - Logout
	public any function processSession_logout( required struct data ) {
		var account = getAccountService().processAccount( getHibachiScope.getAccount(), arguments.data, 'logout' );
		
		return account;
	}
	
	// Account - Forgot Password
	public any function processSession_forgotPassword( required struct data ) {
		var account = getAccountService().processAccount( getHibachiScope.getAccount(), arguments.data, 'forgotPassword');
		
		return account;
	}
	
	// Account - Reset Password
	public any function processSession_resetPassword( required struct data ) {
		param name="data.accountID" default="";
		
		var account = getAccountService().getAccount( data.accountID );
		
		if(!isNull(account)) {
			var account = getAccountService().processAccount(account, rc, "resetPassword");
			
			// As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
			if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
				form.emailAddress = account.getEmailAddress();
			}
		}
		
		// Populate the current account with this processObject so that any errors, ect are there.
		arguments.getHibachiScope.account().setProcessObject( account.getProcessObject( "resetPassword" ) );
		return account;
	}
	
	// Account - Change Password
	public any function processSession_changePassword( required struct data ) {
		var account = getAccountService().processAccount( getHibachiScope.getAccount(), arguments.data, 'changePassword');
		return account;
	}
	
	// Account - Create
	public any function processSession_create( required struct data ) {
		param name="arguments.data.createAuthenticationFlag" default="1";
		
		var account = getAccountService().processAccount( getHibachiScope.getAccount(), arguments.data, 'create');
		return account;
	}
	
	// Account - Update
	/*public any function processSession_update( required struct data ) {
		var account = getAccountService().saveAccount( getHibachiScope.getAccount(), arguments.data );
		return account;
	}*/
	
	// Account Email Address - Delete
	public any function processSession_deleteAccountEmailAddress() {
		param name="data.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
		} 
		return accountEmailAddress;
	}
	
	// Account Email Address - Send Verification Email
	public any function processSession_sendAccountEmailAddressVerificationEmail() {
		param name="data.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
			accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, rc, 'sendVerificationEmail' );
		} 
		return accountEmailAddress;
	}
	
	// Account Email Address - Verify
	public any function processSession_verifyAccountEmailAddress() {
		param name="data.accountEmailAddressID" default="";
		
		var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
		
		if(!isNull(accountEmailAddress)) {
			accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, rc, 'verify' );
		} 
		return accountEmailAddress;
	}
	
	// Account Phone Number - Delete
	public any function processSession_deleteAccountPhoneNumber() {
		param name="data.accountPhoneNumberID" default="";
		
		var accountPhoneNumber = getAccountService().getAccountPhoneNumber( data.accountPhoneNumberID );
		
		if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
		}
		return accountPhoneNumber;
	}
	
	// Account Address - Delete
	public any function processSession_deleteAccountAddress() {
		param name="data.accountAddressID" default="";
		
		var accountAddress = getAccountService().getAccountAddress( data.accountAddressID );
		
		if(!isNull(accountAddress) && accountAddress.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
		} 
		return accountAddress;
	}
	
	// Account Payment Method - Delete
	public any function processSession_deleteAccountPaymentMethod() {
		param name="data.accountPaymentMethodID" default="";
		
		var accountPaymentMethod = getAccountService().getAccountPaymentMethod( data.accountPaymentMethodID );
		
		if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
		} 
		return accountPaymentMethod;
	}
	
	// Account Payment Method - Add
	public any function processSession_addAccountPaymentMethod() {
		
		if(arguments.getHibachiScope.getLoggedInFlag()) {
			
			// Force the payment method to be added to the current account
			var accountPaymentMethod = arguments.getHibachiScope.getAccount().getNewPropertyEntity( 'accountPaymentMethods' );
			
			accountPaymentMethod.setAccount( arguments.getHibachiScope.getAccount() );
			
			accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.data );
			
			
			// If there were no errors then we can clear out the
			
		}
		return accountPaymentMethod;
	}
	
	// Subscription Usage - Update
	public any function processSession_updateSubscriptionUsage() {
		param name="data.subscriptionUsageID" default="";
		
		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
		
		if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID() ) {
			var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.data );
			
		} 
		return subscriptionUsage;
	}
	
	// Subscription Usage - Renew
	public any function processSession_renewSubscriptionUsage() {
		param name="data.subscriptionUsageID" default="";
		
		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
		
		if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID() ) {
			var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'renew' );
			
		} 
		return subscriptionUsage;
	}
	
	public any function processSession_duplicateOrder() {
		param name="arguments.data.orderID" default="";
		param name="arguments.data.setAsCartFlag" default="0";
		
		var order = getOrderService().getOrder( arguments.data.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == arguments.getHibachiScope.getAccount().getAccountID()) {
			
			var data = {
				saveNewFlag=true,
				copyPersonalDataFlag=true
			};
			
			var duplicateOrder = getOrderService().processOrder(order,data,"duplicateOrder" );
			
			if(isBoolean(arguments.data.setAsCartFlag) && arguments.data.setAsCartFlag) {
				arguments.getHibachiScope.getSession().setOrder( duplicateOrder );
			}
		}
		return order;
	}
	
	//Cart Methods
	
	// Update
	public any function processSession_update( required struct data ) {
		var cart = getOrderService().saveOrder( getHibachiScope().cart(), arguments.data );
		
		// Insure that all items in the cart are within their max constraint
		if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
			cart = getOrderService().processOrder(cart, 'forceItemQuantityUpdate');
		}
		return cart;
	}
	
	// Clear
	public any function processSession_clear( required struct data ) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'clear');
		return cart;
	}
	
	// Change
	public any function processSession_change( required struct data ){
		param name="arguments.data.orderID" default="";
		
		var order = getOrderService().getOrder( arguments.data.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
			getHibachiScope().getSession().setOrder( order );
		} 
		return order;
	}
	
	// Delete
	public any function processSession_delete( required struct data ) {
		param name="arguments.data.orderID" default="";
		
		var order = getOrderService().getOrder( arguments.data.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
			var deleteOk = getOrderService().deleteOrder(order);
		} 
		return order;
	}
	
	// Add Order Item
	public any function processSession_addOrderItem(required struct data) {
		// Setup the frontend defaults
		param name="data.preProcessDisplayedFlag" default="true";
		param name="data.saveShippingAccountAddressFlag" default="false";
		
		var cart = getHibachiScope().cart();
		
		// Check to see if we can attach the current account to this order, required to apply price group details
		if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
			cart.setAccount( getHibachiScope().getAccount() );
		}
		
		cart = getOrderService().processOrder( cart, arguments.data, 'addOrderItem');
		
		if(!cart.hasErrors()) {
			// If the cart doesn't have errors then clear the process object
			cart.clearProcessObject("addOrderItem");
			
			// Also make sure that this cart gets set in the session as the order
			getHibachiScope().getSession().setOrder( cart );
			
			// Make sure that the session is persisted
			getHibachiSessionService().persistSession();
			
		}
		return cart;
	}
	
	// Guest Account
	public any function processSession_guestAccount(required struct data) {
		param name="arguments.data.createAuthenticationFlag" default="0";
		
		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'create');
		
		if( !account.hasErrors() ) {
			if( !isNull(getHibachiScope().getCart().getAccount())) {
				var newCart = getOrderService().duplicateOrderWithNewAccount( getHibachiScope().getCart(), account );
				getHibachiScope().getSession().setOrder( newCart );
			} else {
				getHibachiScope().getCart().setAccount( account );	
			}
		} 
		return account;
		
	}
	
	// Save Guest Account
	public any function processSession_guestAccountCreatePassword( required struct data ) {
		param name="arguments.data.orderID" default="";
		param name="arguments.data.accountID" default="";

		var order = getOrderService().getOrder( arguments.data.orderID );
		
		// verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
		if(!isNull(order) && arguments.data.orderID == getHibachiScope().getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.data.accountID && order.getAccount().getGuestAccountFlag()) {
			
			var account = getAccountService().processAccount( order.getAccount(), arguments.data, "createPassword" );
			
		} 
		return order;
		
	}
	
	// Remove Order Item
	public any function processSession_removeOrderItem(required struct data) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderItem');
		return cart;
	}
	
	// Update Order Fulfillment
	public any function processSession_updateOrderFulfillment(required struct data) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'updateOrderFulfillment');
		return cart;
	}
	
	// Add Promotion Code
	public any function processSession_addPromotionCode(required struct data) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'addPromotionCode');
		
		if(!cart.hasErrors()) {
			cart.clearProcessObject("addPromotionCode");
		}
		return cart;
	}
	
	// Remove Promotion Code
	public any function processSession_removePromotionCode(required struct data) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'removePromotionCode');
		return cart;
	}
	
	// Add Order Payment
	public any function processSession_addOrderPayment(required struct data) {
		param name="data.newOrderPayment" default="#structNew()#";
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
		
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'addOrderPayment');
		return cart;
	}
	
	// Remove Order Payment
	public any function processSession_removeOrderPayment(required struct data) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderPayment');
		return cart;
	}
	
	// Place Order
	public any function processSession_placeOrder(required struct data) {
		
		// Insure that all items in the cart are within their max constraint
		if(!getHibachiScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getOrderService().processOrder(getHibachiScope().cart(), 'forceItemQuantityUpdate');
		} else {
			// Setup newOrderPayment requirements
			if(structKeyExists(rc, "newOrderPayment")) {
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
			
			
			if(!order.hasErrors()) {
				getHibachiScope().setSessionValue('confirmationOrderID', order.getOrderID());
				getHibachiScope().getSession().setLastPlacedOrderID( order.getOrderID() );
			}
			
		}
		return cart;
	
	}
	
	//Product Methods
	
	// Add Product Review
	public any function processSession_addProductReview(required struct data) {
		param name="data.newProductReview.product.productID" default="";
		
		var product = getProductService().getProduct( data.newProductReview.product.productID );
		
		if( !isNull(product) ) {
			product = getProductService().processProduct( product, arguments.data, 'addProductReview');
			
			
			if(!product.hasErrors()) {
				product.clearProcessObject("addProductReview");
			}
		} 
		return product;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}
