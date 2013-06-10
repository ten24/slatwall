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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="fw" type="any";
	
	property name="accountService" type="any";
	property name="orderService" type="any";

	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function before() {
		getFW().setView("public:main.blank");
	}
	
	// Update
	public void function update( required struct rc ) {
		var cart = getOrderService().saveOrder( rc.$.slatwall.cart(), arguments.rc );
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.update", cart.hasErrors() );
	}
	
	// Clear
	public void function clear( required struct rc ) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'clear');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.clear", cart.hasErrors() );
	}
	
	// Change
	public void function change( required struct rc ){
		param name="arguments.rc.orderID" default="";
		
		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID()) {
			arguments.rc.$.slatwall.getSession().setOrder( order );
			arguments.rc.$.slatwall.addActionResult( "public:cart.change", false );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.change", true );
		}
	}
	
	// Delete
	public void function delete( required struct rc ) {
		param name="arguments.rc.orderID" default="";
		
		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == arguments.rc.$.slatwall.getAccount().getAccountID()) {
			var deleteOk = getOrderService().deleteOrder(order);
			arguments.rc.$.slatwall.addActionResult( "public:cart.delete", !deleteOK );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.delete", true );
		}
	}
	
	// Add Order Item
	public void function addOrderItem(required any rc) {
		// Setup the frontend defaults
		param name="rc.preProcessDisplayedFlag" default="true";
		param name="rc.saveShippingAccountAddressFlag" default="false";
		param name="rc.orderFulfillmentID" default="";
		param name="rc.fulfillmentMethodID" default="";
		
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
		
		if(!cart.hasErrors()) {
			cart.clearProcessObject("addOrderItem");
		}
	}
	
	// Guest Account
	public void function guestAccount(required any rc) {
		var account = getAccountService().processAccount( rc.$.slatwall.getAccount(), arguments.rc, 'create');
		
		if( !account.hasErrors() ) {
			rc.$.slatwall.getCart().setAccount( account );
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestCheckout", false );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestCheckout", true );	
		}
	}
	
	// Remove Order Item
	public void function removeOrderItem(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'removeOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
	}
	
	// Add Promotion Code
	public void function addPromotionCode(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addPromotionCode');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );
		
		if(!cart.hasErrors()) {
			cart.clearProcessObject("addPromotionCode");
		}
	}
	
	// Remove Promotion Code
	public void function removePromotionCode(required any rc) {
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'removePromotionCode');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
	}
	
	// Add Order Payment
	public void function addOrderPayment(required any rc) {
		
		// Setup newOrderPayment requirements
		if(structKeyExists(rc, "newOrderPayment")) {
			rc.newOrderPayment.orderPaymentID = '';
			rc.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
			rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
		}
		
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addOrderPayment');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderPayment", cart.hasErrors() );
	}
	
	// Place Order
	public void function placeOrder(required any rc) {
	
		// Setup newOrderPayment requirements
		if(structKeyExists(rc, "newOrderPayment")) {
			rc.newOrderPayment.orderPaymentID = '';
			rc.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
			rc.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
		}
		
		var order = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'placeOrder');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.placeOrder", order.hasErrors() );
		
		if(!order.hasErrors()) {
			rc.$.slatwall.setSessionValue('confirmationOrderID', order.getOrderID());
		}
	}
}