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
component displayname="Order" entityname="SlatwallOrder" table="SwOrder" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this" hb_processContexts="create,addSaleOrderItem,placeOrder,createReturn,placeOnHold,takeOffHold,cancelOrder,addPromotionCode" {
	
	// Persistent Properties
	property name="orderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderNumber" ormtype="string";
	property name="currencyCode" ormtype="string" length="3";
	property name="orderOpenDateTime" ormtype="timestamp";
	property name="orderOpenIPAddress" ormtype="string";
	property name="orderCloseDateTime" ormtype="timestamp";
	
	// Calculated Properties
	property name="calculatedTotal" ormtype="big_decimal";
	
	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="referencedOrder" cfc="Order" fieldtype="many-to-one" fkcolumn="referencedOrderID";	// Points at the "parent" (NOT return) order.
	property name="orderType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderType";
	property name="orderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderStatusType";
	property name="orderOrigin" cfc="OrderOrigin" fieldtype="many-to-one" fkcolumn="orderOriginID";
	
	// Related Object Properties (one-To-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderItems" hb_populateEnabled="public" singularname="orderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderDeliveries" singularname="orderDelivery" cfc="OrderDelivery" fieldtype="one-to-many" fkcolumn="orderID" cascade="delete-orphan" inverse="true";
	property name="orderFulfillments" hb_populateEnabled="public" singularname="orderFulfillment" cfc="OrderFulfillment" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderPayments" hb_populateEnabled="public" singularname="orderPayment" cfc="OrderPayment" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderReturns" hb_populateEnabled="public" singularname="orderReturn" cfc="OrderReturn" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="stockReceivers" singularname="stockReceiver" cfc="StockReceiver" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="referencingOrders" singularname="referencingOrder" cfc="Order" fieldtype="one-to-many" fkcolumn="referencedOrderID" cascade="all-delete-orphan" inverse="true";
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" cfc="AccountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all" inverse="true";
	
	// Related Object Properties (many-To-many - owner)
	property name="promotionCodes" singularname="promotionCode" cfc="PromotionCode" fieldtype="many-to-many" linktable="SwOrderPromotionCode" fkcolumn="orderID" inversejoincolumn="promotionCodeID";
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non persistent properties
	property name="addOrderItemSkuOptionsSmartList" persistent="false";
	property name="addOrderItemStockOptionsSmartList" persistent="false";
	property name="addPaymentRequirementDetails" persistent="false";
	property name="deliveredItemsAmountTotal" persistent="false";
	property name="discountTotal" persistent="false" hb_formatType="currency";
	property name="dynamicChargeOrderPayment" persistent="false";
	property name="dynamicCreditOrderPayment" persistent="false";
	property name="dynamicChargeOrderPaymentAmount" persistent="false" hb_formatType="currency";
	property name="dynamicCreditOrderPaymentAmount" persistent="false" hb_formatType="currency";
	property name="eligiblePaymentMethodDetails" persistent="false";
	property name="itemDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentRefundTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeAfterDiscountTotal" persistent="false" hb_formatType="currency";
	property name="orderDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="orderPaymentAmountNeeded" persistent="false" hb_formatType="currency";
	property name="orderPaymentChargeAmountNeeded" persistent="false" hb_formatType="currency";
	property name="orderPaymentCreditAmountNeeded" persistent="false" hb_formatType="currency";
	property name="orderPaymentRefundOptions" persistent="false";
	property name="orderRequirementsList" persistent="false";
	property name="orderTypeOptions" persistent="false";
	property name="paymentAmountTotal" persistent="false" hb_formatType="currency";
	property name="paymentAmountReceivedTotal" persistent="false" hb_formatType="currency";
	property name="paymentAmountCreditedTotal" persistent="false" hb_formatType="currency";
	property name="paymentAmountDue" persistent="false" hb_formatType="currency";
	property name="paymentMethodOptionsSmartList" persistent="false";
	property name="promotionCodeList" persistent="false";
	property name="quantityDelivered" persistent="false";
	property name="quantityUndelivered" persistent="false";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	property name="returnItemSmartList" persistent="false";
	property name="referencingPaymentAmountCreditedTotal" persistent="false" hb_formatType="currency";
	property name="saleItemSmartList" persistent="false";
	property name="statusCode" persistent="false";
	property name="subTotal" persistent="false" hb_formatType="currency";
	property name="subTotalAfterItemDiscounts" persistent="false" hb_formatType="currency";
	property name="taxTotal" persistent="false" hb_formatType="currency";
	property name="total" persistent="false" hb_formatType="currency";
	property name="totalItems" persistent="false";
	property name="totalQuantity" persistent="false";
	property name="totalSaleQuantity" persistent="false";
	property name="totalReturnQuantity" persistent="false";
	
	public string function getStatus() {
		return getOrderStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderStatusType().getSystemCode();
	}
	
	public string function getType(){
		return getOrderType().getType();
	}
	
	public string function getTypeCode(){
		return getOrderType().getSystemCode();
	}
	
	public boolean function hasItemsQuantityWithinMaxOrderQuantity() {
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if(!getOrderItems()[i].hasQuantityWithinMaxOrderQuantity()) {
				return false;
			}
		}
		return true;
	}
	
	public struct function getAddPaymentRequirementDetails() {
		if(!structKeyExists(variables, "addPaymentRequirementDetails")) {
			variables.addPaymentRequirementDetails = {};
			var requiredAmount = precisionEvaluate(getTotal() - getPaymentAmountTotal());
			if(requiredAmount > 0) {
				variables.addPaymentRequirementDetails.amount = requiredAmount;
				variables.addPaymentRequirementDetails.orderPaymentType = getService("settingService").getTypeBySystemCode("optCharge"); 
			} else if (requiredAmount < 0) {
				variables.addPaymentRequirementDetails.amount = requiredAmount * -1;
				variables.addPaymentRequirementDetails.orderPaymentType = getService("settingService").getTypeBySystemCode("optCredit");
			}
		}
		return variables.addPaymentRequirementDetails;
	}
	
	public void function removeAllOrderItems() {
		for(var i=arrayLen(getOrderItems()); i >= 1; i--) {
			getOrderItems()[i].removeOrder(this);
		}
	}
	
	public any function getOrderNumber() {
		if(isNull(variables.orderNumber)) {
			confirmOrderNumberOpenDateCloseDatePaymentAmount();
			if(isNull(variables.orderNumber)) {
				return "";
			}
		}
		return variables.orderNumber;
	}
	
    public boolean function isPaid() {
		if(this.getPaymentAmountReceivedTotal() < getTotal()) {
			return false;
		} else {
			return true;
		}
	}
	
	// @hint: This is called from the ORM Event to setup an OrderNumber when an order is placed
	public void function confirmOrderNumberOpenDateCloseDatePaymentAmount() {
		
		// If the order is open, and has no open dateTime
		if((isNull(variables.orderNumber) || variables.orderNumber == "") && !isNUll(getOrderStatusType()) && !isNull(getOrderStatusType().getSystemCode()) && getOrderStatusType().getSystemCode() != "ostNotPlaced") {
			if(setting('globalOrderNumberGeneration') == "Internal" || setting('globalOrderNumberGeneration') == "") {
				var maxOrderNumber = getService("orderService").getMaxOrderNumber();
				if( arrayIsDefined(maxOrderNumber,1) ){
					setOrderNumber(maxOrderNumber[1] + 1);
				} else {
					setOrderNumber(1);
				}
			} else {
				setOrderNumber( getService("integrationService").getIntegrationByIntegrationPackage( setting('globalOrderNumberGeneration') ).getIntegrationCFC().getNewOrderNumber(order=this) );
			}
			
			setOrderOpenDateTime( now() );
			setOrderOpenIPAddress( CGI.REMOTE_ADDR );
			
			// Loop over the order payments to setAmount = getAmount so that any null payments get explicitly defined
			for(var orderPayment in getOrderPayments()) {
				orderPayment.setAmount( orderPayment.getAmount() );
			}
			
			// Loop over the order fulfillments to remove and accountAddresses
			for(var orderFulfillment in getOrderFulfillments()) {
				orderFulfillment.setAccountAddress( javaCast("null", "") );
			}
		}
		
		// If the order is closed, and has no close dateTime
		if(!isNull(getOrderStatusType()) && !isNull(getOrderStatusType().getSystemCode()) && getOrderStatusType().getSystemCode() == "ostClosed" && isNull(getOrderCloseDateTime())) {
			setOrderCloseDateTime( now() );
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
	
	public any function getAddOrderItemSkuOptionsSmartList() {
		if(!structKeyExists(variables, "addOrderItemSkuOptionsSmartList")) {
			variables.addOrderItemSkuOptionsSmartList = getService("skuService").getSkuSmartList();
			variables.addOrderItemSkuOptionsSmartList.addFilter('activeFlag', 1);
			variables.addOrderItemSkuOptionsSmartList.addFilter('product.activeFlag', 1);
			variables.addOrderItemSkuOptionsSmartList.joinRelatedProperty('SlatwallProduct', 'productType', 'inner');
			variables.addOrderItemSkuOptionsSmartList.joinRelatedProperty('SlatwallProduct', 'brand', 'left');
		}
		return variables.addOrderItemSkuOptionsSmartList;
	}
	
	public any function getAddOrderItemStockOptionsSmartList() {
		if(!structKeyExists(variables, "addOrderItemStockOptionsSmartList")) {
			variables.addOrderItemStockOptionsSmartList = getService("stockService").getStockSmartList();
			variables.addOrderItemStockOptionsSmartList.addFilter('sku.activeFlag', 1);
			variables.addOrderItemStockOptionsSmartList.addFilter('sku.product.activeFlag', 1);
			variables.addOrderItemStockOptionsSmartList.joinRelatedProperty('SlatwallProduct', 'productType', 'inner');
			variables.addOrderItemStockOptionsSmartList.joinRelatedProperty('SlatwallProduct', 'brand', 'left');
		}
		return variables.addOrderItemStockOptionsSmartList;
	}
	
	public numeric function getDeliveredItemsAmountTotal() {
		if(!structKeyExists(variables, "deliveredItemsAmountTotal")) {
			
			variables.deliveredItemsAmountTotal = 0;
			var fulfillmentChargeAddedList = "";
			
			for(var orderItem in getOrderItems()) {
				
				if(orderItem.getQuantityDelivered()) {
					
					variables.deliveredItemsAmountTotal = precisionEvaluate(variables.deliveredItemsAmountTotal + ((orderItem.getQuantityDelivered() / orderItem.getQuantity()) * orderItem.getItemTotal()));
					
					if(!listFindNoCase(fulfillmentChargeAddedList, orderItem.getOrderFulfillment().getOrderFulfillmentID())) {
						
						listAppend(fulfillmentChargeAddedList, orderItem.getOrderFulfillment().getOrderFulfillmentID());
						
						variables.deliveredItemsAmountTotal = precisionEvaluate(variables.deliveredItemsAmountTotal + orderItem.getOrderFulfillment().getChargeAfterDiscount());
					}
				}
			}
		}
		return variables.deliveredItemsAmountTotal;
	}
	
	public numeric function getDiscountTotal() {
		return precisionEvaluate(getItemDiscountAmountTotal() + getFulfillmentDiscountAmountTotal() + getOrderDiscountAmountTotal());
		
	}
	
	public array function getEligiblePaymentMethodDetails() {
		if(!structKeyExists(variables, "eligiblePaymentMethodDetails")) {
			variables.eligiblePaymentMethodDetails = getService("paymentService").getEligiblePaymentMethodDetailsForOrder( order=this );
		}
		return variables.eligiblePaymentMethodDetails;
	}
	
	public numeric function getItemDiscountAmountTotal() {
		var discountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if( getOrderItems()[i].getTypeCode() == "oitSale" ) {
				discountTotal = precisionEvaluate(discountTotal + getOrderItems()[i].getDiscountAmount());
			} else if ( getOrderItems()[i].getTypeCode() == "oitReturn" ) {
				discountTotal = precisionEvaluate(discountTotal - getOrderItems()[i].getDiscountAmount());
			} else {
				throw("there was an issue calculating the itemDiscountAmountTotal because of a orderItemType associated with one of the items");
			}
		}
		return discountTotal;
	}
	
	public numeric function getFulfillmentDiscountAmountTotal() {
		var discountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			discountTotal = precisionEvaluate(discountTotal + getOrderFulfillments()[i].getDiscountAmount());
		}
		return discountTotal;
	}

	public numeric function getFulfillmentTotal() {
		var fulfillmentTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			fulfillmentTotal = precisionEvaluate(fulfillmentTotal + getOrderFulfillments()[i].getFulfillmentCharge());
		}
		return fulfillmentTotal;
	}
	
	public numeric function getFulfillmentRefundTotal() {
		var fulfillmentRefundTotal = 0;
		for(var i=1; i<=arrayLen(getOrderReturns()); i++) {
			fulfillmentRefundTotal = precisionEvaluate(fulfillmentRefundTotal + getOrderReturns()[i].getFulfillmentRefundAmount());
		}
		
		return fulfillmentRefundTotal;
	}
	
	public numeric function getFulfillmentChargeAfterDiscountTotal() {
		var fulfillmentChargeAfterDiscountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			fulfillmentChargeAfterDiscountTotal = precisionEvaluate(fulfillmentChargeAfterDiscountTotal + getOrderFulfillments()[i].getChargeAfterDiscount());
		}
		
		return fulfillmentChargeAfterDiscountTotal;
	}
	
	public numeric function getOrderDiscountAmountTotal() {
		var discountAmount = 0;

		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = precisionEvaluate(discountAmount + getAppliedPromotions()[i].getDiscountAmount());
		}

		return discountAmount;
	}
	
	public any function getOrderRequirementsList() {
		return getService("orderService").getOrderRequirementsList(order=this);
	}
	
	public numeric function getOrderPaymentAmountNeeded() {
		
		var nonNullPayments = getService("orderService").getOrderPaymentNonNullAmountTotal(orderID=getOrderID());
		var orderPaymentAmountNeeded = precisionEvaluate(getTotal() - nonNullPayments);
		
		if(orderPaymentAmountNeeded gt 0 && isNull(getDynamicChargeOrderPayment())) {
			return orderPaymentAmountNeeded;
		} else if (orderPaymentAmountNeeded lt 0 && isNull(getDynamicCreditOrderPayment())) {
			return orderPaymentAmountNeeded;
		}
		
		return 0;
		
	}
	
	public numeric function getOrderPaymentChargeAmountNeeded() {
		var orderPaymentAmountNeeded = getOrderPaymentAmountNeeded();
		if(orderPaymentAmountNeeded lt 0) {
			return 0;
		}
		return orderPaymentAmountNeeded;
	}
	
	public numeric function getOrderPaymentCreditAmountNeeded() {
		var orderPaymentAmountNeeded = getOrderPaymentAmountNeeded();
		if(orderPaymentAmountNeeded gt 0) {
			return 0;
		}
		return orderPaymentAmountNeeded * -1;
	}
	
	public any function getDynamicChargeOrderPayment() {
		var returnOrderPayment = javaCast("null", "");
		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive" && orderPayment.getOrderPaymentType().getSystemCode() eq 'optCharge' && orderPayment.getDynamicAmountFlag()) {
				if(!orderPayment.getNewFlag() || isNull(returnOrderPayment)) {
					returnOrderPayment = orderPayment;
				}
			}
		}
		if(!isNull(returnOrderPayment)) {
			return returnOrderPayment;
		}
	}
	
	public any function getDynamicCreditOrderPayment() {
		var returnOrderPayment = javaCast("null", "");
		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive" && orderPayment.getOrderPaymentType().getSystemCode() eq 'optCredit' && orderPayment.getDynamicAmountFlag()) {
				if(!orderPayment.getNewFlag() || isNull(returnOrderPayment)) {
					returnOrderPayment = orderPayment;
				}
			}
		}
		if(!isNull(returnOrderPayment)) {
			return returnOrderPayment;
		}
	}
	
	public any function getDynamicChargeOrderPaymentAmount() {
		var nonNullPayments = getService("orderService").getOrderPaymentNonNullAmountTotal(orderID=getOrderID());
		var orderPaymentAmountNeeded = precisionEvaluate(getTotal() - nonNullPayments);
		
		if(orderPaymentAmountNeeded gt 0) {
			return orderPaymentAmountNeeded;
		}
		
		return 0;
	}
	
	public any function getDynamicCreditOrderPaymentAmount() {
		var nonNullPayments = getService("orderService").getOrderPaymentNonNullAmountTotal(orderID=getOrderID());
		var orderPaymentAmountNeeded = precisionEvaluate(getTotal() - nonNullPayments);
		
		if(orderPaymentAmountNeeded lt 0) {
			return orderPaymentAmountNeeded * -1;
		}
		
		return 0;
	}
	
	public numeric function getPaymentAmountTotal() {
		var totalPayments = 0;
		
		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive" && !orderPayment.hasErrors()) {
				if(orderPayment.getOrderPaymentType().getSystemCode() eq 'optCharge') {
					totalPayments = precisionEvaluate(totalPayments + orderPayment.getAmount());	
				} else {
					totalPayments = precisionEvaluate(totalPayments - orderPayment.getAmount());
				}
			}
		}
		
		return totalPayments;
	}
	
	public numeric function getPaymentAmountDue(){
		return precisionEvaluate(getTotal() - getPaymentAmountReceivedTotal() + getPaymentAmountCreditedTotal());
	}
	
	public numeric function getPaymentAmountAuthorizedTotal() {
		var totalPaymentsAuthorized = 0;
		
		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsAuthorized = precisionEvaluate(totalPaymentsAuthorized + orderPayment.getAmountAuthorized());	
			}
		}
		
		return totalPaymentsAuthorized;
	}
	
	public numeric function getPaymentAmountReceivedTotal() {
		var totalPaymentsReceived = 0;
		
		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsReceived = precisionEvaluate(totalPaymentsReceived + orderPayment.getAmountReceived());
			}
		}
		
		return totalPaymentsReceived;
	}
	
	public numeric function getPaymentAmountCreditedTotal() {
		var totalPaymentsCredited = 0;
		
		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsCredited = precisionEvaluate(totalPaymentsCredited + orderPayment.getAmountCredited());
			}
		}
		
		return totalPaymentsCredited;
	}
	
	public numeric function getReferencingPaymentAmountCreditedTotal() {
		var totalReferencingPaymentsCredited = 0;
		
		for(var orderPayment in getOrderPayments()) {
			for(var referencingOrderPayment in orderPayment.getReferencingOrderPayments()) {
				if(referencingOrderPayment.getStatusCode() eq "opstActive") {
					totalReferencingPaymentsCredited = precisionEvaluate(totalReferencingPaymentsCredited + referencingOrderPayment.getAmountCredited());	
				}
			}
		}
		
		return totalReferencingPaymentsCredited;
	}
	
	public any function getPaymentMethodOptionsSmartList() {
		if(!structKeyExists(variables, "paymentMethodOptionsSmartList")) {
			variables.paymentMethodOptionsSmartList = getService("paymentService").getPaymentMethodSmartList();
			variables.paymentMethodOptionsSmartList.addFilter("activeFlag", 1);
		}
		return variables.paymentMethodOptionsSmartList;
	}
	
	public array function getOrderPaymentRefundOptions() {
		if(!structKeyExists(variables, "orderPaymentRefundOptions")) {
			variables.orderPaymentRefundOptions = [];
			for(var orderPayment in getOrderPayments()) {
				if(orderPayment.getStatusCode() eq 'opstActive') {
					arrayAppend(variables.orderPaymentRefundOptions, {name=orderPayment.getSimpleRepresentation(), value=orderPayment.getOrderPaymentID()});	
				}
			}
			arrayAppend(variables.orderPaymentRefundOptions, {name=rbKey('define.none'), value=''});
		}
		return variables.orderPaymentRefundOptions;
	}
	
	public array function getOrderTypeOptions() {
		if(!structKeyExists(variables, "orderTypeOptions")) {
			var sl = getPropertyOptionsSmartList("orderType");
			var inFilter = "otExchangeOrder,otSalesOrder,otReturnOrder";
			if(getSaleItemSmartList().getRecordsCount() gt 0) {
				inFilter = listDeleteAt(inFilter, listFindNoCase(inFilter, "otReturnOrder"));
			}
			if(getReturnItemSmartList().getRecordsCount() gt 0) {
				inFilter = listDeleteAt(inFilter, listFindNoCase(inFilter, "otSalesOrder"));
			}
			sl.addInFilter('systemCode', inFilter);
			sl.addSelect('type', 'name');
			sl.addSelect('typeID', 'value');
			
			variables.orderTypeOptions = sl.getRecords();
		}
		return variables.orderTypeOptions;
	}
	
	public string function getPromotionCodeList() {
		var promotionCodeList = "";
		
		for(var promotionCodeEntity in getPromotionCodes()) {
			promotionCodeList = listAppend(promotionCodeList, promotionCodeEntity.getPromotionCode());
		}
		
		return promotionCodeList;
	}
	
	public numeric function getDeliveredItemsPaymentAmountUnreceived() {
		var received = getPaymentAmountReceivedTotal();
		var amountDelivered = 0;
		
		for(var f=1; f<=arrayLen(getOrderFulfillments()); f++) {
			// If this fulfillment is fully delivered, then just add the entire amount
			if(getOrderFulfillments()[f].getQuantityUndelivered() == 0) {
				amountDelivered = precisionEvaluate(amountDelivered + getOrderFulfillments()[f].getFulfillmentTotal());
				
			// If this fulfillment has at least one item delivered
			} else if(getOrderFulfillments()[f].getQuantityDelivered() > 0) {
				
				// Add the fulfillmentCharge
				amountDelivered = precisionEvaluate(amountDelivered + getOrderFulfillments()[f].getChargeAfterDiscount());
				
				// Loop over the fulfillmentItems and add each of the amounts to the total amount delivered
				for(var i=1; i<=arrayLen(getOrderFulfillments()[f].getOrderFulfillmentItems()); i++) {
					var item = getOrderFulfillments()[f].getOrderFulfillmentItems()[i];
					
					if(item.getQuantityUndelivered() == 0) {
						amountDelivered = precisionEvaluate(amountDelivered + item.getItemTotal());
					} else if (item.getQuantityDelivered() > 0) {
						var itemQDValue = (round(item.getItemTotal() * (item.getQuantityDelivered() / item.getQuantity()) * 100) / 100);
						amountDelivered = precisionEvaluate(amountDelivered + itemQDValue);
					}
					
				}
			}
		}
		
		return precisionEvaluate(amountDelivered - getPaymentAmountReceivedTotal());
	}
	
	
	
	public numeric function getTotalQuantity() {
		var totalQuantity = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			totalQuantity += getOrderItems()[i].getQuantity(); 
		}
		
		return totalQuantity;
	}
	
	public numeric function getTotalSaleQuantity() {
		var saleQuantity = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if(getOrderItems()[1].getOrderItemType().getSystemCode() eq "oitSale") {
				saleQuantity += getOrderItems()[i].getQuantity();	
			}
		}
		return saleQuantity;
	}
	
	public numeric function getTotalReturnQuantity() {
		var returnQuantity = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if(getOrderItems()[1].getOrderItemType().getSystemCode() eq "oitReturn") {
				returnQuantity += getOrderItems()[i].getQuantity();	
			}
		}
		return returnQuantity;
	}
	
	public numeric function getQuantityDelivered() {
		var quantityDelivered = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			quantityDelivered += getOrderItems()[i].getQuantityDelivered();
		}
		return quantityDelivered;
	}
	
	public numeric function getQuantityUndelivered() {
		return this.getTotalSaleQuantity() - this.getQuantityDelivered();
	}
	
	public numeric function getQuantityReceived() {
		var quantityReceived = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			quantityReceived += getOrderItems()[i].getQuantityReceived();
		}
		return quantityReceived;
	}
	
	public numeric function getQuantityUnreceived() {
		return this.getTotalReturnQuantity() - this.getQuantityReceived();
	}
	
	public any function getSaleItemSmartList() {
		if(!structKeyExists(variables, "saleItemSmartList")) {
			variables.saleItemSmartList = getService("orderService").getOrderItemSmartList();
			variables.saleItemSmartList.addFilter('order.orderID', getOrderID());
			variables.saleItemSmartList.addInFilter('orderItemType.systemCode', 'oitSale');
		}
		return variables.saleItemSmartList;	
	}
	
	public any function getReturnItemSmartList() {
		if(!structKeyExists(variables, "returnItemSmartList")) {
			variables.returnItemSmartList = getService("orderService").getOrderItemSmartList();
			variables.returnItemSmartList.addFilter('order.orderID', getOrderID());
			variables.returnItemSmartList.addInFilter('orderItemType.systemCode', 'oitReturn');
		}
		return variables.returnItemSmartList;	
	}
	
	public numeric function getSubtotal() {
		var subtotal = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if( getOrderItems()[i].getTypeCode() == "oitSale" ) {
				subtotal = precisionEvaluate(subtotal + getOrderItems()[i].getExtendedPrice());	
			} else if ( getOrderItems()[i].getTypeCode() == "oitReturn" ) {
				subtotal = precisionEvaluate(subtotal - getOrderItems()[i].getExtendedPrice());
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return subtotal;
	}
	
	public numeric function getSubtotalAfterItemDiscounts() {
		return precisionEvaluate(getSubtotal() - getItemDiscountAmountTotal());
	}
	
	public numeric function getTaxTotal() {
		var taxTotal = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if( getOrderItems()[i].getTypeCode() == "oitSale" ) {
				taxTotal = precisionEvaluate(taxTotal + getOrderItems()[i].getTaxAmount());	
			} else if ( getOrderItems()[i].getTypeCode() == "oitReturn" ) {
				taxTotal = precisionEvaluate(taxTotal - getOrderItems()[i].getTaxAmount());
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return taxTotal;
	}
	
	public numeric function getTotal() {
		return precisionEvaluate(getSubtotal() + getTaxTotal() + getFulfillmentTotal() - getFulfillmentRefundTotal() - getDiscountTotal());
	}
	
	public numeric function getTotalItems() {
		return arrayLen(getOrderItems());
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================

	// Account (many-to-one)
	public any function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasOrder( this )) {
			arrayAppend(arguments.account.getOrders(), this);
		}
		return this;
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
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setOrder( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeOrder( this );    
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
			arrayDeleteAt(arguments.refrencedOrder.getRefrencingOrders(), index);
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
	public void function addOrderFulfillment(required any orderFulfillment) {
		arguments.orderFulfillment.setOrder( this );
	}
	public void function removeOrderFulfillment(required any orderFulfillment) {
		arguments.orderFulfillment.removeOrder( this );
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
	
	// Stock Receivers (one-to-many)    
	public void function addStockReceiver(required any stockReceiver) {    
		arguments.stockReceiver.setOrder( this );    
	}    
	public void function removeStockReceiver(required any stockReceiver) {    
		arguments.stockReceiver.removeOrder( this );    
	}
	
	// Refrencing Order Items (one-to-many)
	public void function addRefrencingOrderItem(required any refrencingOrderItem) {
		arguments.refrencingOrderItem.setRefrencedOrder( this );
	}
	public void function removeRefrencingOrderItem(required any refrencingOrderItem) {
		arguments.refrencingOrderItem.removeRefrencedOrder( this );
	}
	
	// Applied Promotions (one-to-many)
	public void function addAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.setOrder( this );
	}
	public void function removeAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.removeOrder( this );
	}
	
	// Promotion Codes (many-to-many - owner)
	public void function addPromotionCode(required any promotionCode) {
		if(arguments.promotionCode.isNew() or !hasPromotionCode(arguments.promotionCode)) {
			arrayAppend(variables.promotionCodes, arguments.promotionCode);
		}
		if(isNew() or !arguments.promotionCode.hasOrder( this )) {
			arrayAppend(arguments.promotionCode.getOrders(), this);
		}
	}
	public void function removePromotionCode(required any promotionCode) {
		var thisIndex = arrayFind(variables.promotionCodes, arguments.promotionCode);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.promotionCodes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.promotionCode.getOrders(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.promotionCode.getOrders(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public any function getOrderStatusType() {
		if(isNull(variables.orderStatusType)) {
			variables.orderStatusType = getService("settingService").getTypeBySystemCode('ostNotPlaced');
		}
		return variables.orderStatusType;
	}
	
	public any function getOrderType() {
		if(isNull(variables.orderType)) {
			variables.orderType = getService("settingService").getTypeBySystemCode('otSalesOrder');
		}
		return variables.orderType;
	}
	
	// ==============  END: Overridden Implicet Getters ====================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "orderNumber";
	}
	
	public string function getSimpleRepresentation() {
		if(!isNull(getOrderNumber()) && len(getOrderNumber())) {
			var representation = getOrderNumber();
		} else {
			var representation = rbKey('define.cart');
		}
		
		if(!isNull(getAccount())) {
			representation &= " - #getAccount().getFullname()#";
		}
		
		return representation;
	}
	
	public any function getReferencingOrdersSmartList() {
		if(!structKeyExists(variables, "referencingOrdersSmartList")) {
			variables.referencingOrdersSmartList = getService("orderService").getOrderSmartList();
			variables.referencingOrdersSmartList.addFilter('referencedOrder.orderID', getOrderID());
		}
		return variables.referencingOrdersSmartList;
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		
		// Verify Defaults are Set
		getOrderType();
		getOrderStatusType();
		
		confirmOrderNumberOpenDateCloseDatePaymentAmount();
	}
	
	public void function preUpdate(Struct oldData){
		super.preUpdate(argumentCollection=arguments);
		confirmOrderNumberOpenDateCloseDatePaymentAmount();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

