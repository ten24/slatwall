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
component entityname="SlatwallOrderItem" table="SwOrderItem" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderItems" hb_processContext="updateStatus" {

	// Persistent Properties
	property name="orderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="price" ormtype="big_decimal" hb_formatType="currency";
	property name="skuPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="currencyCode" ormtype="string" length="3";
	property name="quantity" hb_populateEnabled="public" ormtype="integer";
	property name="bundleItemQuantity" hb_populateEnabled="public" ormtype="integer";
	property name="allocatedOrderDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
	property name="estimatedDeliveryDateTime" ormtype="timestamp";
	property name="estimatedFulfillmentDateTime" ormtype="timestamp";
	property name="stockLoss" ormtype="boolean"; //Stock Loss flag for order return items;
	property name="stockLossReason" ormtype="string"; //Stock Loss reason for Order Return Items;
	property name="userDefinedPriceFlag" ormtype="boolean" default="0" hint="To flag if the price can be set by user/admin, in that case the price won't get updated to the best available price";
	
	// Calculated Properties
	property name="calculatedExtendedPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedExtendedUnitPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedExtendedPriceAfterDiscount" column="calcExtendedPriceAfterDiscount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedExtendedUnitPriceAfterDiscount" column="calcExtdUnitPriceAfterDiscount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedExtendedPriceAfterDiscountMinusReturns" column="calcExtdPriceAfterDiscMinusReturns" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTaxAmount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTaxAmountNotRefunded" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedItemTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedQuantityDeliveredMinusReturns" column="calcQtyDeliveredMinusReturns" ormtype="integer";
	
	
	// Related Object Properties (many-to-one)
	property name="appliedPriceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="appliedPriceGroupID";
	property name="orderItemType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderItemTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderItemType" fetch="join";
	property name="orderItemStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderItemStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderItemStatusType" fetch="join";
	property name="sku" hb_populateEnabled="public" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID" hb_cascadeCalculate="true" fetch="join";
	property name="stock" hb_populateEnabled="public" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	property name="order" hb_populateEnabled="false" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID" hb_cascadeCalculate="true" fetch="join";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="orderReturn" cfc="OrderReturn" fieldtype="many-to-one" fkcolumn="orderReturnID";
	property name="parentOrderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="parentOrderItemID";
	property name="productBundleGroup" hb_populateEnabled="public" cfc="ProductBundleGroup" fieldtype="many-to-one" fkcolumn="productBundleGroupID";
	property name="referencedOrderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="referencedOrderItemID" hb_cascadeCalculate="true"; // Used For Returns. This is set when this order is a return.

	// Related Object Properties (one-to-many)
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all-delete-orphan";
	property name="appliedTaxes" singularname="appliedTax" cfc="TaxApplied" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all-delete-orphan";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="all-delete-orphan";
	property name="childOrderItems" hb_populateEnabled="public" singularname="childOrderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="parentOrderItemID" inverse="true" cascade="all-delete-orphan";
	property name="eventRegistrations" singularname="eventRegistration" hb_populateEnabled="public" fieldtype="one-to-many" fkcolumn="orderItemID" cfc="EventRegistration" inverse="true" cascade="all-delete-orphan" ;
	property name="orderDeliveryItems" singularname="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true" cascade="delete-orphan";
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="one-to-many" fkcolumn="orderItemID" inverse="true";
	property name="referencingOrderItems" singularname="referencingOrderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="referencedOrderItemID" inverse="true" cascade="all"; // Used For Returns
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" cfc="AccountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="orderItemID" cascade="all" inverse="true";
	property name="giftCards" singularname="giftCard" cfc="GiftCard" type="array" fieldtype="one-to-many" fkcolumn="originalOrderItemID" cascade="all" inverse="true";
	property name="orderItemGiftRecipients" singularname="orderItemGiftRecipient" cfc="OrderItemGiftRecipient" type="array" fieldtype="one-to-many" fkcolumn="orderItemID" cascade="all" inverse="true";
	property name="fulfillmentBatchItems" singularname="fulfillmentBatchItem" fieldType="one-to-many" type="array" fkColumn="orderItemID" cfc="FulfillmentBatchItem" inverse="true";
	property name="stockHolds" singularname="stockHold" fieldType="one-to-many" type="array" fkColumn="orderItemID" cfc="StockHold" inverse="true";
    property name="orderItemSkuBundles" singularname="orderItemSkuBundle" fieldType="one-to-many" type="array" fkColumn="orderItemID" cfc="OrderItemSkuBundle" inverse="true" cascade="all-delete-orphan";
    
	// Related Object Properties (many-to-many)

	property name="shippingMethodOptionSplitShipments" singularname="shippingMethodOptionSplitShipment" cfc="ShippingMethodOptionSplitShipment" fieldtype="many-to-many" linktable="SwShipMethodOptSplitShipOrdItm" inversejoincolumn="shipMethodOptSplitShipmentID" fkcolumn="orderItemID";


	// Remote properties
	property name="publicRemoteID" ormtype="string" hb_populateEnabled="public";
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="sellOnBackOrderFlag" default="0" ormtype="boolean";

	// Non persistent properties
	property name="activeEventRegistrations" persistent="false";
	property name="discountAmount" persistent="false" hb_formatType="currency" hint="This is the discount amount after quantity (talk to Greg if you don't understand)" ;
	property name="extendedPrice" persistent="false" hb_formatType="currency";
	property name="extendedUnitPrice" persistent="false" hb_formatType="currency";
	property name="extendedPriceAfterDiscount" persistent="false" hb_formatType="currency";
	property name="extendedUnitPriceAfterDiscount" persistent="false" hb_formatType="currency";
	property name="extendedPriceAfterDiscountMinusReturns" persistent="false" hb_formatType="currency";
	property name="orderStatusCode" persistent="false";
	property name="quantityDelivered" persistent="false";
	property name="quantityDeliveredMinusReturns" persistent="false";
	property name="quantityUndelivered" persistent="false";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	property name="registrants" persistent="false";
	property name="renewalSku" persistent="false";
	property name="skuPerformCascadeCalculateFlag" persistent="false";
	property name="stockPerformCascadeCalculateFlag" persistent="false";
	property name="taxAmount" persistent="false" hb_formatType="currency";
	property name="taxAmountNotRefunded" persistent="false" hb_formatType="currency";
	property name="VATAmount" persistent="false" hb_formatType="currency";
	property name="VATPrice" persistent="false" hb_formatType="currency";
	property name="taxLiabilityAmount" persistent="false" hb_formatType="currency";
	property name="itemTotal" persistent="false" hb_formatType="currency";
	property name="itemTotalAfterOrderDiscounts" persistent="false" hb_formatType="currency";
	property name="productBundlePrice" persistent="false" hb_formatType="currency";
	property name="productBundleGroupPrice" persistent="false" hb_formatType="currency";
	property name="salePrice" type="struct" persistent="false";
	property name="totalWeight" persistent="false";
	property name="quantityHasChanged" persistent="false" default="0";
 	//CUSTOM PROPERTIES BEGIN
