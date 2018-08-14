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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderDelivery";

	// Data Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="integrationID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderDeliveryItems" type="array" hb_populateArray="true";
	property name="giftCardCodes" type="array" hb_populateArray="true";
	property name="containers" type="array" hb_populateArray="true";
	
	property name="useShippingIntegrationForTrackingNumber" hb_formFieldType="yesno";
	property name="trackingNumber";
	property name="containerLabel";
	property name="captureAuthorizedPaymentsFlag" hb_formFieldType="yesno";
	property name="capturableAmount" hb_formatType="currency";

	variables.orderDeliveryItems = [];

	public array function getUndeliveredOrderItemsWithoutProvidedGiftCardCodePlaceholders() {
		var placeholders = [];
		for (var orderDeliveryItem in getOrderDeliveryItems()) {
			for (var orderItem in getUndeliveredOrderItemsWithoutProvidedGiftCardCode()) {
				if (orderItem.getOrderItemID() == orderDeliveryItem.orderItem.orderItemID && orderDeliveryItem.quantity > 0) {
					arrayAppend(placeholders, {
						orderItem = orderItem,
						quantity = min(orderDeliveryItem.quantity, orderItem.getQuantityUndelivered())
					});
				}
			}
		}

		return placeholders;
	}
	
	public boolean function isValidDeliveryQuantity(){
		for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
			if(IsNumeric(getOrderDeliveryItems()[i].quantity) && getOrderDeliveryItems()[i].quantity > 0) {
				var orderItem = getService('orderService').getOrderItem(getOrderDeliveryItems()[i].orderItem.orderItemID);
				var thisQuantity = getOrderDeliveryItems()[i].quantity;
				if( thisQuantity > orderItem.getQuantityUndelivered() ){
					return false;
				}
			}
		}
		return true;
	}
	
	public boolean function isValidQuantity(){
		for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
			if(IsNumeric(getOrderDeliveryItems()[i].quantity) && getOrderDeliveryItems()[i].quantity > 0 && !isNull(getLocation()) ) {
				var orderItem = getService('orderService').getOrderItem(getOrderDeliveryItems()[i].orderItem.orderItemID);
				var thisQuantity = getOrderDeliveryItems()[i].quantity;
				var stock = getService('StockService').getStockBySkuAndLocation(
					sku=orderItem.getSku(),
					location=getLocation()
				);
				if( 
					orderItem.getSku().setting('skuTrackInventoryFlag') 
					&& thisQuantity > stock.getQOH() 
				) {
					return false;
				}
			}
		}
		return true;
	}
	
	public any function getShippingIntegration(){
		if(!isNull(getOrderFulfillment().getShippingIntegration())){
			variables.shippingIntegration = getOrderFulfillment().getShippingIntegration();
		} 
		if(structKeyExists(variables,'shippingIntegration')){
			return variables.shippingIntegration;
		}
		
	}
	
	public boolean function getUseShippingIntegrationForTrackingNumber(){
		return (
			!isNull(getorderfulfillment().getShippingIntegration())
			&& getHibachiScope().setting('globalUseShippingIntegrationForTrackingNumberOption')
		);
	}

	public boolean function hasQuantityOnOneOrderDeliveryItem() {
		if (getOrderFulfillment().isAutoFulfillment() ){
			return true;
		}else{
			for(var orderDeliveryItem in getOrderDeliveryItems()) {
				if(structKeyExists(orderDeliveryItem, "quantity") && !isNull(orderDeliveryItem.quantity) && isNumeric(orderDeliveryItem.quantity) && orderDeliveryItem.quantity > 0) {
					return true;
				}
			}
		}
		return false;
	}

	// @hint Returns a struct to assist with quick lookup for orderDeliveryItem data by using orderItemID
	private struct function getOrderDeliveryItemsStruct() {
		// Assists with quick lookup for orderDeliveryItem data by using orderItemID
		var orderDeliveryItemsStruct = {};
		for (var orderDeliveryItemData in getOrderDeliveryItems()) {
			if (!structKeyExists(orderDeliveryItemsStruct, orderDeliveryItemData.orderItem.orderItemID)) {
				orderDeliveryItemsStruct[orderDeliveryItemData.orderItem.orderItemID] = orderDeliveryItemData;
			} else {
				orderDeliveryItemsStruct[orderDeliveryItemData.orderItem.orderItemID].quantity += orderDeliveryItemData.quantity;
			}
		}
		
		return orderDeliveryItemsStruct;
	}

	public boolean function hasUndeliveredOrderItemsWithoutProvidedGiftCardCode() {
		return arrayLen(getUndeliveredOrderItemsWithoutProvidedGiftCardCode()) > 0;
	}

	// @hint Returns an array of orderItems that require gift card codes
	public array function getUndeliveredOrderItemsWithoutProvidedGiftCardCode() {
		var undeliveredOrderItemsWithoutProvidedGiftCardCode = [];

		// Assists with quick lookup for orderDeliveryItem data by using orderItemID
		var orderDeliveryItemsStruct = getOrderDeliveryItemsStruct();

		// Inspect only orderItems of the orderFulfillment that are associated with an orderDeliveryItem
		for (var orderItem in getOrderFulfillment().getOrderFulfillmentItems()) {

			// Only for gift card orderItems part of the order delivery that require gift card codes manually provided
			if (structKeyExists(orderDeliveryItemsStruct, orderItem.getOrderItemID()) && (orderItem.getQuantityUndelivered() > 0) && orderItem.isGiftCardOrderItem() && !orderItem.getSku().getGiftCardAutoGenerateCodeFlag() && orderItem.getSku().getGiftCardRecipientRequiredFlag()) {
				var quantityAllocatedWithGiftCardCodes = 0;

				// Check if any gift card codes have already been allocated to orderItemGiftRecipients (ie. during orderService.order_addOrderItem)
				if (!isNull(orderItem.getOrderItemGiftRecipients())) {
					for (var orderItemGiftRecipient in orderItem.getOrderItemGiftRecipients()) {
						if (!isNull(orderItemGiftRecipient.getManualGiftCardCode()) && len(orderItemGiftRecipient.getManualGiftCardCode()) ) {
							quantityAllocatedWithGiftCardCodes += orderItemGiftRecipient.getNumberOfUnassignedGiftCards();
						}
					}
				}
				
				var quantityRemainsWithoutGiftCardCodes = orderItem.getQuantity() - quantityAllocatedWithGiftCardCodes;
				if (quantityRemainsWithoutGiftCardCodes > 0) {
					arrayAppend(undeliveredOrderItemsWithoutProvidedGiftCardCode, orderItem);
				}
			}
		}
		
		return undeliveredOrderItemsWithoutProvidedGiftCardCode;
	}

	// @hint Checks that all orderDeliveryItems for orderItems with manual gift card codes have correct number of gift card codes provided
	public boolean function hasGiftCardCodesForAllGiftCardDeliveryItems(){

		if (!isNull(getGiftCardCodes())) {

			// Creates struct to reference gift card codes for orderItem
			var giftCardCodeCountByOrderItemStruct = {};
			for (var giftCardCodeData in getGiftCardCodes()) {
				// Initialize gift card code count for orderItem
				if (!structKeyExists(giftCardCodeCountByOrderItemStruct, giftCardCodeData.orderItemID)) {
					giftCardCodeCountByOrderItemStruct[giftCardCodeData.orderItemID].count = 0;
				}

				// Increment gift card code count for orderItem
				giftCardCodeCountByOrderItemStruct[giftCardCodeData.orderItemID].count++;
			}

			// Assists with quick lookup for orderDeliveryItem data by using orderItemID
			var orderDeliveryItemsStruct = getOrderDeliveryItemsStruct();

			// Inspect only orderItems of the orderFulfillment that are associated with an orderDeliveryItem
			for (var orderItem in getOrderFulfillment().getOrderFulfillmentItems()) {
				if (structKeyExists(orderDeliveryItemsStruct, orderItem.getOrderItemID()) && orderItem.isGiftCardOrderItem() && !orderItem.getSku().getGiftCardAutoGenerateCodeFlag() && orderItem.getSku().getGiftCardRecipientRequiredFlag()) {
					// Invalid when we do not have enough gift card codes for the orderItem to deliver quantity specified
					if (giftCardCodeCountByOrderItemStruct[orderItem.getOrderItemID()].count < orderDeliveryItemsStruct[orderItem.getOrderItemID()].quantity) {
						return false;
					}
				}
			}
		}

		return true;
	}

	// @hint Checks that all orderDeliveryItems for orderItem with recipient required are allocated with correct number of recipients
	public boolean function hasRecipientsForAllGiftCardDeliveryItems(){
		// Assists with quick lookup for orderDeliveryItem data by using orderItemID
		var orderDeliveryItemsStruct = getOrderDeliveryItemsStruct();
		
		// Inspect only orderItems of the orderFulfillment that are associated with an orderDeliveryItem
		for (var orderItem in getOrderFulfillment().getOrderFulfillmentItems()) {
			// Apply only for gift card order items with recipient requirement
			if (structKeyExists(orderDeliveryItemsStruct, orderItem.getOrderItemID()) && orderItem.isGiftCardOrderItem() && orderItem.getSku().getGiftCardRecipientRequiredFlag()) {
				var quantityRequired = orderDeliveryItemsStruct[orderItem.getOrderItemID()].quantity;
				var quantityAllocated = 0;

				// Increment quantity with the quantity allocated to each recipient
				if (!isNull(orderItem.getOrderItemGiftRecipients())) {
					for (var orderItemGiftRecipient in orderItem.getOrderItemGiftRecipients()) {
						quantityAllocated += orderItemGiftRecipient.getNumberOfUnassignedGiftCards();
					}
				}

				// Not enough recipients allocated to fulfill
				if (quantityAllocated < quantityRequired) {
					return false;
				}
			}
		}

		return true;
	}

	public numeric function getCapturableAmount() {
		//Only use this logic if we are capturing authorized payments.
		if (getCaptureAuthorizedPaymentsFlag()){
			if(!structKeyExists(variables, "capturableAmount")) {
	
				variables.capturableAmount = 0;
	
				for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
					if(IsNumeric(getOrderDeliveryItems()[i].quantity) && getOrderDeliveryItems()[i].quantity > 0) {
						var orderItem = getService('orderService').getOrderItem(getOrderDeliveryItems()[i].orderItem.orderItemID);
						var thisQuantity = getOrderDeliveryItems()[i].quantity;
						if(thisQuantity > orderItem.getQuantityUndelivered()) {
							thisQuantity = orderItem.getQuantityUndelivered();
						}
						variables.capturableAmount = getService('HibachiUtilityService').precisionCalculate(variables.capturableAmount + ((orderItem.getItemTotal()/orderItem.getQuantity()) * thisQuantity ));
					}
				}
	
				if(getOrder().getPaymentAmountReceivedTotal() eq 0) {
					variables.capturableAmount = getService('HibachiUtilityService').precisionCalculate(variables.capturableAmount + getOrderFulfillment().getChargeAfterDiscount());
				} else {
					variables.capturableAmount = getService('HibachiUtilityService').precisionCalculate(variables.capturableAmount - (getOrder().getPaymentAmountReceivedTotal() - getOrder().getDeliveredItemsAmountTotal()));
				}
	
				if(variables.capturableAmount < 0) {
					variables.capturableAmount = 0;
				} else if (variables.capturableAmount > getOrder().getPaymentAmountDue()) {
					variables.capturableAmount = getOrder().getPaymentAmountDue();
				}
	
			}
			return variables.capturableAmount;
			}
		return 0;
	}

	public boolean function getCaptureAuthorizedPaymentsFlag() {
		if(!structKeyExists(variables, "captureAuthorizedPaymentsFlag")) {
			variables.captureAuthorizedPaymentsFlag = 0;
			if(getCapturableAmount() && getOrder().hasCreditCardPaymentMethod()) {
				variables.captureAuthorizedPaymentsFlag = 1;
			}
		}
		return variables.captureAuthorizedPaymentsFlag;
	}

}
