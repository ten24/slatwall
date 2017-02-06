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
	property name="price" ormtype="big_decimal";
	property name="skuPrice" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	property name="quantity" hb_populateEnabled="public" ormtype="integer";
	property name="bundleItemQuantity" hb_populateEnabled="public" ormtype="integer";
	property name="estimatedDeliveryDateTime" ormtype="timestamp";
	property name="estimatedFulfillmentDateTime" ormtype="timestamp";

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
	property name="referencedOrderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="referencedOrderItemID"; // Used For Returns. This is set when this order is a return.

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

	// Non persistent properties
	property name="activeEventRegistrations" persistent="false";
	property name="discountAmount" persistent="false" hb_formatType="currency" hint="This is the discount amount after quantity (talk to Greg if you don't understand)" ;
	property name="extendedPrice" persistent="false" hb_formatType="currency";
	property name="extendedPriceAfterDiscount" persistent="false" hb_formatType="currency";
	property name="orderStatusCode" persistent="false";
	property name="quantityDelivered" persistent="false";
	property name="quantityUndelivered" persistent="false";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	property name="registrants" persistent="false";
	property name="renewalSku" persistent="false";
	property name="taxAmount" persistent="false" hb_formatType="currency";
	property name="taxLiabilityAmount" persistent="false" hb_formatType="currency";
	property name="itemTotal" persistent="false" hb_formatType="currency";
	property name="productBundlePrice" persistent="false" hb_formatType="currency";
	property name="productBundleGroupPrice" persistent="false" hb_formatType="currency";
	property name="salePrice" type="struct" persistent="false";
	property name="totalWeight" persistent="false";


	public numeric function getNumberOfUnassignedGiftCards(){

		if(!this.isGiftCardOrderItem()){
			return 0;
		}

		var orderItemGiftRecipients = this.getOrderItemGiftRecipients();
		var count = this.getQuantity();

		for(var recipient in orderItemGiftRecipients){
			count = count - recipient.getQuantity();
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

    public any function getAllOrderItemGiftRecipientsSmartList(){
        var orderItemGiftRecipientSmartList = getService("OrderService").getOrderItemGiftRecipientSmartList();
        orderItemGiftRecipientSmartList.joinRelatedProperty("SlatwallOrderItemGiftRecipient", "orderItem", "left", true);
        orderItemGiftRecipientSmartList.addWhereCondition("aslatwallorderitem.orderItemID='#this.getOrderItemID()#'");
        return orderItemGiftRecipientSmartList;
    }

	public numeric function getTotalWeight() {
		return getService('HibachiUtilityService').precisionCalculate(getSku().getWeight() * getQuantity());
	}

	public numeric function getMaximumOrderQuantity() {
		var maxQTY = 0;
		if(getSku().getActiveFlag() && getSku().getProduct().getActiveFlag()) {
			maxQTY = getSku().setting('skuOrderMaximumQuantity');
			if(getSku().setting('skuTrackInventoryFlag') && !getSku().setting('skuAllowBackorderFlag')) {
				if( !isNull(getStock()) && getStock().getQuantity('QATS') <= maxQTY ) {
					maxQTY = getStock().getQuantity('QATS');
					if(!isNull(getOrder()) && getOrder().getOrderStatusType().getSystemCode() neq 'ostNotPlaced') {
						maxQTY += getService('orderService').getOrderItemDBQuantity( orderItemID=this.getOrderItemID() );
					}
				} else if(getSku().getQuantity('QATS') <= maxQTY) {
					maxQTY = getSku().getQuantity('QATS');
					if(!isNull(getOrder()) && getOrder().getOrderStatusType().getSystemCode() neq 'ostNotPlaced') {
						maxQTY += getService('orderService').getOrderItemDBQuantity( orderItemID=this.getOrderItemID() );
					}
				}
			}
		}

		return maxQTY;
	}


    public boolean function hasQuantityWithinMaxOrderQuantity() {
        if(getOrderItemType().getSystemCode() == 'oitSale') {
        	var quantity = 0;
			if(!isNull(getOrder())){
				for (var orderItem in getOrder().getOrderItems()){
					if (!isNull(orderItem.getSku()) && orderItem.getSku().getSkuID() == getSku().getSkuID()) {
						quantity += orderItem.getQuantity();
					}
				}
			} else {
				quantity = getQuantity();
			}
            return quantity <= getMaximumOrderQuantity();
        }
        return true;
    }

    public boolean function hasQuantityWithinMinOrderQuantity() {
        if(getOrderItemType().getSystemCode() == 'oitSale') {
        	var quantity = 0;
        	if(!isNull(getOrder())){
				for (var orderItem in getOrder().getOrderItems()){
					if (!isNull(orderItem.getSku()) && orderItem.getSku().getSkuID() == getSku().getSkuID()) {
						quantity += orderItem.getQuantity();
					}
				}
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
		return getOrder().getStatusCode();
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
    	var taxRate = 0;
    	for(var i=1; i <= ArrayLen(getAppliedTaxes()); i++) {
    		taxRate = getService('HibachiUtilityService').precisionCalculate(taxRate + getAppliedTaxes()[i].getTaxRate());
    	}

    	return taxRate;
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

	public numeric function getDiscountAmount() {
		var discountAmount = 0;

		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getDiscountAmount());
		}

		if(!isNull(getSku()) && getSku().getProduct().getProductType().getSystemCode() == 'productBundle'){
			for(var childOrderItem in this.getChildOrderItems()){
				discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + childOrderItem.getDiscountAmount());
			}
		}

		return discountAmount;
	}

	public numeric function getExtendedPrice() {
		var price = 0;

		//get bundle price
		if(!isnull(getSku()) && getSku().getProduct().getProductType().getSystemCode() == 'productBundle'){
			price = getProductBundlePrice();
		}else if(!isNull(getPrice())){
			price = getPrice();
		}
		return val(getService('HibachiUtilityService').precisionCalculate(round(price * val(getQuantity()) * 100) / 100));

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

	public numeric function getExtendedPriceAfterDiscount() {
		return getService('HibachiUtilityService').precisionCalculate(getExtendedPrice() - getDiscountAmount());
	}

	public any function getActiveEventRegistrations() {
		if(!structKeyExists(variables, "activeRegistrationsSmartList")) {
			variables.activeRegistrationsSmartList = getService('EventRegistrationService').getEventRegistrationSmartList();
			variables.activeRegistrationsSmartList.addFilter('orderItem.orderItemID', getOrderItemID());
			variables.activeRegistrationsSmartList.addInFilter('eventRegistrationStatusType.systemCode', 'erstRegistered,erstWaitListed,erstPendingApproval,erstPendingConfirmation,erstAttended,erstNotPlaced');
		}

		return variables.activeRegistrationsSmartList;
	}

	public numeric function getTaxAmount() {
		var taxAmount = 0;

		for(var taxApplied in getAppliedTaxes()) {
			taxAmount = getService('HibachiUtilityService').precisionCalculate(taxAmount + taxApplied.getTaxAmount());
		}

		return taxAmount;
	}

	public numeric function getTaxLiabilityAmount() {
		var taxLiabilityAmount = 0;

		for(var taxApplied in getAppliedTaxes()) {
			taxLiabilityAmount = getService('HibachiUtilityService').precisionCalculate(taxLiabilityAmount + taxApplied.getTaxLiabilityAmount());
		}

		return taxLiabilityAmount;
	}

	public void function setQuantity(required numeric quantity){
		variables.quantity = arguments.quantity;
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
		return getService('HibachiUtilityService').precisionCalculate(getTaxAmount() + getExtendedPriceAfterDiscount());
	}

	public any function getSalePrice() {
		if(!structKeyExists(variables, "OrderItemSalePrice")) {
			variables.OrderItemSalePrice = getService("promotionService").getSalePriceDetailsForOrderItem(orderItem=this);
		}

		return variables.OrderItemSalePrice;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Applied Price Group (many-to-one)
	public void function setAppliedPriceGroup(required any appliedPriceGroup) {
		variables.appliedPriceGroup = arguments.appliedPriceGroup;
		if(isNew() or !arguments.appliedPriceGroup.hasAppliedOrderItem( this )) {
			arrayAppend(arguments.appliedPriceGroup.getAppliedOrderItems(), this);
		}
	}
	public void function removeAppliedPriceGroup(any appliedPriceGroup) {
		if(!structKeyExists(arguments, "appliedPriceGroup")) {
			arguments.appliedPriceGroup = variables.appliedPriceGroup;
		}
		var index = arrayFind(arguments.appliedPriceGroup.getAppliedOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.appliedPriceGroup.getAppliedOrderItems(), index);
		}
		structDelete(variables, "appliedPriceGroup");
	}

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
}