property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="retailCommission" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    property name="listPrice" ormtype="big_decimal" hb_formatType="currency";
        
    property name="manualPersonalVolume" ormtype="big_decimal";
    property name="manualTaxableAmount" ormtype="big_decimal";
    property name="manualCommissionableVolume" ormtype="big_decimal";
    property name="manualRetailCommission" ormtype="big_decimal";
    property name="manualProductPackVolume" ormtype="big_decimal";
    property name="manualRetailValueVolume" ormtype="big_decimal";
    
    property name="allocatedOrderPersonalVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderTaxableAmountDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderCommissionableVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderRetailCommissionDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderProductPackVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderRetailValueVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    
    property name="extendedPersonalVolume" persistent="false";
    property name="extendedTaxableAmount" persistent="false";
    property name="extendedCommissionableVolume" persistent="false";
    property name="extendedRetailCommission" persistent="false";
    property name="extendedProductPackVolume" persistent="false";
    property name="extendedRetailValueVolume" persistent="false";
    property name="extendedPersonalVolumeAfterDiscount" persistent="false";
    property name="extendedTaxableAmountAfterDiscount" persistent="false";
    property name="extendedCommissionableVolumeAfterDiscount" persistent="false";
    property name="extendedRetailCommissionAfterDiscount" persistent="false";
    property name="extendedProductPackVolumeAfterDiscount" persistent="false";
    property name="extendedRetailValueVolumeAfterDiscount" persistent="false";
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="mainCreditCardOnOrder" persistent="false";
	property name="mainCreditCardExpirationDate" persistent="false";
	property name="mainPromotionOnOrder" persistent="false";
	property name="netAmount" persistent="false" hb_formatType="currency";

    property name="calculatedExtendedPersonalVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedTaxableAmount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedCommissionableVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailCommission" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedProductPackVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailValueVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedPersonalVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedTaxableAmountAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedCommissionableVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailCommissionAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedProductPackVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailValueVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedListPrice" ormtype="big_decimal" hb_formatType="currency";
    property name="calculatedQuantityDelivered" ormtype="integer";
	property name="returnsReceived" ormtype="string";
    property name="kitFlagCode" ormtype="string";
    property name="itemCategoryCode" ormtype="string";
    
   //CUSTOM PROPERTIES END
	public boolean function getQuantityHasChanged(){
		return variables.quantityHasChanged;
	}
	
	public any function getSubscriptionOrderItem(){
		if(structKeyExists(variables,'subscriptionOrderItem')){
			return variables.subscriptionOrderItem;
		}else if(!getNewFlag()){
			var _subscriptionOrderItem = getService('subscriptionService').getSubscriptionOrderItemByOrderItem(this);
			if(!isNull(_subscriptionOrderItem)){
				variables.subscriptionOrderItem = _subscriptionOrderItem;
			}
		}
		//if still not set then we return null		
		if(structKeyExists(variables,'subscriptionOrderItem')){
			return variables.subscriptionOrderItem;
		}
	}

	// @hint Returns options that can act as placeholders for gift card codes that remain to be assigned to fulfill order item quantity
	public array function getProvidedGiftCardCodePlaceholderOptions( maxPlaceholders = getQuantityUndelivered() ) {
		
		// Only needed for gift card order items that will have gift card code manually provided and assigned
		var options = [];
		if (isGiftCardOrderItemAndManuallyProvideGiftCardCodes() && getQuantityUndelivered() > 0) {
			// gift card code is one-to-one with order item quantity (eg. order item quantity is 5, then 5 gift card codes are required)
			for (var q = 1; q <= arguments.maxPlaceholders; q++ ) {
				var placeholder = {
					name = "#getSku().getFormattedRedemptionAmount()# - #getSimpleRepresentation()#",
					value = '',
					skuID = getSku().getSkuID(),
					orderItemID = getOrderItemID(),
					sku = getSku()
				};

				arrayAppend(options, placeholder);
			}
		}
		
		return options;
	}
 	
	public numeric function getNumberOfUnassignedGiftCards(){

		if(!this.isGiftCardOrderItem()){
			return 0;
		}

		var count = this.getQuantity();

		// Deduct quantity assigned to each orderItemGiftRecipient for total orderItem quantity
		for(var orderItemGiftRecipient in this.getOrderItemGiftRecipients()){
			count = count - orderItemGiftRecipient.getQuantity();
		}

		return count;

	}

	public boolean function hasUnassignedGiftCards(){
		return this.getNumberOfUnassignedGiftCards() > 0;
	}

	public boolean function hasAllGiftCardsAssigned(){
		return this.getNumberOfUnassignedGiftCards() == 0;
	}

	public boolean function isGiftCardOrderItem(){
		return this.getSku().isGiftCardSku();
	}

	public boolean function isGiftCardOrderItemAndManuallyProvideGiftCardCodes() {
		return getSku().isGiftCardSku() && !getSku().getGiftCardAutoGenerateCodeFlag();
	}

    public any function getAllOrderItemGiftRecipientsSmartList(){
        var orderItemGiftRecipientSmartList = getService("OrderService").getOrderItemGiftRecipientSmartList();
        orderItemGiftRecipientSmartList.joinRelatedProperty("SlatwallOrderItemGiftRecipient", "orderItem", "left", true);
        orderItemGiftRecipientSmartList.addWhereCondition("aslatwallorderitem.orderItemID='#this.getOrderItemID()#'");
        return orderItemGiftRecipientSmartList;
    }

	public numeric function getTotalWeight() {
		if(!structKeyExists(variables,'totalWeight')){
			variables.totalWeight = getService('HibachiUtilityService').precisionCalculate(getSku().getWeight() * getQuantity());;
		}
		return variables.totalWeight;
	}

	public numeric function getMaximumOrderQuantity() {
		var maxQTY = 0;
		if(getSku().getActiveFlag() && getSku().getProduct().getActiveFlag()) {
			maxQTY = getSku().setting('skuOrderMaximumQuantity');
			if(getSku().setting('skuTrackInventoryFlag') && !getSku().setting('skuAllowBackorderFlag') && getOrderItemType().getSystemCode() neq 'oitReturn') {
				
				if( !isNull(getStock()) && getStock().getQuantity('QATS') <= maxQTY && getStock().getLocation().setting('locationRequiresQATSForOrdering')) {
					
					maxQTY = getStock().getQuantity('QATS');
				
				} else if( getSku().getQATS() <= maxQTY ){
					
					if ( isNull( this.getOrder().getDefaultStockLocation() ) ){
						maxQTY = getSku().getQATS();
					}else{
						maxQTY = getSku().getQuantity(quantityType='QATS', locationID=this.getOrder().getDefaultStockLocation().getLocationID() );
					}
				}
				
				if(!isNull(getOrder()) && getOrder().getOrderStatusType().getSystemCode() neq 'ostNotPlaced') {
					maxQTY += getService('orderService').getOrderItemDBQuantity( orderItemID=this.getOrderItemID() );
				}
				
			}
		}
		return maxQTY;
	}


 	public boolean function getQuantityHasChangedOrOrderNotPlaced(){
 		if (getOrder().getStatusCode() == "ostNotPlaced" || getQuantityHasChanged()){
 			return true;
 		}
 		return false;
 	}
 	
    public boolean function hasQuantityWithinMaxOrderQuantity(boolean forceMaxOrderSettingFlag=false){
		if(getOrderItemType().getSystemCode() == 'oitSale') {
			var quantity = 0;
			if(!isNull(getOrder())){
				quantity = getOrder().getTotalQuantityBySkuID( getSku().getSkuID() );
			} else {
				quantity = getQuantity();
			}
			
			//if forceMaxOrderSettingFlag is true and the quantity is > than the maxOrderQuantitySettting
			//then we'll want to return true so that we validate against that instead
			if (arguments.forceMaxOrderSettingFlag && quantity > getSku().setting('skuOrderMaximumQuantity')) {
				return true;
			}
			
            return quantity <= getMaximumOrderQuantity();
        }
        
        return true;
    }
    
	public boolean function getQuantityHasChangedAndHasOrderDelivery(){
 		if ( getQuantityHasChanged() && hasOrderDeliveryItem() )   {
 			return true;
 		}
 		return false;
 	}
 	
	public boolean function hasQuantityAboveOrderDelivery(){
		
		if ( getQuantity() < getQuantityDelivered() ){
			return false;
		}
		
		return true;
	}


    public boolean function hasQuantityWithinQATS(){
		if( getSku().getActiveFlag() && getSku().getProduct().getActiveFlag() && getSku().setting('skuTrackInventoryFlag') == 0   ){
			return true;
		}
		return hasQuantityWithinMaxOrderQuantity(forceMaxOrderSettingFlag=true);
	}

    public boolean function hasQuantityWithinSkuOrderMaximumQuantity() {
    	
		if(getOrderItemType().getSystemCode() == 'oitSale') {
			var quantity = 0;
			if(!isNull(getOrder())){
				quantity = getOrder().getTotalQuantityBySkuID( getSku().getSkuID() );
			} else {
				quantity = getQuantity();
			}
			
			return quantity <= getSku().setting('skuOrderMaximumQuantity');
		}
		return true;
	}

    public boolean function hasQuantityWithinMinOrderQuantity() {
        if(getOrderItemType().getSystemCode() == 'oitSale') {
        	var quantity = 0;
        	if(!isNull(getOrder())){
				quantity = getOrder().getTotalQuantityBySkuID( getSku().getSkuID() );
			} else {
				quantity = getQuantity();
			}
            return quantity >= getSku().setting('skuOrderMinimumQuantity');
        }
        return true;
    }

    public boolean function isRootOrderItem(){
    	return isNull(this.getParentOrderItem());
    }

	public string function getOrderStatusCode(){
		if(!isNull(getOrder())){
			return getOrder().getStatusCode();
		}
	}

	public string function getStatus(){
		return getOrderItemStatusType().getTypeName();
	}

	public string function getStatusCode() {
		return getOrderItemStatusType().getSystemCode();
	}

	public string function getType(){
		return getOrderItemType().getTypeName();
	}

	public string function getTypeCode(){
		return getOrderItemType().getSystemCode();
	}

	public any function getRenewalSku(){
		if(!isNull(this.getSku()) && !isNull(this.getSku().getRenewalSku())){
			return this.getSku().getRenewalSku();
		}
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

    // This method returns a single percentage rate for all taxes. So an item with tax 5% and 8% would return 13.
    public numeric function getCombinedTaxRate() {
    	if(!structKeyExists(variables,'combinedTaxRate')){
    		var taxRate = 0;
	    	for(var i=1; i <= ArrayLen(getAppliedTaxes()); i++) {
	    		taxRate = getService('HibachiUtilityService').precisionCalculate(taxRate + getAppliedTaxes()[i].getTaxRate());
	    	}
	    	variables.combinedTaxRate = taxRate;
    	}
    	

    	return variables.combinedTaxRate;
    }

    public struct function getQuantityPriceAlreadyReturned() {
    	return getService("OrderService").getQuantityPriceSkuAlreadyReturned(getOrder().getOrderID(), getSku().getSkuID());
    }

    public any function getEstimatedFulfillmentDateTime(){
    	if(structKeyExists(variables, "estimatedFulfillmentDateTime")) {
			return variables.estimatedFulfillmentDateTime;
		}else if (!isNull(getOrderFulfillment())){
			return getOrderFulfillment().getEstimatedFulfillmentDateTime();
		}
    }

    public any function getEstimatedDeliveryDateTime(){
    	if(structKeyExists(variables, "estimatedDeliveryDateTime")) {
			return variables.estimatedDeliveryDateTime;
		}else if (!isNull(getOrderFulfillment())){
			return getOrderFulfillment().getEstimatedDeliveryDateTime();
		}
    }


	// ============ START: Non-Persistent Property Methods =================

	public numeric function getDiscountAmount(boolean forceCalculationFlag = true) {
		var discountAmount = 0;
	
		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getDiscountAmount());
		}
		
		if(!isNull(getSku()) && !isNull(getSku().getProduct()) && !isNull(getSku().getProduct().getProductType()) && getSku().getProduct().getProductType().getSystemCode() == 'productBundle'){
			for(var childOrderItem in this.getChildOrderItems()){
				discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + childOrderItem.getDiscountAmount());
			}
		}
		

		return discountAmount;
	}

	public numeric function getExtendedPrice() {
		if(!structKeyExists(variables,'extendedPrice')){
			var price = 0;
		
			//get bundle price
			if(!isnull(getSku()) && !isNull(getSku().getProduct()) && !isNull(getSku().getProduct().getProductType()) && getSku().getProduct().getProductType().getSystemCode() == 'productBundle'){
				price = getProductBundlePrice();
			}else if(!isNull(getPrice())){
				price = getPrice();
			}
			variables.extendedPrice = val(getService('HibachiUtilityService').precisionCalculate(round(price * val(getQuantity()) * 100) / 100));
		}
		return variables.extendedPrice;
	}
	
	public void function setPrice(numeric price){
		if(structKeyExists(arguments,'price')){
			variables.price = arguments.price;
			if(structKeyExists(variables,'extendedPrice')){
				structDelete(variables,'extendedPrice');
			}
		}
	}


	public numeric function getProductBundlePrice(){
		//first get the base price of the product bundle itself
		var productBundlePrice = this.getSkuPrice();
		//then get the price of it's componenets and add them
		for(var childOrderItem in this.getChildOrderItems()){
			var childProductBundleGroupPrice = getProductBundleGroupPrice(childOrderItem);
			var childQuantity = childOrderItem.getQuantity();
			//if we have a package quantity use that instead
			if(!isNull(childOrderItem.getBundleItemQuantity())){
				childQuantity = childOrderItem.getBundleItemQuantity();
			}
			productBundlePrice += getService('HibachiUtilityService').precisionCalculate(childProductBundleGroupPrice * childQuantity);
		}

		return productBundlePrice;
	}

	public numeric function getProductBundleGroupPrice(any orderItem){
		if(isNull(arguments.orderItem)){
			arguments.orderItem = this;
		}

		var amountType = "skuPrice";//default
		if (!isNull(arguments.orderItem.getProductBundleGroup())){
			amountType = arguments.orderItem.getProductBundleGroup().getAmountType();
		}

		//fixed
		if(amountType == 'fixed'){
			return arguments.orderItem.getProductBundleGroup().getAmount();
		//none
		}else if(amountType == 'none'){
			return 0;
		//skuPrice
		}else if(amountType == 'skuPrice'){
			if(
				!isnull(arguments.orderItem.getSku())
				&& !isnull(arguments.orderItem.getSku().getProduct())
				&& !isnull(arguments.orderItem.getSku().getProduct().getProductType())
				&& arguments.orderItem.getSku().getProduct().getProductType().getSystemCode() == 'productBundle'
			){
				return arguments.orderItem.getProductBundlePrice();
			}else{
				return arguments.orderItem.getSkuPrice();
			}
		//skuPricePercentageIncrease
		}else if(amountType == 'skuPricePercentageIncrease'){
			if(
				!isnull(arguments.orderItem.getSku())
				&& !isnull(arguments.orderItem.getSku().getProduct())
				&& !isnull(arguments.orderItem.getSku().getProduct().getProductType())
				&& arguments.orderItem.getSku().getProduct().getProductType().getSystemCode() == 'productBundle'
			){
				return arguments.orderItem.getProductBundlePrice() + (arguments.orderItem.getProductBundlePrice() * (arguments.orderItem.getProductBundleGroup().getAmount()/100));
			}else{
				return arguments.orderItem.getSkuPrice() + (arguments.orderItem.getSkuPrice() * (arguments.orderItem.getProductBundleGroup().getAmount()/100));
			}

		//skuPricePercentageDecrease
		}else if(amountType == 'skuPricePercentageDecrease'){
			if(
				!isnull(arguments.orderItem.getSku())
				&& !isnull(arguments.orderItem.getSku().getProduct())
				&& !isnull(arguments.orderItem.getSku().getProduct().getProductType())
				&& arguments.orderItem.getSku().getProduct().getProductType().getSystemCode() == 'productBundle'
			){
				return arguments.orderItem.getProductBundlePrice() - (arguments.orderItem.getProductBundlePrice() * (arguments.orderItem.getProductBundleGroup().getAmount()/100));
			}else{
				return arguments.orderItem.getSkuPrice() - (arguments.orderItem.getSkuPrice() * (arguments.orderItem.getProductBundleGroup().getAmount()/100));
			}
		}

	}


	public numeric function getExtendedSkuPrice() {
		return getService('HibachiUtilityService').precisionCalculate(getSkuPrice() * getQuantity());
	}

	public numeric function getExtendedPriceAfterDiscount(boolean forceCalculationFlag = false) {
		return getService('HibachiUtilityService').precisionCalculate(getExtendedPrice() - getDiscountAmount(argumentCollection=arguments));
	}
	
	public numeric function getExtendedPriceAfterDiscountMinusReturns(boolean forceCalculationFlag = false) {
		return getService('HibachiUtilityService').precisionCalculate(getExtendedPrice() - getDiscountAmount(argumentCollection=arguments) - getExtendedPriceOnReturns());
	}
	
	public numeric function getExtendedPriceOnReturns(){
		var total = 0;
		var referencingOrderItemSmartList = getService('HibachiService').getOrderItemSmartList();
		referencingOrderItemSmartList.joinRelatedProperty('SlatwallOrderItem','orderItemType','inner');
		referencingOrderItemSmartList.joinRelatedProperty('SlatwallOrderItem','order','inner');
		referencingOrderItemSmartList.joinRelatedProperty('SlatwallOrder','orderStatusType','inner');
		referencingOrderItemSmartList.addWhereCondition("aslatwalltype.systemCode IN ('oitReturn','oitReplacement')");
		referencingOrderItemSmartList.addWhereCondition("bslatwalltype.systemCode NOT IN ('ostCanceled','ostNotPlaced')");
		referencingOrderItemSmartList.addFilter('referencedOrderItem.orderItemID',getOrderItemID());
		var result = referencingOrderItemSmartList.getRecords();
		
		for(var item in result){
			if(item.getOrderItemType().getSystemCode() == 'oitReturn'){
				total += item.getExtendedPriceAfterDiscount();
			}else{
				total -= item.getExtendedPriceAfterDiscount();
			}
		}
		return total;
	}

	public numeric function getExtendedUnitPrice() {
		if(!isNull(getQuantity()) && getQuantity() > 0){
			return val(precisionEvaluate(getExtendedPrice() / getQuantity()));	
		}else{
			return 0;
		}
		
	}

	public numeric function getExtendedUnitPriceAfterDiscount() {
		if(!isNull(getQuantity()) && getQuantity() > 0){
			return val(precisionEvaluate(getExtendedPriceAfterDiscount() / getQuantity()));
		}else{
			return 0;
		}
		
	}

	public any function getActiveEventRegistrations() {
		if(!structKeyExists(variables, "activeRegistrationsSmartList")) {
			variables.activeRegistrationsSmartList = getService('EventRegistrationService').getEventRegistrationSmartList();
			variables.activeRegistrationsSmartList.addFilter('orderItem.orderItemID', getOrderItemID());
			variables.activeRegistrationsSmartList.addInFilter('eventRegistrationStatusType.systemCode', 'erstRegistered,erstWaitListed,erstPendingApproval,erstPendingConfirmation,erstAttended,erstNotPlaced');
		}

		return variables.activeRegistrationsSmartList;
	}
	
	public boolean function getSkuPerformCascadeCalculateFlag() {
		return getOrderStatusCode() != 'ostNotPlaced';
	}
	
	public boolean function getStockPerformCascadeCalculateFlag() {
		return getOrderStatusCode() != 'ostNotPlaced';
	}

	public numeric function getTaxAmount() {
		var taxAmount = 0;

		for(var taxApplied in getAppliedTaxes()) {
			taxAmount = getService('HibachiUtilityService').precisionCalculate(taxAmount + taxApplied.getTaxAmount());
		}

		return taxAmount;
	}
	
	public numeric function getTaxAmountNotRefunded(){
		return getService('HibachiUtilityService').precisionCalculate(getTaxAmount() + getTaxAmountOnReferencingItems());
	}
	
	public numeric function getTaxAmountOnReferencingItems(){
		var taxAmountOnReferencingItems = 0;
		
		for(var referencingOrderItem in getReferencingOrderItems()){
			if(!listFindNoCase('ostNotPlaced,ostCanceled',referencingOrderItem.getOrder().getOrderStatusType().getSystemCode())){
				if(referencingOrderItem.getOrderItemType().getSystemCode() == 'oitReturn'){
					taxAmountOnReferencingItems -= referencingOrderItem.getTaxAmount();
				}else{
					taxAmountOnReferencingItems += referencingOrderItem.getTaxAmount();
				}
			}
		}
		return taxAmountOnReferencingItems;
	}
	
	public numeric function getVATAmount() {
		if(!structKeyExists(variables,'VATAmount')){
			var VATAmount = 0;

			for(var taxApplied in getAppliedTaxes()) {
				VATAmount = getService('HibachiUtilityService').precisionCalculate(VATAmount + taxApplied.getVATAmount());
			}
			variables.VATAmount = VATAmount;
		}
		return variables.VATAmount;
	}
	
	public numeric function getVATPrice() {
		if(!structKeyExists(variables,'VATPrice')){
			var VATPrice = 0;

			for(var taxApplied in getAppliedTaxes()) {
				VATPrice = getService('HibachiUtilityService').precisionCalculate(VATPrice + taxApplied.getVATPrice());
			}
			variables.VATPrice = VATPrice;
		}
		return variables.VATPrice;
	}

	public numeric function getTaxLiabilityAmount() {
		if(!structKeyExists(variables,'taxLiabilityAmount')){
			var taxLiabilityAmount = 0;

			for(var taxApplied in getAppliedTaxes()) {
				taxLiabilityAmount = getService('HibachiUtilityService').precisionCalculate(taxLiabilityAmount + taxApplied.getTaxLiabilityAmount());
			}
			variables.taxLiabilityAmount = taxLiabilityAmount;
		}
		

		return variables.taxLiabilityAmount;
	}

	public void function setQuantity(required numeric quantity){
		if (structKeyExists(variables, "quantity") && structKeyExists(arguments,"quantity") && arguments.quantity != variables.quantity){
 			variables.quantityHasChanged = true; //a dirty check flag for validation.
 		}		
		variables.quantity = arguments.quantity;
		if(structKeyExists(variables,'extendedPrice')){
			structDelete(variables,'extenedPrice');
		}
		if(structKeyExists(variables,'totalWeight')){
			structDelete(variables,'totalWeight');
		}
		
		if(structKeyExists(variables,'taxAmount')){
			structDelete(variables,'taxAmount');
		}
		if(structKeyExists(variables,'taxLiabilityAmount')){
			structDelete(variables,'taxLiabilityAmount');
		}
		
		
		if(this.isRootOrderItem()){
			for(var childOrderItem in this.getChildOrderItems()){
				if (!isNull(childOrderItem.getBundleItemQuantity()) && structKeyExists(variables, "quantity")){
					var newQuantity = getService('HibachiUtilityService').precisionCalculate(childOrderItem.getBundleItemQuantity() * variables.quantity);
					childOrderItem.setQuantity(newQuantity);
				}
			}
		}
		
	}

	public void function setBundleItemQuantity(required numeric bundleItemQuantity){
		if(!this.isRootOrderItem()){
			variables.bundleItemQuantity = arguments.bundleItemQuantity;
			variables.quantity = getService('HibachiUtilityService').precisionCalculate(getParentOrderItem().getQuantity() * variables.bundleItemQuantity);
		}
	}

	public numeric function getQuantityDelivered() {
		var quantityDelivered = 0;

		for( var i=1; i<=arrayLen(getOrderDeliveryItems()); i++){
			if(!getOrderDeliveryItems()[i].getNewFlag()) {
				quantityDelivered += getOrderDeliveryItems()[i].getQuantity();
			}
		}

		return quantityDelivered;
	}
	
	public numeric function getQuantityDeliveredMinusReturns(){
		return getQuantityDelivered() - getQuantityOnReturnOrders();
	}
	
	public numeric function getQuantityOnReturnOrders(){
		
		var quantity = 0;
		
		var returnOrderItemCollectionList = getService('OrderService').getOrderItemCollectionList();
		returnOrderItemCollectionList.setDisplayProperties('quantity');
		returnOrderItemCollectionList.addFilter(propertyIdentifier='orderItemType.systemCode',value='oitReturn');
		returnOrderItemCollectionList.addFilter(propertyIdentifier='order.orderType.systemCode',value='otReturnOrder,otExchangeOrder',comparisonOperator='IN');
		returnOrderItemCollectionList.addFilter(propertyIdentifier='order.orderStatusType.systemCode',value='ostCanceled,ostNotPlaced',comparisonOperator='NOT IN');
		returnOrderItemCollectionList.addFilter(propertyIdentifier='referencedOrderItem.orderItemID',value=getOrderItemID());

		var result = returnOrderItemCollectionList.getRecords();
		if(!isNull(result) && arrayLen(result)){
			for(var item in result){
				quantity += item['quantity'];
			}
		}
		
		return quantity;
	}

	public numeric function getQuantityReceived() {
		var quantityReceived = 0;

		for( var i=1; i<=arrayLen(getStockReceiverItems()); i++){
			if(!getStockReceiverItems()[i].getNewFlag()) {
				quantityReceived += getStockReceiverItems()[i].getQuantity();
			}
		}

		return quantityReceived;
	}

	public numeric function getQuantityUnreceived() {
		return getQuantity() - getQuantityReceived();
	}

	public numeric function getQuantityUndelivered() {
		return getQuantity() - getQuantityDelivered();
	}

	public numeric function getItemTotal() {
		return val(getService('HibachiUtilityService').precisionCalculate(getTaxAmount() + getExtendedPriceAfterDiscount()));
	}
	
	public numeric function getItemTotalAfterOrderDiscounts() {
		return val(getService('HibachiUtilityService').precisionCalculate(getTaxAmount() + getExtendedPriceAfterAllDiscounts()));
	}

	public any function getSalePrice() {
		if(!structKeyExists(variables, "OrderItemSalePrice")) {
			variables.OrderItemSalePrice = getService("promotionService").getSalePriceDetailsForOrderItem(orderItem=this);
		}

		return variables.OrderItemSalePrice;
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

		// Remove from order fulfillment to trigger those actions
		if(!isNull(getOrderFulfillment())) {
			removeOrderFulfillment();
		} else if (!isNull(getOrderReturn())) {
			removeOrderReturn();
		}


		structDelete(variables, "order");
	}

	//gift card one to many
	public void function addGiftCard(required any giftCard){
		arguments.giftCard.setOriginalOrderItem( this );
	}

	public void function removeGiftCard(required any giftCard){
		arguments.giftCard.removeOriginalOrderItem( this );
	}
	
	public void function addStockHold(required any stockHold){
		arguments.stockHold.setOrderItem(this);
	}
	
	
	public void function removeStockHold(required any stockHold){
		arguments.stockHold.removeOrderItem( this );
	}

	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasOrderFulfillmentItem( this )) {
			arrayAppend(arguments.orderFulfillment.getOrderFulfillmentItems(), this);
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getOrderFulfillmentItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getOrderFulfillmentItems(), index);

			// IMPORTANT & CUSTOM!!!
			// if this was the last item in the fulfillment remove this fulfillment from order
			if(!arrayLen(arguments.orderFulfillment.getOrderFulfillmentItems()) && !isNull(getOrder())) {
				getOrder().removeOrderFulfillment(arguments.orderFulfillment);
			}
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
			arrayDeleteAt(arguments.orderReturn.getOrderReturnItems(), index);

			// IMPORTANT & CUSTOM!!!
			// if this was the last item in the return remove this return from order
			if(!arrayLen(arguments.orderReturn.getOrderReturnItems()) && !isNull(getOrder())) {
				getOrder().removeOrderReturn(arguments.orderReturn);
			}
		}
		structDelete(variables, "orderReturn");
	}

	// Parent Order Item (many-to-one)
	public void function setParentOrderItem(required any parentOrderItem) {
		variables.parentOrderItem = arguments.parentOrderItem;
		if(isNew() or !arguments.parentOrderItem.hasChildOrderItem( this )) {
			arrayAppend(arguments.parentOrderItem.getChildOrderItems(), this);
		}
	}

	public void function removeParentOrderItem(any parentOrderItem) {
		if(!structKeyExists(arguments, "parentOrderItem")) {
			arguments.parentOrderItem = variables.parentOrderItem;
		}
		var index = arrayFind(arguments.parentOrderItem.getChildOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentOrderItem.getChildOrderItems(), index);
		}
		structDelete(variables, "parentOrderItem");
	}

	// Referenced Order Item (many-to-one)
	public void function setReferencedOrderItem(required any referencedOrderItem) {
		variables.referencedOrderItem = arguments.referencedOrderItem;
		if(isNew() or !arguments.referencedOrderItem.hasReferencingOrderItem( this )) {
			arrayAppend(arguments.referencedOrderItem.getReferencingOrderItems(), this);
		}
	}
	public void function removeReferencedOrderItem(any referencedOrderItem) {
		if(!structKeyExists(arguments, "referencedOrderItem")) {
			arguments.referencedOrderItem = variables.referencedOrderItem;
		}
		var index = arrayFind(arguments.referencedOrderItem.getReferencingOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.referencedOrderItem.getReferencingOrderItems(), index);
		}
		structDelete(variables, "referencedOrderItem");
	}

	// OrderItemGiftRecipients (one-to-many)
	public void function addOrderItemGiftRecipient(required any orderItemGiftRecipient){
		arguments.orderItemGiftRecipient.setOrderItem( this );
	}

	public void function removeOrderItemGiftRecipient(required any orderItemGiftRecipient){
		arguments.orderItemGiftRecipient.removeOrderItem( this );
	}

	// Applied Promotions (one-to-many)
	public void function addAppliedPromotion(required any appliedPromotion) {
		if(structKeyExists(variables,'discountAmount')){
			structDelete(variables,'discountAmount');
		}
		
		if(structKeyExists(variables,'taxAmount')){
			structDelete(variables,'taxAmount');
		}
		if(structKeyExists(variables,'taxLiabilityAmount')){
			structDelete(variables,'taxLiabilityAmount');
		}
		
		
		arguments.appliedPromotion.setOrderItem( this );
	}
	public void function removeAppliedPromotion(required any appliedPromotion) {
		if(structKeyExists(variables,'discountAmount')){
			structDelete(variables,'discountAmount');
		}
		if(structKeyExists(variables,'taxAmount')){
			structDelete(variables,'taxAmount');
		}
		if(structKeyExists(variables,'taxLiabilityAmount')){
			structDelete(variables,'taxLiabilityAmount');
		}
		arguments.appliedPromotion.removeOrderItem( this );
	}

	// Applied Taxes (one-to-many)
	public void function addAppliedTax(required any appliedTax) {
		if(structKeyExists(variables,'taxAmount')){
			structDelete(variables,'taxAmount');
		}
		if(structKeyExists(variables,'taxLiabilityAmount')){
			structDelete(variables,'taxLiabilityAmount');
		}
		if(structKeyExists(variables,'combinedTaxRate')){
			structDelete(variables,'combinedTaxRate');
		}
		arguments.appliedTax.setOrderItem( this );
	}
	public void function removeAppliedTax(required any appliedTax) {
		if(structKeyExists(variables,'taxAmount')){
			structDelete(variables,'taxAmount');
		}
		if(structKeyExists(variables,'taxLiabilityAmount')){
			structDelete(variables,'taxLiabilityAmount');
		}
		if(structKeyExists(variables,'combinedTaxRate')){
			structDelete(variables,'combinedTaxRate');
		}
		arguments.appliedTax.removeOrderItem( this );
	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setOrderItem( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeOrderItem( this );
	}

	// Event Registrations (one-to-many)
 	public void function addEventRegistration(required any eventRegistration) {
		arguments.eventRegistration.setOrderItem( this );
  	}
	public void function removeEventRegistration(required any eventRegistration) {
 		arguments.eventRegistration.removeOrderItem( this );
  	}

	// Child Order Items (one-to-many)
	public void function addChildOrderItem(required any childOrderItem) {
		arguments.childOrderItem.setParentOrderItem( this );
	}
	public void function removeChildOrderItem(required any childOrderItem) {
		arguments.childOrderItem.removeParentOrderItem( this );
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

	// Referencing Order Items (one-to-many)
	public void function addReferencingOrderItem(required any referencingOrderItem) {
		arguments.referencingOrderItem.setReferencedOrderItem( this );
	}
	public void function removeReferencingOrderItem(required any referencingOrderItem) {
		arguments.referencingOrderItem.removeReferencedOrderItem( this );
	}
	
	// Fulfillment Batches (one-to-many)
	public void function addFulfillmentBatchItem(required any fulfillmentBatchItem) {
	   arguments.fulfillmentBatchItem.setOrderItem(this);
	}
	public void function removeFulfillmentBatchItem(required any fulfillmentBatchItem) {
	   arguments.fulfillmentBatchItem.removeOrderItem(this);
	}
	

	// ShippingMethodOptionSplitShipment (many-to-many - owner)
	public void function addShippingMethodOptionSplitShipment(required any shippingMethodOptionSplitShipment) {
		if(isNew() or !hasShippingMethodOptionSplitShipment(arguments.shippingMethodOptionSplitShipment)) {
			arrayAppend(variables.shippingMethodOptionSplitShipments, arguments.shippingMethodOptionSplitShipment);
		}
		if(arguments.shippingMethodOptionSplitShipment.isNew() or !arguments.shippingMethodOptionSplitShipment.hasShipmentOrderItem( this )) {
			arrayAppend(arguments.shippingMethodOptionSplitShipment.getShipmentOrderItems(), this);
		}
	}
	public void function removeShippingMethodOptionSplitShipment(required any shippingMethodOptionSplitShipment) {
		var thisIndex = arrayFind(variables.shippingMethodOptionSplitShipment, arguments.shippingMethodOptionSplitShipment);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.shippingMethodOptionSplitShipments, thisIndex);
		}
		var thatIndex = arrayFind(arguments.shippingMethodOptionSplitShipment.getShipmentOrderItems(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.shippingMethodOptionSplitShipment.getShipmentOrderItems(), thatIndex);
		}
	}


	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================

	public any function getOrderItemType() {
		if( !structKeyExists(variables, "orderItemType") ) {
			variables.orderItemType = getService("typeService").getTypeBySystemCode("oitSale");
		}
		return variables.orderItemType;
	}

	public any function getOrderItemStatusType() {
		if( !structKeyExists(variables, "orderItemStatusType") ) {
			variables.orderItemStatusType = getService("typeService").getTypeBySystemCode("oistNew");
		}
		return variables.orderItemStatusType;
	}

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

	public boolean function isEditable() {
		if(listFindNoCase("ostClosed,ostCanceled", getOrder().getStatusCode())) {
			return false;
		}
		return true;
	}

	public string function getSimpleRepresentation() {
		return getSku().getProduct().getTitle() & " - " & getSku().getSimpleRepresentation();
	}

	public string function getSimpleRepresentationPropertyName(){
		return "orderItemID";
	}

	public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {

			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();

			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetObject', 'OrderItem');

			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "productTypes", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "products", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "brands", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "skus", "left");


			var wc = "(";
			wc &= " aslatwallattributeset.globalFlag = 1";

			if(!isNull(getSku())) {

				wc &= " OR aslatwallsku.skuID = '#getSku().getSkuID()#'";

				if(!isNull(getSku().getProduct())) {

					wc &= " OR aslatwallproduct.productID = '#getSku().getProduct().getProductID()#'";

					if(!isNull(getSku().getProduct().getProductType())) {
						wc &= " OR aslatwallproducttype.productTypeID IN ('#replace(getSku().getProduct().getProductType().getProductTypeIDPath(),",","','","all")#')";
					}
					if(!isNull(getSku().getProduct().getBrand())) {
						wc &= " OR aslatwallbrand.brandID = '#getSku().getProduct().getBrand().getBrandID()#'";
					}
				}
			}
			wc &= ")";

			variables.assignedAttributeSetSmartList.addWhereCondition( wc );
		}

		return variables.assignedAttributeSetSmartList;
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	public void function preInsert(){
		super.preInsert();

		// Verify Defaults are Set
		getOrderItemType();
		getOrderItemStatusType();

	}

	// ===================  END:  ORM Event Hooks  =========================	
		//CUSTOM FUNCTIONS BEGIN

