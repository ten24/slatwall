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
component displayname="Promotion Applied" entityname="SlatwallPromotionApplied" table="SwPromotionApplied" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" {
	
	// Persistent Properties
	property name="promotionAppliedID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="discountAmount" ormtype="big_decimal";
	property name="appliedType" ormtype="string";
	property name="currencyCode" ormtype="string" length="3";
	
	// Related Entities
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID" hb_cascadeCalculate="true";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderfulfillmentID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion (many-to-one)
	public void function setPromotion(required any promotion) {
		variables.promotion = arguments.promotion;
		if(isNew() or !arguments.promotion.hasAppliedPromotion( this )) {
			arrayAppend(arguments.promotion.getAppliedPromotions(), this);
		}
	}
	public void function removePromotion(any promotion) {
		if(!structKeyExists(arguments, "promotion")) {
			arguments.promotion = variables.promotion;
		}
		var index = arrayFind(arguments.promotion.getAppliedPromotions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotion.getAppliedPromotions(), index);
		}
		structDelete(variables, "promotion");
	}
	
	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasAppliedPromotion( this )) {
			arrayAppend(arguments.orderItem.getAppliedPromotions(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getAppliedPromotions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getAppliedPromotions(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasAppliedPromotion( this )) {
			arrayAppend(arguments.orderFulfillment.getAppliedPromotions(), this);
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getAppliedPromotions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getAppliedPromotions(), index);
		}
		structDelete(variables, "orderFulfillment");
	}
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasAppliedPromotion( this )) {
			arrayAppend(arguments.order.getAppliedPromotions(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getAppliedPromotions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getAppliedPromotions(), index);
		}
		structDelete(variables, "order");
	}

	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
