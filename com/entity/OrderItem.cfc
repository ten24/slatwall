/*

    Slatwall - An e-commerce plugin for Mura CMS
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
component displayname="Order Item" entityname="SlatwallOrderItem" table="SlatwallOrderItem" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="price" ormtype="big_decimal";
	property name="quantity" ormtype="integer";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (many-to-one)
	property name="orderItemStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderItemStatusTypeID";
	property name="orderItemType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderItemTypeID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="orderReturn" cfc="OrderReturn" fieldtype="many-to-one" fkcolumn="orderReturnID";
	property name="referencedOrderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="referencedOrderItemID"; // Used For Returns. This is set when this order is a return.
	property name="referencedOrderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="many-to-one" fkcolumn="referencedOrderDeliveryItemID"; // Used For Returns. This is set when this order is a return.
	
	// Related Object Properties (one-to-many)
	property name="appliedPromotions" singularname="appliedPromotion" cfc="OrderItemAppliedPromotion" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all-delete-orphan";
	property name="appliedTaxes" singularname="appliedTax" cfc="OrderItemAppliedTax" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all-delete-orphan";
	property name="attributeValues" singularname="attributeValue" cfc="OrderItemAttributeValue" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all-delete-orphan";
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all";
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true";
	property name="referencingOrderItems" singularname="referencingOrderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="referencedOrderItemID" inverse="true" cascade="all"; // Used For Returns

	// Non persistent properties
	property name="discountAmount" persistent="false" formatType="currency" hint="This is the discount amount after quantity (talk to Greg if you don't understand)" ;
	property name="extendedPrice" persistent="false" formatType="currency";
	property name="extendedPriceAfterDiscount" persistent="false" formatType="currency" ; 
	property name="quantityDelivered" persistent="false";
	property name="quantityUndelivered" persistent="false";
	property name="taxAmount" persistent="false" formatType="currency" ; 

	public any function init() {
		
		// set the type to sale by default
		if( !structKeyExists(variables,"orderItemType") ) {
			setOrderItemType( getService("typeService").getTypeBySystemCode("oitSale") );
		}
		// set status to new by default
		if( !structKeyExists(variables,"orderItemStatusType") ) {
			setOrderItemStatusType( getService("typeService").getTypeBySystemCode("oistNew") );
		}
		
		// set default collections for association management methods
		if(isNull(variables.orderDeliveryItems)) {
		   variables.orderDeliveryItems = [];
		}
		if(isNull(variables.attributeValues)) {
		   variables.attributeValues = [];
		}
		if(isNull(variables.appliedPromotions)) {
		   variables.appliedPromotions = [];
		}
		if(isNull(variables.appliedTaxes)) {
		   variables.appliedTaxes = [];
		}
		if(isNull(variables.stockReceiverItems)) {
			variables.stockReceiverItems = [];	
		}
		
		return super.init();
	}

	public numeric function getMaximumOrderQuantity() {
		var maxQTY = getSku().getSetting('quantityOrderMaximum');
		
		if(getSku().getSetting('trackInventoryFlag') && !getSku().getSetting('allowBackorderFlag')) {
			if(getSKU().getQuantity('QATS') < maxQTY) {
				maxQTY = getSKU().getQuantity('QATS');
			}
		}
		
		return maxQTY;
	}
	
	public boolean function hasQuantityWithinMaxOrderQuantity() {
		return getQuantity() <= getMaximumOrderQuantity();
	}
	
	
	public string function getStatus(){
		return getOrderItemStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderItemStatusType().getSystemCode();
	}
	
	public string function displayCustomizations(format="list") {
		var customizations = "";
		if(arguments.format == 'htmlList' && this.hasAttributeValue()) {
			customizations = "<ul>";
		}
		for(var i=1; i<=arrayLen(getAttributeValues()); i++) {
			if(len(customizations) && arguments.format == "list") {
				customizations &= ", ";
			} else if(arguments.format == "htmlList") {
				customizations &= "<li>";
			}
			customizations &= "#getAttributeValues()[i].getAttribute().getAttributeName()#: #getAttributeValues()[i].getAttributeValue()#";
			if(arguments.format == "htmlList") {
				customizations &= "</li>";
			}
		}
		if(arguments.format == "htmlList") {
			customizations &= "</ul>";
		}		
		return customizations;
	}
	
	public any function getActionOptions() {
		var smartList = getService("orderService").getOrderItemStatusActionSmartList();
		smartList.addFilter("orderItemStatusType_typeID", getOrderItemStatusType().getTypeID());
		return smartList.getRecords();
	}
 
    // This method returns a single percentage rate for all taxes. So an item with tax 5% and 8% would return 13.
    public numeric function getCombinedTaxRate() {
    	var taxRate = 0;
    	for(var i=1; i <= ArrayLen(getAppliedTaxes()); i++) {
    		taxRate += getAppliedTaxes()[i].getTaxRate();
    	}
    	
    	return taxRate;
    }
    
    public struct function getQuantityPriceAlreadyReturned() {
    	
    	
    	
    	
    	return getService("OrderService").getQuantityPriceSkuAlreadyReturned(getOrder().getOrderID(), getSku().getSkuID());
    }
    
   
	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getDiscountAmount() {
		if(!structKeyExists(variables,"discountAmount")) {
			variables.discountAmount = 0;
			for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
				variables.discountAmount += getAppliedPromotions()[i].getDiscountAmount();
			}
		}
		return variables.discountAmount;
	}
	
	public numeric function getExtendedPrice() {
		return getPrice() * getQuantity();
	}
	
	public numeric function getExtendedPriceAfterDiscount() {
		return getExtendedPrice() - getDiscountAmount();
	}
	
	public numeric function getTaxAmount() {
		if(!structKeyExists(variables,"taxAmount")) {
			variables.taxAmount = 0;
			for(var i=1; i<=arrayLen(getAppliedTaxes()); i++) {
				variables.taxAmount += getAppliedTaxes()[i].getTaxAmount();
			}
		}
		return variables.taxAmount;
	}
	
	public numeric function getQuantityDelivered() {
		if(!structKeyExists(variables,"quantityDelivered") || !isNumeric(variables.quantityDelivered)) {
			variables.quantityDelivered = 0;
			var deliveryItems = getOrderDeliveryItems();
			for( var thisDeliveryItem in deliveryItems ) {
				variables.quantityDelivered += thisDeliveryItem.getQuantity();				
			}			
		}
		return variables.quantityDelivered;
	}
	
	public numeric function getQuantityUndelivered() {
		return getQuantity() - getQuantityDelivered();
	}
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderItem( this )) {
			arrayAppend(arguments.order.getOrderItems(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderItems(), index);
		}
		structDelete(variables, "order");
		
		// Remove from order fulfillment to trigger those actions
		removeOrderFulfillment();
	}
	
	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasOrderFulfillmentItem( this )) {
			arrayAppend(arguments.orderFulfillment.getOrderFulfillmentItems(), this);
			
			// Run Item's Changed Function
			variables.orderFulfillment.orderFulfillmentItemsChanged();
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getOrderFulfillmentItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getOrderFulfillmentItems(), index);
			
			// Run Item's Changed Function
			variables.orderFulfillment.orderFulfillmentItemsChanged();
		}
		structDelete(variables, "orderFulfillment");
	}


	// Order Return (many-to-one)
	public void function setOrderReturn(required any orderReturn) {
		variables.orderReturn = arguments.orderReturn;
		if(isNew() or !arguments.orderReturn.hasorderReturnItem( this )) {
			arrayAppend(arguments.orderReturn.getorderReturnItems(), this);
		}
	}
	public void function removeOrderReturn(any orderReturn) {
		if(!structKeyExists(arguments, "orderReturn")) {
			arguments.orderReturn = variables.orderReturn;
		}
		var index = arrayFind(arguments.orderReturn.getorderReturnItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getorderReturnItems(), index);
		}
		structDelete(variables, "orderReturn");
	}
	
	// Refrenced Order Item (many-to-one)
	public void function setRefrencedOrderItem(required any refrencedOrderItem) {
		variables.refrencedOrderItem = arguments.refrencedOrderItem;
		if(isNew() or !arguments.refrencedOrderItem.hasRefrencingOrderItems( this )) {
			arrayAppend(arguments.refrencedOrderItem.getRefrencingOrderItem(), this);
		}
	}
	public void function removeRefrencedOrderItem(any refrencedOrderItem) {
		if(!structKeyExists(arguments, "refrencedOrderItem")) {
			arguments.refrencedOrderItem = variables.refrencedOrderItem;
		}
		var index = arrayFind(arguments.refrencedOrderItem.getRefrencingOrderItem(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getRefrencingOrderItem(), index);
		}
		structDelete(variables, "refrencedOrderItem");
	}
	
	// Referenced Order Delivery Item (many-to-one)
	public void function setReferencedOrderDeliveryItem(required any referencedOrderDeliveryItem) {
		variables.referencedOrderDeliveryItem = arguments.referencedOrderDeliveryItem;
		if(isNew() or !arguments.referencedOrderDeliveryItem.hasReferencingOrderItem( this )) {
			arrayAppend(arguments.referencedOrderDeliveryItem.getReferencingOrderItems(), this);
		}
	}
	public void function removeReferencedOrderDeliveryItem(any referencedOrderDeliveryItem) {
		if(!structKeyExists(arguments, "referencedOrderDeliveryItem")) {
			arguments.referencedOrderDeliveryItem = variables.referencedOrderDeliveryItem;
		}
		var index = arrayFind(arguments.referencedOrderDeliveryItem.getReferencingOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getReferencingOrderItems(), index);
		}
		structDelete(variables, "referencedOrderDeliveryItem");
	}
	
	// Applied Promotions (one-to-many)
	public void function addAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.setOrderItem( this );
	}
	public void function removeAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.removeOrderItem( this );
	}
	
	// Applied Taxes (one-to-many)
	public void function addAppliedTax(required any appliedTax) {
		arguments.appliedTax.setOrderItem( this );
	}
	public void function removeAppliedTax(required any appliedTax) {
		arguments.appliedTax.removeOrderItem( this );
	}
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setOrderItem( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeOrderItem( this );
	}
	
	// Order Delivery Items (one-to-many)
	public void function addOrderDeliveryItem(required any orderDeliveryItem) {
		arguments.orderDeliveryItem.setOrderItem( this );
	}
	public void function removeOrderDeliveryItem(required any orderDeliveryItem) {
		arguments.orderDeliveryItem.removeOrderItem( this );
	}
	
	// Stock Receiver Items (one-to-many)
	public void function addStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.setOrderItem( this );
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.removeOrderItem( this );
	}
	
	// Refrencing Order Items (one-to-many)
	public void function addRefrencingOrderItem(required any refrencingOrderItem) {
		arguments.refrencingOrderItem.setRefrencedOrderItem( this );
	}
	public void function removeRefrencingOrderItem(required any refrencingOrderItem) {
		arguments.refrencingOrderItem.removeRefrencedOrderItem( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert() {
		super.preInsert();
		getService("skuCacheService").updateFromOrderItem( this );
	}
	
	public void function preUpdate(struct oldData) {
		super.preUpdate(argumentcollection=arguments);
		getService("skuCacheService").updateFromOrderItem( this );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
