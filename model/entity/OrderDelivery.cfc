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
component displayname="Order Delivery" entityname="SlatwallOrderDelivery" table="SwOrderDelivery" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderDelivery" hb_processContexts="create" {

	// Persistent Properties
	property name="orderDeliveryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="trackingNumber" ormtype="string";
	property name="containerLabel" ormtype="clob";
	// Related Object Properties (Many-To-One)
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="paymentTransaction" cfc="PaymentTransaction" fieldtype="many-to-one" fkcolumn="paymentTransactionID";

	// Related Object Properties (One-To-Many)
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderDeliveryID" cascade="all-delete-orphan" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="orderDeliveryID" cascade="all-delete-orphan" inverse="true";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="totalQuantityDelivered" persistent="false" type="numeric" hb_formatType="numeric";

	public any function getTotalQuantityDelivered() {
		var totalDelivered = 0;
		for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
			totalDelivered += getOrderDeliveryItems()[i].getQuantity();
		}
		return totalDelivered;
	}

	public any function getOrderDeliveryGiftCardSmartList() {
		var giftCardSmartList = getService("GiftCardService").getGiftCardSmartList();
		giftcardSmartList.joinRelatedProperty("SlatwallGiftCard", "originalOrderItem");
		giftcardSmartList.joinRelatedProperty("SlatwallOrderItem","orderDeliveryItems");
		giftcardSmartList.joinRelatedProperty("SlatwallOrderDeliveryItem", "orderDelivery");
		giftcardsmartlist.addFilter("originalOrderItem.orderDeliveryItems.orderDelivery.orderDeliveryID", this.getOrderDeliveryID());
		return giftCardSmartList;
	}

	public any function getOrderFulfillment(){
		return this.getOrderDeliveryItems()[1].getOrderItem().getOrderFulfillment();
	}

    // ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderDelivery( this )) {
			arrayAppend(arguments.order.getOrderDeliveries(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderDeliveries(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderDeliveries(), index);
		}
		structDelete(variables, "order");
	}

	// Order Delivery Items (one-to-many)
	public void function addOrderDeliveryItem(required any orderDeliveryItem) {
		arguments.orderDeliveryItem.setOrderDelivery( this );
	}
	public void function removeOrderDeliveryItem(required any orderDeliveryItem) {
		arguments.orderDeliveryItem.removeOrderDelivery( this );
	}

	// Attribute Values (one-to-many)
 	public void function addAttributeValue(required any attributeValue) {
 		arguments.attributeValue.setOrderDelivery( this );
 	}
 	public void function removeAttributeValue(required any attributeValue) {
 		arguments.attributeValue.removeOrderDelivery( this );
 	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		return "Delivery for - " & getOrder().getOrderNumber();
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}

