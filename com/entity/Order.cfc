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
component displayname="Order" entityname="SlatwallOrder" table="SlatwallOrder" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderNumber" ormtype="string"; 
	property name="orderOpenDateTime" ormtype="timestamp";
	property name="orderCloseDateTime" ormtype="timestamp";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (Many-To-One)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="referencedOrder" cfc="Order" fieldtype="many-to-one" fkcolumn="referencedOrderID";	// Points at the "parent" (NOT return) order.
	property name="orderType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTypeID";
	property name="orderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID";
	
	// Related Object Properties (One-To-Many)
	property name="orderItems" singularname="orderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderDeliveries" singularname="orderDelivery" cfc="OrderDelivery" fieldtype="one-to-many" fkcolumn="orderID"  cascade="all-delete-orphan" inverse="true";
	property name="orderFulfillments" singularname="orderFulfillment" cfc="OrderFulfillment" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderPayments" singularname="orderPayment" cfc="OrderPayment" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderReturns" singularname="orderReturn" cfc="OrderReturn" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="referencingOrders" singularname="referencingOrder" cfc="Order" fieldtype="one-to-many" fkcolumn="referencedOrderID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (Many-To-Many)
	property name="promotionCodes" singularname="promotionCode" cfc="PromotionCode" fieldtype="many-to-many" linktable="SlatwallOrderPromotionCode" fkcolumn="orderID" inversejoincolumn="promotionCodeID" cascade="save-update";
	
	// Non persistent properties
	property name="total" persistent="false" formatType="currency";
	property name="subTotal" persistent="false" formatType="currency";
	property name="taxTotal" persistent="false" formatType="currency";
	property name="itemDiscountAmountTotal" persistent="false" formatType="currency";
	property name="fulfillmentDiscountAmountTotal" persistent="false" formatType="currency";
	property name="orderDiscountAmountTotal" persistent="false" formatType="currency"; 
	property name="discountTotal" persistent="false" formatType="currency";
	property name="fulfillmentTotal" persistent="false" formatType="currency";
	property name="fulfillmentRefundTotal" persistent="false" formatType="currency";
	
	public any function init() {
		if(isNull(variables.orderItems)) {
			variables.orderItems = [];
		}
		if(isNull(variables.orderDeliveries)) {
			variables.orderDeliveries = [];
		}
		if(isNull(variables.orderFulfillments)) {
			variables.orderFulfillments = [];
		}
		if(isNull(variables.orderPayments)) {
			variables.orderPayments = [];
		}
		if(isNull(variables.orderReturns)) {
			variables.orderReturns = [];
		}
		if(isNull(variables.referencingOrders)) {
			variables.referencingOrders = [];
		}
		if(isNull(variables.promotionCodes)) {
			variables.promotionCodes = [];
		}
		
		// Set the default order status type as not placed
		if(isNull(getOrderStatusType())) {
			variables.orderStatusType = getService("typeService").getTypeBySystemCode('ostNotPlaced');
		}
		
		// Set the default type to purchase order
		if(isNull(getOrderType())) {
			variables.orderType = getService("typeService").getTypeBySystemCode('otSalesOrder');
		}

		return super.init();
	}
	
	public string function getStatus() {
		return getOrderStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderStatusType().getSystemCode();
	}
	
	public numeric function getTotalItems() {
		return arrayLen(getOrderItems());
	}
	
	public boolean function hasItemsQuantityWithinMaxOrderQuantity() {
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if(!getOrderItems()[i].hasQuantityWithinMaxOrderQuantity()) {
				return false;
			}
		}
		return true;
	}
	
	// TODO: may need to refactor the next 4 methods to more efficient HQL
	public numeric function getTotalQuantity() {
		if(!structKeyExists(variables,"totalQuantity")) {
			var orderItems = getOrderItems();
			variables.totalQuantity = 0;
			for(var i=1; i<=arrayLen(orderItems); i++) {
				variables.totalQuantity += orderItems[i].getQuantity(); 
			}			
		}
		return variables.totalQuantity;
	}
	
	public numeric function getQuantityDelivered() {
		if(!structKeyExists(variables,"quantityDelivered")) {
			var orderItems = getOrderItems();
			var variables.quantityDelivered = 0;
			for(var i=1; i<=arrayLen(orderitems); i++) {
				variables.quantityDelivered += orderItems[i].getQuantityDelivered();
			}
		}
		return variables.quantityDelivered;
	}
	
	public numeric function getQuantityUndelivered() {
		return this.getTotalQuantity() - this.getQuantityDelivered();
	}
	
	public numeric function getSubtotal() {
		var subtotal = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			subtotal += getOrderItems()[i].getExtendedPrice();
		}
		return subtotal;
	}
	
	public numeric function getTaxTotal() {
		var taxTotal = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			taxTotal += getOrderItems()[i].getTaxAmount();
		}
		return taxTotal;
	}
	
	public numeric function getItemDiscountAmountTotal() {
		var discountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			discountTotal += getOrderItems()[i].getDiscountAmount();
		}
		return discountTotal;
	}
	
	public numeric function getFulfillmentDiscountAmountTotal() {
		return 0;
	}
	
	public numeric function getOrderDiscountAmountTotal() {
		return 0;
	}
	
	public numeric function getDiscountTotal() {
		return getItemDiscountAmountTotal() + getFulfillmentDiscountAmountTotal() + getOrderDiscountAmountTotal();
	}
	
	public numeric function getFulfillmentTotal() {
		var fulfillmentTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			fulfillmentTotal += getOrderFulfillments()[i].getFulfillmentCharge();
		}
		return fulfillmentTotal;
	}
	
	public numeric function getFulfillmentRefundTotal() {
		var fulfillmentRefundTotal = 0;
		for(var i=1; i<=arrayLen(getOrderReturns()); i++) {
			fulfillmentRefundTotal += getOrderReturns()[i].getFulfillmentRefundAmount();
		}
		
		return fulfillmentRefundTotal;
	}
	
	public numeric function getTotal() {
		return getSubtotal() + getTaxTotal() + getFulfillmentTotal() + getFulfillmentRefundTotal() - getDiscountTotal();
	}
	
	public void function removeAllOrderItems() {
		for(var i=arrayLen(getOrderItems()); i >= 1; i--) {
			getOrderItems()[i].removeOrder(this);
		}
	}
	
	public any function getOrderNumber() {
		if(isNull(variables.orderNumber)) {
			variables.orderNumber = "";
			confirmOrderNumberOpenDateCloseDate();
		}
		return variables.orderNumber;
	}
	
    // Get the sum of all the payment amounts
	public numeric function getPaymentAmountTotal() {
		var totalPayments = 0;
		
		var orderPayments = getOrderPayments();
		for(var i=1; i<=arrayLen(orderPayments); i++) {
			totalPayments += orderPayments[i].getAmount();
		}
		
		return totalPayments;
	}
	
	public numeric function getPaymentAmountAuthorizedTotal() {
		var totalPaymentsAuthorized = 0;
		
		var orderPayments = getOrderPayments();
		for(var i=1; i<=arrayLen(orderPayments); i++) {
			totalPaymentsAuthorized += orderPayments[i].getAmountAuthorized();
		}
		
		return totalPaymentsAuthorized;
	}
	
	public numeric function getPaymentAmountReceivedTotal() {
		var totalPaymentsReceived = 0;
		
		var orderPayments = getOrderPayments();
		for(var i=1; i<=arrayLen(orderPayments); i++) {
			totalPaymentsReceived += orderPayments[i].getAmountReceived();
		}
		
		return totalPaymentsReceived;
	}
	
	public boolean function isPaid() {
		if(this.getPaymentAmountReceivedTotal() < getTotal()) {
			return false;
		} else {
			return true;
		}
	}
	
	public any function getActionOptions() {
		var smartList = getService("orderService").getOrderStatusActionSmartList();
		//smartList.joinRelatedProperty("SlatwallOrderStatusAction", "orderStatusType", "inner", false);
		smartList.addFilter("orderStatusType_typeID", getOrderStatusType().getTypeID());
		//smartList.addSelect(propertyIdentifier="orderActionType_type", alias="name");
		//smartList.addSelect(propertyIdentifier="orderActionType_typeID", alias="value");
		//return smartList.getHQL();
		return smartList.getRecords(); 
	}
	
 	
	// @hint: This is called from the ORM Event to setup an OrderNumber when an order is placed
	private void function confirmOrderNumberOpenDateCloseDate() {
		if((isNull(variables.orderNumber) || variables.orderNumber == "") && !isNUll(getOrderStatusType()) && !isNull(getOrderStatusType().getSystemCode()) && getOrderStatusType().getSystemCode() != "ostNotPlaced") {
			var maxOrderNumber = ormExecuteQuery("SELECT max(cast(aslatwallorder.orderNumber as int)) as maxOrderNumber FROM SlatwallOrder aslatwallorder");
			if( arrayIsDefined(maxOrderNumber,1) ){
				setOrderNumber(maxOrderNumber[1] + 1);
			} else {
				setOrderNumber(1);
			}
			setOrderOpenDateTime(now());
		}
		if(!isNull(getOrderStatusType()) && !isNull(getOrderStatusType().getSystemCode()) && getOrderStatusType().getSystemCode() == "ostClosed" && isNull(getOrderCloseDateTime())) {
			setOrderCloseDateTime(now());
		}
	} 
	
	public numeric function getPreviouslyReturnedFulfillmentTotal() {
		return getService("OrderService").getPreviouslyReturnedFulfillmentTotal(getOrderId());
	}
	
	
	// A helper to loop over all deliveries, and grab all of the items of each and put them into a single array 
	public array function getDeliveredOrderItems() {
		var arr = [];
		var deliveries = getOrderDeliveries();
		for(var i=1; i <= ArrayLen(deliveries); i++) {
			var deliveryItems = deliveries[i].getOrderDeliveryItems();
			
			for(var j=1; j <= ArrayLen(deliveryItems); j++) {
				ArrayAppend(arr, deliveryItems[j].getOrderItem());
			}
		}
		
		return arr;
	}
	
    
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================

	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasOrder( this )) {
			arrayAppend(arguments.account.getOrders(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getOrders(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getOrders(), index);
		}
		structDelete(variables, "account");
	}
	
	// Refrenced Order (many-to-one)
	public void function setRefrencedOrder(required any refrencedOrder) {
		variables.refrencedOrder = arguments.refrencedOrder;
		if(isNew() or !arguments.refrencedOrder.hasRefrencingOrder( this )) {
			arrayAppend(arguments.refrencedOrder.getRefrencingOrders(), this);
		}
	}
	public void function removeRefrencedOrder(any refrencedOrder) {
		if(!structKeyExists(arguments, "refrencedOrder")) {
			arguments.refrencedOrder = variables.refrencedOrder;
		}
		var index = arrayFind(arguments.refrencedOrder.getRefrencingOrders(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getRefrencingOrders(), index);
		}
		structDelete(variables, "refrencedOrder");
	}

	// Order Items (one-to-many)
	public void function addOrderItem(required any orderItem) {
		arguments.orderItem.setOrder( this );
	}
	public void function removeOrderItem(required any orderItem) {
		arguments.orderItem.removeOrder( this );
	}

	// Order Deliveries (one-to-many)
	public void function addOrderDelivery(required any orderDelivery) {
		arguments.orderDelivery.setOrder( this );
	}
	public void function removeOrderDelivery(required any orderDelivery) {
		arguments.orderDelivery.removeOrder( this );
	}

	// Order Fulfillments (one-to-many)
	public void function addOrderFulfillment(required any orderFulfilment) {
		arguments.orderFulfilment.setOrder( this );
	}
	public void function removeOrderFulfillment(required any orderFulfilment) {
		arguments.orderFulfilment.removeOrder( this );
	}

	// Order Payments (one-to-many)
	public void function addOrderPayment(required any orderPayment) {
		arguments.orderPayment.setOrder( this );
	}
	public void function removeOrderPayment(required any orderPayment) {
		arguments.orderPayment.removeOrder( this );
	}

	// Order Returns (one-to-many)
	public void function addOrderReturn(required any orderReturn) {
		arguments.orderReturn.setOrder( this );
	}
	public void function removeOrderReturn(required any orderReturn) {
		arguments.orderReturn.removeOrder( this );
	}
	
	// Refrencing Order Items (one-to-many)
	public void function addRefrencingOrderItem(required any refrencingOrderItem) {
		arguments.refrencingOrderItem.setRefrencedOrder( this );
	}
	public void function removeRefrencingOrderItem(required any refrencingOrderItem) {
		arguments.refrencingOrderItem.removeRefrencedOrder( this );
	}
	
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		confirmOrderNumberOpenDateCloseDate();
	}
	
	public void function preUpdate(Struct oldData){
		super.preUpdate();
		confirmOrderNumberOpenDateCloseDate();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
