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
component displayname="Order" entityname="SlatwallOrder" table="SwOrder" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this" hb_processContexts="addOrderItem,addOrderPayment,addPromotionCode,cancelOrder,changeCurrencyCode,clear,create,createReturn,duplicateOrder,placeOrder,placeOnHold,removeOrderItem,removeOrderPayment,removePersonalInfo,removePromotionCode,takeOffHold,updateStatus,updateOrderAmounts,updateOrderFulfillment" {

	// Persistent Properties
	property name="orderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderNumber" ormtype="string";
	property name="currencyCode" ormtype="string" length="3";
	property name="orderOpenDateTime" ormtype="timestamp";
	property name="orderOpenIPAddress" ormtype="string";
	property name="orderCloseDateTime" ormtype="timestamp";
	property name="referencedOrderType" ormtype="string" hb_formatType="rbKey";
	property name="estimatedDeliveryDateTime" ormtype="timestamp";
	property name="estimatedFulfillmentDateTime" ormtype="timestamp";
	// Calculated Properties
	property name="calculatedTotal" ormtype="big_decimal";

	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="assignedAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="assignedAccountID";
	property name="billingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="billingAccountAddressID";
	property name="billingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID";
	property name="defaultStockLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="orderType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderType";
	property name="orderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderStatusType";
	property name="orderOrigin" cfc="OrderOrigin" fieldtype="many-to-one" fkcolumn="orderOriginID" hb_optionsNullRBKey="define.none";
	property name="referencedOrder" cfc="Order" fieldtype="many-to-one" fkcolumn="referencedOrderID";	// Points at the "parent" (NOT return) order.
	property name="shippingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="shippingAccountAddressID";
	property name="shippingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderCreatedSite" hb_populateEnabled="public" cfc="Site" fieldtype="many-to-one" fkcolumn="orderCreatedSiteID";
	property name="orderPlacedSite" hb_populateEnabled="public" cfc="Site" fieldtype="many-to-one" fkcolumn="orderPlacedSiteID";

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

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non persistent properties
	property name="addOrderItemSkuOptionsSmartList" persistent="false";
	property name="addOrderItemStockOptionsSmartList" persistent="false";
	property name="addPaymentRequirementDetails" persistent="false";
	property name="deliveredItemsAmountTotal" persistent="false";
	property name="depositItemSmartList" persistent="false";
	property name="discountTotal" persistent="false" hb_formatType="currency";
	property name="dynamicChargeOrderPayment" persistent="false";
	property name="dynamicCreditOrderPayment" persistent="false";
	property name="dynamicChargeOrderPaymentAmount" persistent="false" hb_formatType="currency";
	property name="dynamicCreditOrderPaymentAmount" persistent="false" hb_formatType="currency";
	property name="eligiblePaymentMethodDetails" persistent="false";
	property name="itemDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentRefundTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeAfterDiscountTotal" persistent="false" hb_formatType="currency";
	property name="nextEstimatedDeliveryDateTime" type="timestamp" persistent="false";
	property name="nextEstimatedFulfillmentDateTime" type="timestamp" persistent="false";
	property name="orderDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="orderPaymentAmountNeeded" persistent="false" hb_formatType="currency";
	property name="orderPaymentChargeAmountNeeded" persistent="false" hb_formatType="currency";
	property name="orderPaymentCreditAmountNeeded" persistent="false" hb_formatType="currency";
	property name="orderPaymentRefundOptions" persistent="false";
	property name="orderRequirementsList" persistent="false";
	property name="orderTypeOptions" persistent="false";
	property name="defaultStockLocationOptions" persistent="false";
	property name="paymentAmountTotal" persistent="false" hb_formatType="currency";
	property name="paymentAmountReceivedTotal" persistent="false" hb_formatType="currency";
	property name="paymentAmountCreditedTotal" persistent="false" hb_formatType="currency";
	property name="paymentAmountDue" persistent="false" hb_formatType="currency";
	property name="paymentAmountDueAfterGiftCards" persistent="false" hb_formatType="currency";
	property name="paymentMethodOptionsSmartList" persistent="false";
	property name="promotionCodeList" persistent="false";
	property name="quantityDelivered" persistent="false";
	property name="quantityUndelivered" persistent="false";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	property name="returnItemSmartList" persistent="false";
	property name="referencingPaymentAmountCreditedTotal" persistent="false" hb_formatType="currency";
	property name="rootOrderItems" persistent="false";
	property name="saleItemSmartList" persistent="false";
	property name="saveBillingAccountAddressFlag" hb_populateEnabled="public" persistent="false";
	property name="saveBillingAccountAddressName" hb_populateEnabled="public" persistent="false";
	property name="saveShippingAccountAddressFlag" hb_populateEnabled="public" persistent="false";
	property name="saveShippingAccountAddressName" hb_populateEnabled="public" persistent="false";
	property name="statusCode" persistent="false";
	property name="subTotal" persistent="false" hb_formatType="currency";
	property name="subTotalAfterItemDiscounts" persistent="false" hb_formatType="currency";
	property name="taxTotal" persistent="false" hb_formatType="currency";
	property name="total" persistent="false" hb_formatType="currency";
	property name="totalItems" persistent="false";
	property name="totalQuantity" persistent="false";
	property name="totalSaleQuantity" persistent="false";
	property name="totalReturnQuantity" persistent="false";
	
    //======= Mocking Injection for Unit Test ======	
	property name="orderService" persistent="false" type="any";
	property name='orderDAO' persistent="false" type="any";

	public void function init(){
		setOrderService(getService('orderService'));
		setOrderDao(getDAO('OrderDAO'));
		super.init();
	}
