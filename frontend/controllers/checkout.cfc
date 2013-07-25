/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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

    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="addressService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="settingService" type="any";
	property name="sessionService" type="any";
	property name="userUtility" type="any";

	public any function init(required any fw) {
		setUserUtility( getCMSBean("userUtility") );

		return super.init(arguments.fw);
	}

	public void function detail(required struct rc) {
		param name="rc.edit" default="";
		param name="rc.orderRequirementsList" default="";
		param name="rc.guestAccountOK" default="false";

		// Insure that the cart is not new, and that it has order items in it.  otherwise redirect to the shopping cart
		if(!arrayLen(getSlatwallScope().cart().getOrderItems())) {
			getFW().redirectSetting( settingName='globalPageShoppingCart' );
		}

		// Insure that all items in the cart are within their max constraint
		if(!getSlatwallScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getFW().redirectSetting( settingName='globalPageShoppingCart', queryString='slatAction=frontend:cart.forceItemQuantityUpdate' );
		}

		// Recaluclate Order Totals In Case something has changed
		getOrderService().recalculateOrderAmounts(getSlatwallScope().cart());

		// get the list of requirements left for this order to be processed
		rc.orderRequirementsList = getOrderService().getOrderRequirementsList(getSlatwallScope().cart());

		// Account Setup Logic
		if ( isNull(getSlatwallScope().cart().getAccount()) ) {
			// When no account is in the order then just set a new account in the rc so it works
			// We don't need to put account in the rc.orderRequirementsList because it will already be there
			rc.account = getAccountService().newAccount();
		} else {
			// If the account on cart is the same as the one logged in then set the rc.account from cart
			// OR If the cart is using a guest account, and this method was called from a different controller that says guest accounts are ok, then pass in the cart account
			if( getSlatwallScope().cart().getAccount().getAccountID() == getSlatwallScope().account().getAccountID() || (getSlatwallScope().cart().getAccount().isGuestAccount() && rc.guestAccountOK) ) {
				rc.account = getSlatwallScope().cart().getAccount();
			} else {
				rc.account = getAccountService().newAccount();
				// Here we need to add it to the requirements list because the cart might have already had an account
				rc.orderRequirementsList = listPrepend(rc.orderRequirementsList,"account");
			}
		}

		// Setup some elements to be used by different views
		rc.eligiblePaymentMethodDetails = getPaymentService().getEligiblePaymentMethodDetailsForOrder(order=getSlatwallScope().cart());

		// This RC Key is deprecated
		rc.activePaymentMethods = getPaymentService().listPaymentMethodFilterByActiveFlag(1);
	}

	public void function confirmation(required struct rc) {
		param name="rc.orderID" default="";

		rc.order = getOrderService().getOrder(rc.orderID, true);

	}

	public void function loginAccount(required struct rc) {
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.returnURL" default="";
		param name="rc.forgotPasswordEmail" default="";

		if(rc.forgotPasswordEmail != "") {
			rc.forgotPasswordResult = getUserUtility().sendLoginByEmail(email=rc.forgotPasswordEmail, siteid=rc.$.event('siteID'));
		} else {
			var loginSuccess = getAccountService().loginCmsUser(username=arguments.rc.username, password=arguments.rc.password, siteID=rc.$.event('siteid'));

			if(!loginSuccess) {
				request.status = "failed";
			}
		}

		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}

	public void function saveOrderAccount(required struct rc) {
		rc.guestAccountOK = true;

		getOrderService().updateAndVerifyOrderAccount(order=$.slatwall.cart(), data=rc);

		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}

	public void function saveOrderFulfillments(required struct rc) {
		rc.guestAccountOK = true;

		getOrderService().updateAndVerifyOrderFulfillments(order=$.slatwall.cart(), data=rc);

		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}

	public void function saveOrderPayments(required struct rc) {
		rc.guestAccountOK = true;

		getOrderService().updateAndVerifyOrderPayments(order=$.slatwall.cart(), data=rc);

		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}

	public void function processOrder(required struct rc) {
		param name="rc.orderID" default="";

		rc.guestAccountOK = true;

		// Insure that all items in the cart are within their max constraint
		if(!getSlatwallScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getFW().redirectExact(rc.$.createHREF(filename='shopping-cart',queryString='slatAction=frontend:cart.forceItemQuantityUpdate'));
		}

		// Setup the order
		var order = getOrderService().getOrder(rc.orderID);

		// Attemp to process the order
		order = getOrderService().processOrder(order, rc, "placeOrder");

		if(!order.hasErrors()) {

			// Save the order ID temporarily in the session for the confirmation page.  It will be removed by that controller
			getSessionService().setValue("orderConfirmationID", rc.orderID);

			// Redirect to order Confirmation
			getFW().redirectExact($.createHREF(filename='order-confirmation'), false);

		}

		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}

}