public void function refreshAmounts(){
        variables.personalVolume = getCustomPriceFieldAmount('personalVolume');
        variables.taxableAmount = getCustomPriceFieldAmount('taxableAmount');
        variables.commissionableVolume = getCustomPriceFieldAmount('commissionableVolume');
        variables.retailCommission = getCustomPriceFieldAmount('retailCommission');
        variables.productPackVolume = getCustomPriceFieldAmount('productPackVolume');
        variables.retailValueVolume = getCustomPriceFieldAmount('retailValueVolume');
    }
    
    public any function getPersonalVolume(){
        if(!structKeyExists(variables,'personalVolume')){
            variables.personalVolume = getCustomPriceFieldAmount('personalVolume');
        }
        return variables.personalVolume;
    }
    
    public any function getListPrice(){
        
        if(!structKeyExists(variables,'listPrice')){
            variables.listPrice = getCustomPriceFieldAmount('listPrice');
        }
        
        return variables.listPrice;
    }
    
    public any function getTaxableAmount(){
       if(!structKeyExists(variables,'taxableAmount')){
            variables.taxableAmount = getCustomPriceFieldAmount('taxableAmount');
        }
        return variables.taxableAmount;
    }
    
    public any function getCommissionableVolume(){
        if(!structKeyExists(variables,'commissionableVolume')){
            variables.commissionableVolume = getCustomPriceFieldAmount('commissionableVolume');
        }
        return variables.commissionableVolume;
    }
    
    public any function getRetailCommission(){
        if(!structKeyExists(variables,'retailCommission')){
            variables.retailCommission = getCustomPriceFieldAmount('retailCommission');
        }
        return variables.retailCommission;
    }
    
    public any function getProductPackVolume(){
        if(!structKeyExists(variables,'productPackVolume')){
            variables.productPackVolume = getCustomPriceFieldAmount('productPackVolume');
        }
        return variables.productPackVolume;
    }
    
    public any function getRetailValueVolume(){
        if(!structKeyExists(variables,'retailValueVolume')){
            variables.retailValueVolume = getCustomPriceFieldAmount('retailValueVolume');
        }
        return variables.retailValueVolume;
    }
    
    public any function getPersonalVolumeDiscountAmount(){
        return getCustomDiscountAmount('personalVolume');
    }
    
    public any function getTaxableAmountDiscountAmount(){
        return getCustomDiscountAmount('taxableAmount');
    }
    
    public any function getCommissionableVolumeDiscountAmount(){
        return getCustomDiscountAmount('commissionableVolume');
    }
    
    public any function getRetailCommissionDiscountAmount(){
        return getCustomDiscountAmount('retailCommission');
    }
    
    public any function getProductPackVolumeDiscountAmount(){
        return getCustomDiscountAmount('productPackVolume');
    }
    
    public any function getRetailValueVolumeDiscountAmount(){
        return getCustomDiscountAmount('retailValueVolume');
    }
    
    public any function getExtendedPersonalVolume(){
        return getCustomExtendedPrice('personalVolume');
    }
    
    public any function getExtendedTaxableAmount(){
        return getCustomExtendedPrice('taxableAmount');
    }
    
    public any function getExtendedCommissionableVolume(){
        return getCustomExtendedPrice('commissionableVolume');
    }
    
    public any function getExtendedRetailCommission(){
        return getCustomExtendedPrice('retailCommission');
    }
    
    public any function getExtendedProductPackVolume(){
        return getCustomExtendedPrice('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolume(){
        return getCustomExtendedPrice('retailValueVolume');
    }
    
    public any function getExtendedPersonalVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('personalVolume');
    }
    
    public any function getExtendedTaxableAmountAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('taxableAmount');
    }
    
    public any function getExtendedCommissionableVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('commissionableVolume');
    }
    
    public any function getExtendedRetailCommissionAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('retailCommission');
    }
    
    public any function getExtendedProductPackVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('retailValueVolume');
    }
    
    public any function getExtendedPersonalVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('personalVolume');
    }
    
    public any function getExtendedTaxableAmountAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('taxableAmount');
    }
    
    public any function getExtendedCommissionableVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('commissionableVolume');
    }
    
    public any function getExtendedRetailCommissionAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('retailCommission');
    }
    
    public any function getExtendedProductPackVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('retailValueVolume');
    }
    
    public any function getNetAmount(){
        if(!structKeyExists(variables,'netAmount')){
            variables.netAmount = getService('HibachiUtilityService').precisionCalculate(this.getExtendedPriceAfterDiscount() - this.getExtendedPersonalVolumeAfterDiscount())
        }
        return variables.netAmount;
    }
    
	private numeric function getCustomPriceFieldAmount(required string customPriceField){
        arguments.currencyCode = this.getCurrencyCode();
		arguments.quantity = this.getQuantity();
		
		if(!isNull(this.getOrder().getPriceGroup())){
		    arguments.priceGroups = [this.getOrder().getPriceGroup()];
		}else if(!isNull(this.getOrder().getAccount())){ 
			arguments.accountID = this.getOrder().getAccount().getAccountID();  
		}else if(!isNull(this.getAppliedPriceGroup())){ 
			arguments.priceGroups = [];
			arrayAppend(arguments.priceGroups, this.getAppliedPriceGroup());
		}
		
        var amount = getSku().getCustomPriceByCurrencyCode(argumentCollection=arguments);
        if(isNull(amount)){
            amount = 0;
        }
        return amount;
    }
    
    public numeric function getCustomDiscountAmount(required string priceField, boolean forceCalculationFlag = true) {
		var discountAmount = 0;
	
		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].invokeMethod('get#arguments.priceField#DiscountAmount'));
		}
		
		if(!isNull(getSku()) && getSku().getProduct().getProductType().getSystemCode() == 'productBundle'){
			for(var childOrderItem in this.getChildOrderItems()){
				discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + childOrderItem.getCustomDiscountAmount(arguments.priceField));
			}
		}
		
		return discountAmount;
	}
    
	public numeric function getCustomExtendedPrice(required string priceField) {
		if(!structKeyExists(variables,'extended#arguments.priceField#')){
			var price = 0;
			
			// Check if there is a manual override (should not be used to standard sales orders, only applies to referencing order types: returns, refund, etc.)
			var manualPrice = this.invokeMethod('getManual#arguments.priceField#');
		    if(listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', getOrder().getTypeCode()) && !isNull(manualPrice) && manualPrice > 0){
				price = this.invokeMethod('getManual#arguments.priceField#');
			} else if(!isNull(this.invokeMethod('get#arguments.priceField#'))){
				price = this.invokeMethod('get#arguments.priceField#');
			}
			variables['extended#arguments.priceField#'] = val(getService('HibachiUtilityService').precisionCalculate(round(price * val(getQuantity()) * 100) / 100));
		}
		return variables['extended#arguments.priceField#'];
	}
	
	public numeric function getAllocatedOrderCustomPriceFieldDiscountAmount(required string priceField){
	    return this.invokeMethod('getAllocatedOrder#arguments.priceField#DiscountAmount')
	}
	
	public numeric function getCustomExtendedPriceAfterDiscount(required string priceField, boolean forceCalculationFlag = false) {
		return getService('HibachiUtilityService').precisionCalculate(getCustomExtendedPrice(priceField) - getCustomDiscountAmount(argumentCollection=arguments));
	}
	
	public any function getSkuProductURL(){
		var skuProductURL = this.getSku().getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}
	
	public any function getMainCreditCardOnOrder(){
	    var orderPayments = this.getOrder().getOrderPayments();
	    if(arrayLen(orderPayments)){
    		var mainCreditCardOnOrder = orderPayments[1].getCreditCardLastFour();
	    }else{
	        var mainCreditCardOnOrder = "";
	    }
		return mainCreditCardOnOrder;
	}
	
	public any function getMainCreditCardExpirationDate(){
	    var orderPayments = this.getOrder().getOrderPayments();
	    if(arrayLen(orderPayments)){
    	    var orderPayment = orderPayments[1];
		    var mainCreditCardExpirationDate = toString(orderPayment.getExpirationMonth()) & "/" & toString(orderPayment.getExpirationYear());
	    }else{
	        var mainCreditCardExpirationDate = "";
	    }

		return mainCreditCardExpirationDate;
	}
	
	public any function getMainPromotionOnOrder(){
	    var promotionCodes = this.getOrder().getPromotionCodes();
	    if(arrayLen(promotionCodes)){
    	    var mainPromotionOnOrder = promotionCodes[1].getPromotion().getPromotionName();
    	} else{
    	    var mainPromotionOnOrder = "";
    	}
    	
    	return mainPromotionOnOrder;
	}
	
	public void function removePersonalVolume(){
	    if(structKeyExists(variables,'personalVolume')){
	        structDelete(variables,'personalVolume');
	    }
	}
    public void function removeTaxableAmount(){
        if(structKeyExists(variables,'taxableAmount')){
            structDelete(variables,'taxableAmount');
        }
    }
    public void function removeCommissionableVolume(){
        if(structKeyExists(variables,'commissionableVolume')){
            structDelete(variables,'commissionableVolume');
        }
    }
    public void function removeRetailCommission(){
        if(structKeyExists(variables,'retailCommission')){
            structDelete(variables,'retailCommission');
        }
    }
    public void function removeProductPackVolume(){
        if(structKeyExists(variables,'productPackVolume')){
            structDelete(variables,'productPackVolume');
        }
    }
    public void function removeRetailValueVolume(){
        if(structKeyExists(variables,'retailValueVolume')){
            structDelete(variables,'retailValueVolume');
        }
    }
//CUSTOM FUNCTIONS END
}
