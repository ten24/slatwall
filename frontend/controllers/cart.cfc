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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="locationService" type="any";
	property name="orderService" type="any";
	property name="productService" type="any";
	property name="promotionService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="utilityFormService" type="any";
	property name="hibachiSessionService" type="any";
	
	// This method is deprecated as of 7/19/2011, the new method is clearCart
	public void function clearItems(required struct rc) {
		clearCart(rc);
	}
	
	public void function clearCart(required struct rc) {
		var cart = getOrderService().processOrder(rc.$.slatwall.getCart(), {}, 'clear');
		
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function update(required struct rc) {
		
		// Conditional logic to see if we should use the deprecated method
		if(structKeyExists(rc, "orderItems") && isArray(rc.orderItems)) {
			getOrderService().saveOrder(rc.$.slatwall.cart(), rc);
		} else if (structKeyExists(rc, "orderItem") && isStruct(rc.orderItem)) {
			// This is the deprecated method
			getOrderService().updateOrderItems(order=rc.$.slatwall.cart(), data=rc);	
		}
				
		getFW().setView("frontend:cart.detail");
	}
	
	public void function addItem(required struct rc) {
		// Setup the frontend defaults
		param name="rc.preProcessDisplayedFlag" default="true";
		param name="rc.saveShippingAccountAddressFlag" default="false";
		
		var cart = rc.$.slatwall.cart();
		
		// Check to see if we can attach the current account to this order, required to apply price group details
		if( isNull(cart.getAccount()) && rc.$.slatwall.getLoggedInFlag() ) {
			cart.setAccount( rc.$.slatwall.getAccount() );
		}
		
		cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'addOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
		
		if(!cart.hasErrors()) {
			cart.clearProcessObject("addOrderItem");
			
			// Also make sure that this cart gets set in the session as the order
			rc.$.slatwall.getSession().setOrder( cart );
			getHibachiSessionService().persistSession();
			
			// Check to see if we can attach the current account to this order
			if( isNull(cart.getAccount()) && rc.$.slatwall.getLoggedInFlag() ) {
				cart.setAccount( rc.$.slatwall.getAccount() );
			}
		}
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function removeItem(required struct rc) {
		param name="rc.orderItemID" default="";
		
		var cart = getOrderService().processOrder( rc.$.slatwall.cart(), arguments.rc, 'removeOrderItem');
		
		arguments.rc.$.slatwall.addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function addPromotionCode(required struct rc) {
		param name="rc.promotionCode" default="";
		param name="rc.promotionCodeOK" default="true";
		
		getOrderService().processOrder( rc.$.slatwall.cart(), rc, 'addPromotionCode');
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function removePromotionCode(required struct rc) {
		param name="rc.promotionCodeID" default="";
		
		getOrderService().processOrder( rc.$.slatwall.cart(), rc, 'removePromotionCode');
		
		getFW().setView("frontend:cart.detail");
	}
	
	public void function forceItemQuantityUpdate(required struct rc) {
		
		getOrderService().forceItemQuantityUpdate(order=rc.$.slatwall.cart(), messageBean=rc.$.slatwall.getHibachiMessages());
		
		getFW().setView("frontend:cart.detail");
	}
	
}

