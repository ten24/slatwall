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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="fw" type="any";

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="hibachiSessionService" type="any";

	public void function init( required any fw ) {
		setFW( arguments.fw );
	}

	public void function before() {
		getFW().setView("public:main.blank");
	}

	public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions())) {
			getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} else if (structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions())) {
			getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} else if (structKeyExists(arguments.rc, "redirectURL")) {
			getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}

	// Update
	public void function update( required struct rc ) {
		var cart = getOrderService().saveOrder( getHibachiScope().cart(), arguments.rc );

		// Insure that all items in the cart are within their max constraint
		if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
			cart = getOrderService().processOrder(cart, 'forceItemQuantityUpdate');
		}

		getHibachiScope().addActionResult( "public:cart.update", cart.hasErrors() );
	}

	// Clear
	public void function clear( required struct rc ) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'clear');

		getHibachiScope().addActionResult( "public:cart.clear", cart.hasErrors() );
	}

	// Change
	public void function change( required struct rc ){
		param name="arguments.rc.orderID" default="";

		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
			getHibachiScope().getSession().setOrder( order );
			getHibachiScope().addActionResult( "public:cart.change", false );
		} else {
			getHibachiScope().addActionResult( "public:cart.change", true );
		}
	}

	// Delete
	public void function delete( required struct rc ) {
		param name="arguments.rc.orderID" default="";

		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
			var deleteOk = getOrderService().deleteOrder(order);
			getHibachiScope().addActionResult( "public:cart.delete", !deleteOK );
		} else {
			getHibachiScope().addActionResult( "public:cart.delete", true );
		}
	}

	// Add Order Item
	public void function addOrderItem(required any rc) {
		// Setup the frontend defaults
		param name="rc.preProcessDisplayedFlag" default="true";
		param name="rc.saveShippingAccountAddressFlag" default="false";

		var cart = getHibachiScope().cart();

		// Check to see if we can attach the current account to this order, required to apply price group details
		if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
			cart.setAccount( getHibachiScope().getAccount() );
		}

		cart = getOrderService().processOrder( cart, arguments.rc, 'addOrderItem');

		getHibachiScope().addActionResult( "public:cart.addOrderItem", cart.hasErrors() );

		if(!cart.hasErrors()) {
			// If the cart doesn't have errors then clear the process object
			cart.clearProcessObject("addOrderItem");

			// Also make sure that this cart gets set in the session as the order
			getHibachiScope().getSession().setOrder( cart );

			// Make sure that the session is persisted
			getHibachiSessionService().persistSession();

		}
	}
	
 	// Add Order Items
  	public void function addOrderItems(required any rc) {
  		param name="data.skuIds" default="";
      	param name="data.skuCodes" default="";
  		
  		getService("PublicService").addOrderItems(rc);
  		
  	}
 	
	// Guest Account
	public void function guestAccount(required any rc) {
		param name="arguments.rc.createAuthenticationFlag" default="0";

		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'create');

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

	// Save Guest Account
	public void function guestAccountCreatePassword( required struct rc ) {
		param name="arguments.rc.orderID" default="";
		param name="arguments.rc.accountID" default="";

		var order = getOrderService().getOrder( arguments.rc.orderID );

		// verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
		if(!isNull(order) && arguments.rc.orderID == getHibachiScope().getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.rc.accountID && order.getAccount().getGuestAccountFlag()) {

			var account = getAccountService().processAccount( order.getAccount(), arguments.rc, "createPassword" );
			getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", account.hasErrors() );

		} else {

			getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", true );
		}

	}

	// Remove Order Item
	public void function removeOrderItem(required any rc) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'removeOrderItem');

		getHibachiScope().addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
	}

	// Update Order Fulfillment
	public void function updateOrderFulfillment(required any rc) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'updateOrderFulfillment');

		getHibachiScope().addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
	}

	// Add Promotion Code
	public void function addPromotionCode(required any rc) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'addPromotionCode');

		getHibachiScope().addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );

		if(!cart.hasErrors()) {
			cart.clearProcessObject("addPromotionCode");
		}
	}

	// Remove Promotion Code
	public void function removePromotionCode(required any rc) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'removePromotionCode');

		getHibachiScope().addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
	}

	// Add Order Payment
	public void function addOrderPayment(required any rc) {
		param name="rc.newOrderPayment" default="#structNew()#";
		param name="rc.newOrderPayment.orderPaymentID" default="";
		param name="rc.accountAddressID" default="";
		param name="rc.accountPaymentMethodID" default="";

		// Make sure that someone isn't trying to pass in another users orderPaymentID
		if(len(rc.newOrderPayment.orderPaymentID)) {
			var orderPayment = getOrderService().getOrderPayment(rc.newOrderPayment.orderPaymentID);
			if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
				rc.newOrderPayment.orderPaymentID = "";
			}
		}

		rc.newOrderPayment.order.orderID = getHibachiScope().cart().getOrderID();
		rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';

		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'addOrderPayment');

		getHibachiScope().addActionResult( "public:cart.addOrderPayment", cart.hasErrors() );
	}

	// Remove Order Payment
	public void function removeOrderPayment(required any rc) {
		var cart = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'removeOrderPayment');

		getHibachiScope().addActionResult( "public:cart.removeOrderPayment", cart.hasErrors() );
	}

	// Place Order
	public void function placeOrder(required any rc) {

		// Insure that all items in the cart are within their max constraint
		if(!getHibachiScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getOrderService().processOrder(getHibachiScope().cart(), 'forceItemQuantityUpdate');
			getHibachiScope().addActionResult( "public:cart.placeOrder", true );
		} else {
			// Setup newOrderPayment requirements
			if(structKeyExists(rc, "newOrderPayment")) {
				param name="rc.newOrderPayment.orderPaymentID" default="";
				param name="rc.accountAddressID" default="";
				param name="rc.accountPaymentMethodID" default="";

				// Make sure that someone isn't trying to pass in another users orderPaymentID
				if(len(rc.newOrderPayment.orderPaymentID)) {
					var orderPayment = getOrderService().getOrderPayment(rc.newOrderPayment.orderPaymentID);
					if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
						rc.newOrderPayment.orderPaymentID = "";
					}
				}

				rc.newOrderPayment.order.orderID = getHibachiScope().cart().getOrderID();
				rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
			}

			var order = getOrderService().processOrder( getHibachiScope().cart(), arguments.rc, 'placeOrder');

			getHibachiScope().addActionResult( "public:cart.placeOrder", order.hasErrors() );

			if(!order.hasErrors()) {
				getHibachiScope().setSessionValue('confirmationOrderID', order.getOrderID());
				getHibachiScope().getSession().setLastPlacedOrderID( order.getOrderID() );
			}

		}

	}
}