//	
//	public void function setOrderService(required any orderService){
//		variables.orderService = arguments.orderService;
//	}
	
//	public void function setOrderDAO(required any orderDAO) {
//		//TODO: check if necessary using setORderDAO()
//		variables.orderDAO = arguments.orderDAO
//	}


	//======= End of Mocking Injection ========

	public string function getStatus() {
		return getOrderStatusType().getTypeName();
	}

	public string function getStatusCode() {
		return getOrderStatusType().getSystemCode();
	}

	public string function getType(){
		return getOrderType().getTypeName();
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
	
	public boolean function hasCreditCardPaymentMethod(){
		if(!structKeyExists(variables,'hasCreditCardPaymentMethodValue')){
			variables.hasCreditCardPaymentMethodValue = false;
			for(var orderPayment in getOrderPayments()){
				if(orderPayment.getPaymentMethod().getPaymentMethodType() == 'creditCard'){
					variables.hasCreditCardPaymentMethodValue = true;
					break;	
				}
			}
		}
		return variables.hasCreditCardPaymentMethodValue;
	}


	public struct function getAddPaymentRequirementDetails() {
		if(!structKeyExists(variables, "addPaymentRequirementDetails")) {
			variables.addPaymentRequirementDetails = {};
			var requiredAmount = getService('HibachiUtilityService').precisionCalculate(getTotal() - getPaymentAmountTotal());

			if(requiredAmount > 0) {
				variables.addPaymentRequirementDetails.amount = requiredAmount;
				variables.addPaymentRequirementDetails.orderPaymentType = getService("typeService").getTypeBySystemCode("optCharge");
			} else if (requiredAmount < 0) {
				variables.addPaymentRequirementDetails.amount = requiredAmount * -1;
				variables.addPaymentRequirementDetails.orderPaymentType = getService("typeService").getTypeBySystemCode("optCredit");
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
				var maxOrderNumber = getOrderService().getMaxOrderNumber();
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

		}

		// If the order is closed, and has no close dateTime
		if(!isNull(getOrderStatusType()) && !isNull(getOrderStatusType().getSystemCode()) && getOrderStatusType().getSystemCode() == "ostClosed" && isNull(getOrderCloseDateTime())) {
			setOrderCloseDateTime( now() );
		}
	}

	public numeric function getPreviouslyReturnedFulfillmentTotal() {
		return getOrderService().getPreviouslyReturnedFulfillmentTotal(getOrderId());
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

	public numeric function getPaymentAmountDueAfterGiftCards(){
		var paymentAmountDue = this.getPaymentAmountDue();
		if(paymentAmountDue > 0 && this.hasGiftCardOrderPaymentAmount()){
			paymentAmountDue = paymentAmountDue - this.getGiftCardOrderPaymentAmountNotReceived();
		}
		return paymentAmountDue;
	}


	public boolean function hasGiftCardOrderPaymentAmount(){
		
		var amount = getOrderDAO().getGiftCardOrderPaymentAmount(this.getOrderID());

		if(amount gt 0){
			return true;
		}

		return false;

	}
	/**
	* @Suppress
	*/
	public numeric function getGiftCardOrderPaymentAmount(){
		return getDAO("OrderDAO").getGiftCardOrderPaymentAmount(this.getOrderID());
	}

	public numeric function getGiftCardOrderPaymentAmountReceived(){
        return getDAO("OrderDAO").getGiftCardOrderPaymentAmountReceived(this.getOrderID());
	}

	public numeric function getGiftCardOrderPaymentAmountNotReceived(){
	    return this.getGiftCardOrderPaymentAmount() - this.getGiftCardOrderPaymentAmountReceived(); 
	}


    //alias method for validation
    public boolean function canCancel(){
          return !hasGiftCardOrderItems();
    }

	public boolean function hasGiftCardOrderItems(orderItemID=""){

		var giftCardOrderItems = getOrderDAO().getGiftCardOrderItems(this.getOrderID());

		if(arguments.orderItemID EQ "" AND ArrayLen(giftCardOrderItems) GT 0){
			return true;
		} else if (arguments.orderItemID NEQ ""){

			for(var item in giftCardOrderItems){
				if(item.getOrderItemID() EQ arguments.orderItemID){
					return true;
				}
			}

		}

		return false;
	}
	
	/**
	* @Suppress
	*/
	public array function getGiftCardOrderItems() {
		return getDAO('OrderDAO').getGiftCardOrderItems(this.getOrderID());
	}
	
	/**
	* @Suppress
	*/
    public any function getAllOrderItemGiftRecipientsSmartList(){
        var orderItemGiftRecipientSmartList = getService("OrderService").getOrderItemGiftRecipientSmartList();
        orderItemGiftRecipientSmartList.joinRelatedProperty("SlatwallOrderItemGiftRecipient", "orderItem", "left", true);
        orderItemGiftRecipientSmartList.addWhereCondition("aslatwallorderitem.order.orderID='#this.getOrderID()#'");
        return orderItemGiftRecipientSmartList;
    }

	public void function checkNewBillingAccountAddressSave() {
		// If this isn't a guest, there isn't an accountAddress, save is on - copy over an account address
    	if(!isNull(getSaveBillingAccountAddressFlag()) 
    		&& getSaveBillingAccountAddressFlag() 
    		&& !isNull(getAccount()) 
    		&& !getAccount().getGuestAccountFlag() 
    		&& isNull(getBillingAccountAddress()) 
    		&& !isNull(getBillingAddress()) 
    		&& !getBillingAddress().hasErrors()
    	  ) {

    		// Create a New Account Address, Copy over Shipping Address, and save
    		var accountAddress = getService('accountService').newAccountAddress();
    		if(!isNull(getSaveBillingAccountAddressName())) {
				accountAddress.setAccountAddressName( getSaveBillingAccountAddressName() );
			}
			accountAddress.setAddress( getBillingAddress().copyAddress( true ) );
			accountAddress.setAccount( getAccount() );
			accountAddress = getService('accountService').saveAccountAddress( accountAddress );

			// Set the accountAddress
			setBillingAccountAddress( accountAddress );
		}
	}

	public void function checkNewShippingAccountAddressSave() {
		// If this isn't a guest, there isn't an accountAddress, save is on - copy over an account address
    	if( !isNull(getSaveShippingAccountAddressFlag()) 
    		&& getSaveShippingAccountAddressFlag() 
    		&& !isNull(getAccount()) 
    		&& !getAccount().getGuestAccountFlag() 
    		&& isNull(getShippingAccountAddress()) 
    		&& !isNull(getShippingAddress()) 
    		&& !getShippingAddress().hasErrors()
    	  ) {

    		// Create a New Account Address, Copy over Shipping Address, and save
    		var accountAddress = getService('accountService').newAccountAddress();
    		if(!isNull(getSaveShippingAccountAddressName())) {
    			accountAddress.setAccountAddressName( getSaveShippingAccountAddressName() );
    		}
			accountAddress.setAddress( getShippingAddress().copyAddress( true ) );
			accountAddress.setAccount( getAccount() );
			accountAddress = getService('accountService').saveAccountAddress( accountAddress );

			// Set the accountAddress
			setShippingAccountAddress( accountAddress );
		}

	}
	// ============ START: Non-Persistent Property Methods =================

	public any function getAddOrderItemSkuOptionsSmartList() {
		var optionsSmartList = getService("skuService").getSkuSmartList();
		optionsSmartList.addFilter('activeFlag', 1);
		optionsSmartList.addFilter('product.activeFlag', 1);
		optionsSmartList.joinRelatedProperty('SlatwallProduct', 'productType', 'inner');
		optionsSmartList.joinRelatedProperty('SlatwallProduct', 'brand', 'left');
		return optionsSmartList;
	}

	public any function getAddOrderItemStockOptionsSmartList() {
		var optionsSmartList = getService("stockService").getStockSmartList();
		optionsSmartList.addFilter('sku.activeFlag', 1);
		optionsSmartList.addFilter('sku.product.activeFlag', 1);
		optionsSmartList.joinRelatedProperty('SlatwallProduct', 'productType', 'inner');
		optionsSmartList.joinRelatedProperty('SlatwallProduct', 'brand', 'left');
		return optionsSmartList;
	}

	public numeric function getDeliveredItemsAmountTotal() {
		if(!structKeyExists(variables, "deliveredItemsAmountTotal")) {

			variables.deliveredItemsAmountTotal = 0;
			var fulfillmentChargeAddedList = "";

			for(var orderItem in getOrderItems()) {

				if(orderItem.getQuantityDelivered()) {

					variables.deliveredItemsAmountTotal = getService('HibachiUtilityService').precisionCalculate(variables.deliveredItemsAmountTotal + ((orderItem.getQuantityDelivered() / orderItem.getQuantity()) * orderItem.getItemTotal()));

					if(!listFindNoCase(fulfillmentChargeAddedList, orderItem.getOrderFulfillment().getOrderFulfillmentID())) {

						listAppend(fulfillmentChargeAddedList, orderItem.getOrderFulfillment().getOrderFulfillmentID());

						variables.deliveredItemsAmountTotal = getService('HibachiUtilityService').precisionCalculate(variables.deliveredItemsAmountTotal + orderItem.getOrderFulfillment().getChargeAfterDiscount());
					}
				}
			}
		}
		return variables.deliveredItemsAmountTotal;
	}

	public numeric function getDiscountTotal() {
		return getService('HibachiUtilityService').precisionCalculate(getItemDiscountAmountTotal() + getFulfillmentDiscountAmountTotal() + getOrderDiscountAmountTotal());

	}

	public array function getEligiblePaymentMethodDetails() {
		if(!structKeyExists(variables, "eligiblePaymentMethodDetails")) {
			variables.eligiblePaymentMethodDetails = getService("paymentService").getEligiblePaymentMethodDetailsForOrder( order=this );
		}
		return variables.eligiblePaymentMethodDetails;
	}

	public numeric function getItemDiscountAmountTotal() {
		var discountTotal = 0;
		var orderItems = getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit",orderItems[i].getTypeCode()) ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + orderItems[i].getDiscountAmount());
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal - orderItems[i].getDiscountAmount());
			} else {
				throw("there was an issue calculating the itemDiscountAmountTotal because of a orderItemType associated with one of the items");
			}
		}
		return discountTotal;
	}

	public numeric function getFulfillmentDiscountAmountTotal() {
		var discountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + getOrderFulfillments()[i].getDiscountAmount());
		}
		return discountTotal;
	}

	public numeric function getFulfillmentTotal() {
		return getService('HibachiUtilityService').precisionCalculate(getFulfillmentChargeTotal() - getFulfillmentRefundTotal());
	}

	public numeric function getFulfillmentChargeTotal() {
		var fulfillmentChargeTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			fulfillmentChargeTotal = getService('HibachiUtilityService').precisionCalculate(fulfillmentChargeTotal + getOrderFulfillments()[i].getFulfillmentCharge());
		}
		return fulfillmentChargeTotal;
	}

	public numeric function getFulfillmentRefundTotal() {
		var fulfillmentRefundTotal = 0;
		for(var i=1; i<=arrayLen(getOrderReturns()); i++) {
			fulfillmentRefundTotal = getService('HibachiUtilityService').precisionCalculate(fulfillmentRefundTotal + getOrderReturns()[i].getFulfillmentRefundAmount());
		}

		return fulfillmentRefundTotal;
	}

	public numeric function getFulfillmentChargeAfterDiscountTotal() {
		var fulfillmentChargeAfterDiscountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			fulfillmentChargeAfterDiscountTotal = getService('HibachiUtilityService').precisionCalculate(fulfillmentChargeAfterDiscountTotal + getOrderFulfillments()[i].getChargeAfterDiscount());
		}

		return fulfillmentChargeAfterDiscountTotal;
	}

	/**
	 * Returns the earliest estimatedFulfillmentyDateTime
	 *
	 * @method 	public any function getNextEstimatedFulfillmentDateTime
	 * @return {datetime} nextEsimatedFulfillmentDateTime
	 */

	public any function getNextEstimatedFulfillmentDateTime(){
    	var nextEstimatedFulfillmentDateTime = "";

    	if(arrayLen(getOrderItems())) {
    		//Loop over orderFulfillments to get the nextEstimatedFulfillmentDateTime
			for(var orderItem in getOrderItems()){
				//Condtional to check for the nextEstimatedFulfillmentDateTime, also checks to make sure that the nextFulfillmentyDateTime is not the current estimatedFullfillmentDateTime
				if( ( nextEstimatedFulfillmentDateTime == "" || nextEstimatedFulfillmentDateTime > orderItem.getEstimatedFulfillmentDateTime() ) && orderItem.getQuantityUndelivered() > 0  && !isNull( orderItem.getEstimatedFulfillmentDateTime() ) ){
					nextEstimatedFulfillmentDateTime = orderItem.getEstimatedFulfillmentDateTime();
				}
			}
		}

		if ( !isDefined('nextEstimatedFulfillmentDateTime') || nextEstimatedFulfillmentDateTime == ''){
			return javaCast('Null',"");
		}

		return nextEstimatedFulfillmentDateTime;
    }

    /**
	 * Returns the earliest estimatedDeliveryDateTime
	 *
	 * @method 	public any function getNextEstimatedDeleiverDateTime
	 * @return {datetime} nextEstimatedDeliveryDateTime
	 */
    public any function getNextEstimatedDeliveryDateTime(){
    	var nextEstimatedDeliveryDateTime = "";

    	if(arrayLen(getOrderItems())) {
	 		//Loop over orderFulfillments to get the nextEstimatedDeliveryDateTime
			for(var orderItem in getOrderItems()){
				//Condtional to check for the nextEstimatedDeliveryDateTime, also checks to make sure that the nextEstimatedDeliveryDateTime is not the current estimatedDeliveryDateTime
				if( ( nextEstimatedDeliveryDateTime == "" || nextEstimatedDeliveryDateTime > orderItem.getEstimatedDeliveryDateTime() ) && orderItem.getQuantityUndelivered() > 0 && !isNull( orderItem.getEstimatedDeliveryDateTime() ) ){
					nextEstimatedDeliveryDateTime = orderItem.getEstimatedDeliveryDateTime();
				}
			}
		}

		if ( !isdefined('nextEstimatedDeliveryDateTime') || nextEstimatedDeliveryDateTime == ''){
			return javaCast('Null',"");
		}

		return nextEstimatedDeliveryDateTime;
    }

	public numeric function getOrderDiscountAmountTotal() {
		var discountAmount = 0;

		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getDiscountAmount());
		}

		return discountAmount;
	}

	public any function getOrderRequirementsList() {
		return getService("orderService").getOrderRequirementsList(order=this);
	}

	public numeric function getOrderPaymentAmountNeeded() {

		var nonNullPayments = getOrderService().getOrderPaymentNonNullAmountTotal(orderID=getOrderID());
		var orderPaymentAmountNeeded = getService('HibachiUtilityService').precisionCalculate(getTotal() - nonNullPayments);
	
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
		var nonNullPayments = getOrderService().getOrderPaymentNonNullAmountTotal(orderID=getOrderID());
		var orderPaymentAmountNeeded = getService('HibachiUtilityService').precisionCalculate(getTotal() - nonNullPayments);

		if(orderPaymentAmountNeeded gt 0) {
			return orderPaymentAmountNeeded;
		}

		return 0;
	}

	public any function getDynamicCreditOrderPaymentAmount() {
		var nonNullPayments = getOrderService().getOrderPaymentNonNullAmountTotal(orderID=getOrderID());
		var orderPaymentAmountNeeded = getService('HibachiUtilityService').precisionCalculate(getTotal() - nonNullPayments);

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
					totalPayments = getService('HibachiUtilityService').precisionCalculate(totalPayments + orderPayment.getAmount());
				} else {
					totalPayments = getService('HibachiUtilityService').precisionCalculate(totalPayments - orderPayment.getAmount());
				}
			}
		}

		return totalPayments;
	}

	public numeric function getPaymentAmountDue(){
		if(getStatusCode() == 'ostCanceled'){
			return 0;
		}
		return getService('HibachiUtilityService').precisionCalculate(getService('HibachiUtilityService').precisionCalculate(getTotal() - getPaymentAmountReceivedTotal()) + getPaymentAmountCreditedTotal());
	}

	public numeric function getPaymentAmountAuthorizedTotal() {
		var totalPaymentsAuthorized = 0;

		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsAuthorized = getService('HibachiUtilityService').precisionCalculate(totalPaymentsAuthorized + orderPayment.getAmountAuthorized());
			}
		}

		return totalPaymentsAuthorized;
	}

	public numeric function getPaymentAmountReceivedTotal() {
		var totalPaymentsReceived = 0;

		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsReceived = getService('HibachiUtilityService').precisionCalculate(totalPaymentsReceived + orderPayment.getAmountReceived());
			}
		}

		return totalPaymentsReceived;
	}

	public numeric function getPaymentAmountTotalByPaymentMethod(required any paymentMethod, required any requestingOrderPayment) {
		var totalPayments = 0;

		for(var orderPayment in getOrderPayments()) {
			if(
				orderPayment.getPaymentMethod().getPaymentMethodId() eq arguments.paymentMethod.getPaymentMethodId()
				&&
				orderPayment.getStatusCode() eq "opstActive"
				&&
				!orderPayment.hasErrors()
				&&
				!orderPayment.getNewFlag()
				&&
				arguments.requestingOrderPayment.getOrderPaymentID() != orderPayment.getOrderPaymentID()
				){

					if(orderPayment.getOrderPaymentType().getSystemCode() eq 'optCharge') {
						totalPayments = getService('HibachiUtilityService').precisionCalculate(totalPayments + orderPayment.getAmount());
					} else {
						totalPayments = getService('HibachiUtilityService').precisionCalculate(totalPayments - orderPayment.getAmount());
					}
			}

		}

		return totalPayments;
	}


	public numeric function getTotalDiscountableAmount(){
		return getSubtotalAfterItemDiscounts() + getFulfillmentChargeAfterDiscountTotal();
	}

	public numeric function getPaymentAmountCreditedTotal() {
		var totalPaymentsCredited = 0;

		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsCredited = getService('HibachiUtilityService').precisionCalculate(totalPaymentsCredited + orderPayment.getAmountCredited());
			}
		}

		return totalPaymentsCredited;
	}

	public numeric function getReferencingPaymentAmountCreditedTotal() {
		var totalReferencingPaymentsCredited = 0;

		for(var orderPayment in getOrderPayments()) {
			for(var referencingOrderPayment in orderPayment.getReferencingOrderPayments()) {
				if(referencingOrderPayment.getStatusCode() eq "opstActive") {
					totalReferencingPaymentsCredited = getService('HibachiUtilityService').precisionCalculate(totalReferencingPaymentsCredited + referencingOrderPayment.getAmountCredited());
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
			sl.addSelect('typeName', 'name');
			sl.addSelect('typeID', 'value');

			variables.orderTypeOptions = sl.getRecords();
		}
		return variables.orderTypeOptions;
	}

	public array function getDefaultStockLocationOptions() {
		if(!structKeyExists(variables, "defaultStockLocationOptions")) {
			var defaultStockLocationOptions=getService("locationService").getLocationOptions();
			arrayPrepend(defaultStockLocationOptions, {"name"=rbKey('define.none'),"value"=""});
			variables.defaultStockLocationOptions=defaultStockLocationOptions;
		}
		return variables.defaultStockLocationOptions;
	}

	public string function getPromotionCodeList() {
		var promotionCodeList = "";

		for(var promotionCodeEntity in getPromotionCodes()) {
			promotionCodeList = listAppend(promotionCodeList, promotionCodeEntity.getPromotionCode());
		}

		return promotionCodeList;
	}

	public array function getAllAppliedPromotions() {
		if(!structKeyExists(variables, "allAppliedPromotions")) {
			variables.allAppliedPromotions = []; 
			var allAppliedPromotionCollection = getService("promotionService").newCollection().setup("PromotionApplied");
			allAppliedPromotionCollection.addFilter('order.orderID', getOrderID(), "=");
			allAppliedPromotionCollection.addFilter('orderItem.order.orderID', getOrderID(), "=", "OR");
			allAppliedPromotionCollection.addFilter('orderFulfillment.order.orderID', getOrderID(), "=", "OR");
			allAppliedPromotionCollection.setDisplayProperties("appliedType,promotionAppliedID,promotion.promotionID,promotion.promotionName");
			var allAppliedPromotions = allAppliedPromotionCollection.getRecords();
			// get all the promotion codes applied and attached it to applied Promotion Struct
			var appliedPromotionCodes = getPromotionCodes();
			for(var appliedPromotionCode in appliedPromotionCodes) {
				promotionToAdd = {}; 
				promotionToAdd["qualified"] = false; 
				for(var appliedPromotion in allAppliedPromotions) {
					if(appliedPromotionCode.getPromotion().getPromotionID() == appliedPromotion.promotion_promotionID) {
					    promotionToAdd = appliedPromotion; 
					    promotionToAdd["qualified"] = true; 
					    break; 
					}   
				}
				promotionToAdd["promotionCodeID"] = appliedPromotionCode.getPromotionCodeID();
				promotionToAdd["promotionCode"] = appliedPromotionCode.getPromotionCode();
		        if(!structKeyExists(promotionToAdd, "promotion_promotionName")){
                    promotionToAdd["promotion_promotionName"] = appliedPromotionCode.getPromotion().getPromotionName();  
		            promotionToAdd["promotion_promotionID"] = appliedPromotionCode.getPromotion().getPromotionID();
		        }
		        arrayAppend(variables.allAppliedPromotions, promotionToAdd); 	    
			}
		}
		return variables.allAppliedPromotions;
	}

	public numeric function getDeliveredItemsPaymentAmountUnreceived() {
		var received = getPaymentAmountReceivedTotal();
		var amountDelivered = 0;

		for(var f=1; f<=arrayLen(getOrderFulfillments()); f++) {
			// If this fulfillment is fully delivered, then just add the entire amount
			if(getOrderFulfillments()[f].getQuantityUndelivered() == 0) {
				amountDelivered = getService('HibachiUtilityService').precisionCalculate(amountDelivered + getOrderFulfillments()[f].getFulfillmentTotal());

			// If this fulfillment has at least one item delivered
			} else if(getOrderFulfillments()[f].getQuantityDelivered() > 0) {

				// Add the fulfillmentCharge
				amountDelivered = getService('HibachiUtilityService').precisionCalculate(amountDelivered + getOrderFulfillments()[f].getChargeAfterDiscount());

				// Loop over the fulfillmentItems and add each of the amounts to the total amount delivered
				for(var i=1; i<=arrayLen(getOrderFulfillments()[f].getOrderFulfillmentItems()); i++) {
					var item = getOrderFulfillments()[f].getOrderFulfillmentItems()[i];

					if(item.getQuantityUndelivered() == 0) {
						amountDelivered = getService('HibachiUtilityService').precisionCalculate(amountDelivered + item.getItemTotal());
					} else if (item.getQuantityDelivered() > 0) {
						var itemQDValue = (round(item.getItemTotal() * (item.getQuantityDelivered() / item.getQuantity()) * 100) / 100);
						amountDelivered = getService('HibachiUtilityService').precisionCalculate(amountDelivered + itemQDValue);
					}

				}
			}
		}

		return getService('HibachiUtilityService').precisionCalculate(amountDelivered - getPaymentAmountReceivedTotal());
	}

	public any function getRootOrderItems(){
		var rootOrderItems = [];
		for(var orderItem in this.getOrderItems()){
			if(isNull(orderItem.getParentOrderItem())){
				ArrayAppend(rootOrderItems, orderItem);
			}
		}
		return rootOrderItems;
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
			if( listFindNoCase("oitSale,oitDeposit",getOrderItems()[i].getOrderItemType().getSystemCode()) ) {
				saleQuantity += getOrderItems()[i].getQuantity();
			}
		}
		return saleQuantity;
	}

	public numeric function getTotalReturnQuantity() {
		var returnQuantity = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if(getOrderItems()[i].getOrderItemType().getSystemCode() eq "oitReturn") {
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

	public any function getDepositItemSmartList() {
		if(!structKeyExists(variables, "depositItemSmartList")) {
			variables.depositItemSmartList = getService("orderService").getOrderItemSmartList();
			variables.depositItemSmartList.addFilter('order.orderID', getOrderID());
			variables.depositItemSmartList.addInFilter('orderItemType.systemCode', 'oitDeposit');
		}
		return variables.depositItemSmartList;
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
		var orderItems = this.getRootOrderItems();
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit",orderItems[i].getTypeCode()) ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal + orderItems[i].getExtendedPrice());
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal - orderItems[i].getExtendedPrice());
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return subtotal;
	}

	public numeric function getSubtotalAfterItemDiscounts() {
		return getService('HibachiUtilityService').precisionCalculate(getSubtotal() - getItemDiscountAmountTotal());
	}

	public numeric function getTaxTotal() {
		var taxTotal = 0;
		var orderItems = this.getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit",orderItems[i].getTypeCode()) ) {
				taxTotal = getService('HibachiUtilityService').precisionCalculate(taxTotal + orderItems[i].getTaxAmount());
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				taxTotal = getService('HibachiUtilityService').precisionCalculate(taxTotal - orderItems[i].getTaxAmount());
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return taxTotal;
	}

	public numeric function getTotal() {
		return getService('HibachiUtilityService').precisionCalculate(getSubtotal() + getTaxTotal() + getFulfillmentTotal() - getDiscountTotal());
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

	// Referenced Order (many-to-one)
	public void function setReferencedOrder(required any referencedOrder) {
		variables.referencedOrder = arguments.referencedOrder;
		if(isNew() or !arguments.referencedOrder.hasReferencingOrder( this )) {
			arrayAppend(arguments.referencedOrder.getReferencingOrders(), this);
		}
	}
	public void function removeReferencedOrder(any referencedOrder) {
		if(!structKeyExists(arguments, "referencedOrder")) {
			arguments.referencedOrder = variables.referencedOrder;
		}
		var index = arrayFind(arguments.referencedOrder.getReferencingOrders(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.referencedOrder.getReferencingOrders(), index);
		}
		structDelete(variables, "referencedOrder");
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
		//clear the cache on whether we have a credit card PaymentMethod
		if(
			structKeyExists(variables,'hasCreditCardPaymentMethodValue')
			&& !variables.hasCreditCardPaymentMethodValue
			&& !isNull(arguments.orderPayment.getPaymentMethod()) 
			&& arguments.orderPayment.getPaymentMethod().getPaymentMethodType() == 'creditCard'
		){
			structDelete(variables,'hasCreditCardPaymentMethodValue');
		}
	}
	public void function removeOrderPayment(required any orderPayment) {
		arguments.orderPayment.removeOrder( this );
		//clear the cache on credit card PaymentMethod
		if(structKeyExists(variables,'hasCreditCardPaymentMethodValue')){
			structDelete(variables,'hasCreditCardPaymentMethodValue');	
		}
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

	// Referencing Order Items (one-to-many)
	public void function addReferencingOrderItem(required any referencingOrderItem) {
		arguments.referencingOrderItem.setReferencedOrder( this );
	}
	public void function removeReferencingOrderItem(required any referencingOrderItem) {
		arguments.referencingOrderItem.removeReferencedOrder( this );
	}

	// Applied Promotions (one-to-many)
	public void function addAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.setOrder( this );
	}
	public void function removeAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.removeOrder( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================

	public any function getBillingAddress() {
		if(structKeyExists(variables, "billingAddress")) {
			return variables.billingAddress;
		} else if (!isNull(getBillingAccountAddress())) {
			setBillingAddress( getBillingAccountAddress().getAddress().copyAddress( true ) );
			return variables.billingAddress;
		}
		return getService("addressService").newAddress();
	}

	public any function getShippingAddress() {
		if(structKeyExists(variables, "shippingAddress")) {
			return variables.shippingAddress;
		} else if (!isNull(getShippingAccountAddress())) {
			setShippingAddress( getShippingAccountAddress().getAddress().copyAddress( true ) );
			return variables.shippingAddress;
		}
		return getService("addressService").newAddress();
	}

	public any function getOrderStatusType() {
		if(!structKeyExists(variables, "orderStatusType")) {
			variables.orderStatusType = getService("typeService").getTypeBySystemCode('ostNotPlaced');
		}
		return variables.orderStatusType;
	}

	public any function getOrderType() {
		if(!structKeyExists(variables, "orderType")) {
			variables.orderType = getService("typeService").getTypeBySystemCode('otSalesOrder');
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

	public any function setShippingAccountAddress( any accountAddress ) {
		if(isNull(arguments.accountAddress)) {
			structDelete(variables, "shippingAccountAddress");
		} else {
			// If the shippingAddress is a new shippingAddress
			if( isNull(getShippingAddress()) ) {
				setShippingAddress( arguments.accountAddress.getAddress().copyAddress( true ) );

			// Else if there was no accountAddress before, or the accountAddress has changed
			} else if (!structKeyExists(variables, "shippingAccountAddress") || (structKeyExists(variables, "shippingAccountAddress") && variables.shippingAccountAddress.getAccountAddressID() != arguments.accountAddress.getAccountAddressID()) ) {
				getShippingAddress().populateFromAddressValueCopy( arguments.accountAddress.getAddress() );

			}

			// Set the actual accountAddress
			variables.shippingAccountAddress = arguments.accountAddress;
		}
	}

	public any function setBillingAccountAddress( any accountAddress ) {
		if(isNull(arguments.accountAddress)) {
			structDelete(variables, "billingAccountAddress");
		} else {
			// If the shippingAddress is a new shippingAddress
			if( isNull(getBillingAddress()) ) {
				setBillingAddress( arguments.accountAddress.getAddress().copyAddress( true ) );

			// Else if there was no accountAddress before, or the accountAddress has changed
			} else if (!structKeyExists(variables, "billingAccountAddress") || (structKeyExists(variables, "billingAccountAddress") && variables.billingAccountAddress.getAccountAddressID() != arguments.accountAddress.getAccountAddressID()) ) {
				getBillingAddress().populateFromAddressValueCopy( arguments.accountAddress.getAddress() );

			}

			// Set the actual accountAddress
			variables.billingAccountAddress = arguments.accountAddress;
		}
	}

	public any function populate( required struct data={} ) {
		// Before we populate we need to cleanse the shippingAddress data if the shippingAccountAddress is being changed in any way
		if(structKeyExists(arguments.data, "shippingAccountAddress")
			&& structKeyExists(arguments.data.shippingAccountAddress, "accountAddressID")
			&& len(arguments.data.shippingAccountAddress.accountAddressID)
			&& ( !structKeyExists(arguments.data, "shippingAddress") || !structKeyExists(arguments.data.shippingAddress, "addressID") || !len(arguments.data.shippingAddress.addressID) ) ) {

			structDelete(arguments.data, "shippingAddress");
		}

		// Before we populate we need to cleanse the billingAddress data if the shippingAccountAddress is being changed in any way
		if(structKeyExists(arguments.data, "billingAccountAddress")
			&& structKeyExists(arguments.data.billingAccountAddress, "accountAddressID")
			&& len(arguments.data.billingAccountAddress.accountAddressID)
			&& ( !structKeyExists(arguments.data, "billingAddress") || !structKeyExists(arguments.data.billingAddress, "addressID") || !len(arguments.data.billingAddress.addressID) ) ) {

			structDelete(arguments.data, "billingAddress");
		}


		super.populate(argumentCollection=arguments);
	}

	// ==================  END:  Overridden Methods ========================

	public boolean function hasSubscriptionWithAutoPay(){
		var hasSubscriptionWithAutoPay = false;
		for (var orderItem in getOrderItems()){
			if (orderItem.getSku().getBaseProductType() == "subscription"
				&& !isNull(orderItem.getSku().getSubscriptionTerm().getAutoPayFlag())
				&& orderItem.getSku().getSubscriptionTerm().getAutoPayFlag()
			){
				hasSubscriptionWithAutoPay = true;
				break;
			}
		}
		return hasSubscriptionWithAutoPay;
	}

	public boolean function hasSavableOrderPaymentAndSubscriptionWithAutoPay(){
		return this.hasSubscriptionWithAutoPay() && this.hasOrderPaymentWithSavablePaymentMethod();
	}


	public boolean function hasOrderPaymentWithSavablePaymentMethod(){
		var hasOrderPaymentWithSavablePaymentMethod = false;

		for (orderPayment in getOrderPayments()){
			if (!isNull(orderPayment.getAccountPaymentMethod())
				|| (
					orderPayment.getStatusCode() == 'opstActive'
					&& !isNull(orderPayment.getPaymentMethod())
					&& !isNull(orderPayment.getPaymentMethod().getAllowSaveFlag())
					&& orderPayment.getPaymentMethod().getAllowSaveFlag()
				)
			){
				hasOrderPaymentWithSavablePaymentMethod = true;
				break;
			}
		}

		return hasOrderPaymentWithSavablePaymentMethod;
	}

	public boolean function hasSavedAccountPaymentMethod(){
		var savedAccountPaymentMethod = false;
		for (orderPayment in getOrderPayments()){
			if (!isNull(orderPayment.getAccountPaymentMethod())){
				savedAccountPaymentMethod = true;
				break;
			}
		}
		return savedAccountPaymentMethod;
	}

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
