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
component displayname="Order Fulfillment" entityname="SlatwallOrderFulfillment" table="SwOrderFulfillment" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderFulfillments" hb_processContexts="fulfillItems,manualFulfillmentCharge,manualHandlingFee" {

	// Persistent Properties
	property name="orderFulfillmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="fulfillmentCharge" ormtype="big_decimal" hb_formatType="currency";
	property name="currencyCode" ormtype="string" length="3";
	property name="emailAddress" hb_populateEnabled="public" ormtype="string";
	property name="manualFulfillmentChargeFlag" ormtype="boolean" hb_populateEnabled="false";
	property name="manualHandlingFeeFlag" ormtype="boolean" hb_populateEnabled="false";
	property name="estimatedDeliveryDateTime" ormtype="timestamp";
	property name="estimatedFulfillmentDateTime" ormtype="timestamp";
	property name="estimatedShippingDate" ormtype="timestamp";
	property name="pickupDate" ormtype="timestamp" hb_populateenabled="true";
	property name="thirdPartyShippingAccountIdentifier" column="thirdPartyShipAccntIdentifier" ormtype="string";
	property name="handlingFee" ormtype="big_decimal" hb_formatType="currency";
	//for shipping integration saves response with success or why a shipping integration failed
	property name="lastStatusCode" ormtype="string";			// @hint this is the status code that was passed back in the response bean
	property name="lastMessage" ormtype="string" length="4000"; // @hint this is a pipe and tilda delimited list of any messages that came back in the response.
	
	// Calculated Properties
	property name="calculatedChargeTaxAmount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedShippingIntegrationName" ormtype="string";
	
	//hash of the integrationResponse used to decide if we need to rebuild the shippingMethodOptions
	property name="fulfillmentMethodOptionsCacheKey" column="fulfillMethOptionsCacheKey" ormtype="string" hb_auditable="false";
	
	// Related Object Properties (many-to-one)
	property name="accountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="accountAddressID";
	property name="accountEmailAddress" hb_populateEnabled="public" cfc="AccountEmailAddress" fieldtype="many-to-one" fkcolumn="accountEmailAddressID";
	property name="fulfillmentMethod" hb_populateEnabled="public" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="pickupLocation" hb_populateEnabled="public" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="shippingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="shippingMethod" hb_populateEnabled="public" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="orderFulfillmentStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderFulfillmentStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderFulfillmentStatusType";
	property name="orderFulfillmentInvStatType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderFulfillmentInvStatTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderFulfillmentInvStatType";
	property name="addressZone" hb_populateEnabled="public" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="addressZoneID";
	property name="shippingIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="integrationID";
	// Related Object Properties (one-to-many)
	property name="orderFulfillmentItems" hb_populateEnabled="public" singularname="orderFulfillmentItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";
	property name="appliedTaxes" singularname="appliedTax" cfc="TaxApplied" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" inverse="true" cascade="all-delete-orphan";
	property name="fulfillmentShippingMethodOptions" singularname="fulfillmentShippingMethodOption" cfc="ShippingMethodOption" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" cfc="AccountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";
	property name="fulfillmentBatchItems" singularname="fulfillmentBatchItem" fieldType="one-to-many" type="array" fkColumn="orderFulfillmentID" cfc="FulfillmentBatchItem" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	property name="accountAddressOptions" type="array" persistent="false";
	property name="saveAccountAddressFlag" hb_populateEnabled="public" persistent="false";
	property name="saveAccountAddressName" hb_populateEnabled="public" persistent="false";
	property name="requiredShippingInfoExistsFlag" persistent="false";
	property name="chargeAfterDiscount" type="numeric" persistent="false" hb_formatType="currency";
	property name="chargeTaxAmount" type="numeric" persistent="false" hb_formatType="currency";
	property name="chargeTaxLiabilityAmount" persistent="false" hb_formatType="currency";
	property name="discountAmount" type="numeric" persistent="false" hb_formatType="currency";
	property name="fulfillmentMethodType" type="numeric" persistent="false";
	property name="nextEstimatedDeliveryDateTime" type="timestamp" persistent="false";
	property name="nextEstimatedFulfillmentDateTime" type="timestamp" persistent="false";
	property name="statusCode" persistent="false";
	property name="orderStatusCode" type="numeric" persistent="false";
	property name="quantityUndelivered" type="numeric" persistent="false";
	property name="quantityDelivered" type="numeric" persistent="false";
	property name="selectedShippingMethodOption" type="any" persistent="false";
	property name="eligibleShippingMethodRates" type="any" persistent="false"; 
	property name="shippingMethodRate" type="array" persistent="false";
	property name="shippingMethodOptions" type="array" persistent="false";
	property name="subtotal" type="numeric" persistent="false" hb_formatType="currency";
	property name="subtotalAfterDiscounts" type="array" persistent="false" hb_formatType="currency";
	property name="subtotalAfterDiscountsWithTax" type="array" persistent="false" hb_formatType="currency";
	property name="taxAmount" type="numeric" persistent="false" hb_formatType="currency";
	property name="totalShippingWeight" type="numeric" persistent="false" hb_formatType="weight";
    property name="totalShippingQuantity" type="numeric" persistent="false" hb_formatType="weight";
    property name="shipmentItemMultiplier" type="numeric" persistent="false";
    property name="shippingIntegrationName" type="string" persistent="false";
    
	// Deprecated
	property name="discountTotal" persistent="false";
	property name="shippingCharge" persistent="false";
	property name="saveAccountAddress" persistent="false";


	// ==================== START: Logical Methods =========================

	public void function removeAccountAddress() {
		structDelete(variables, "accountAddress");
	}

	public void function removeShippingAddress() {
		structDelete(variables, "shippingAddress");
	}

	public void function removeShippingMethod() {
		structDelete(variables, "shippingMethod");
	}
	
	public void function removePickupLocation() {
		structDelete(variables, "pickupLocation");
	}
	public void function removeEmailAddress() {
		structDelete(variables, "emailAddress");
	}

	public boolean function hasValidShippingMethodRate() {
		return getService("shippingService").verifyOrderFulfillmentShippingMethodRate( this );
	}

	public boolean function allOrderFulfillmentItemsAreEligibleForFulfillmentMethod() {
		if(!isNull(getFulfillmentMethod())) {
			for(var orderItem in getOrderFulfillmentItems()) {
				if(!listFindNoCase(orderItem.getSku().setting('skuEligibleFulfillmentMethods'), getFulfillmentMethod().getFulfillmentMethodID()) ) {
					return false;
				}
			}
		}

		return true;
	}
	/**
	 * Returns Available if all orderFulfillmentItems have available inventory.
	 * Returns Partials if some of the items have inventory.
	 * Returns Unavailable if none of the items have inventory.
	 */
	public any function getOrderFulfillmentInvStatType() {
		if (!structKeyExists(variables, "orderFulfillmentInvStatType")){
			//Calculate the status type.
			variables.orderFulfillmentInvStatType = getService("typeService").getTypeBySystemCode('ofisAvailable');
			var canNotFulfillCount = 0;
			if(!isNull(getOrderFulfillmentItems())) {
				for(var orderItem in getOrderFulfillmentItems()) {
					if(!orderItem.hasQuantityWithinMaxOrderQuantity()) {
						variables.orderFulfillmentInvStatType = getService("typeService").getTypeBySystemCode('ofisPartial');
						canNotFulfillCount++;
					}
				}
			}
			if (canNotFulfillCount == arrayLen(getOrderFulfillmentItems())){
				variables.orderFulfillmentInvStatType = getService("typeService").getTypeBySystemCode('ofisUnavailable');
			}
		}
		return variables.orderFulfillmentInvStatType;
	}

    public void function checkNewAccountAddressSave() {

		// If this isn't a guest, there isn't an accountAddress, save is on - copy over an account address
    	if(!isNull(getOrder().getAccount()) && !getOrder().getAccount().getGuestAccountFlag() && isNull(getAccountAddress()) && !isNull(getShippingAddress()) && !getShippingAddress().hasErrors() && getSaveAccountAddressFlag()) {

    		// Create a New Account Address, Copy over Shipping Address, and save
    		var accountAddress = getService('accountService').newAccountAddress();
			accountAddress.setAccountAddressName( getSaveAccountAddressName() );
			accountAddress.setAddress( getShippingAddress().copyAddress( true ) );
			accountAddress.setAccount( getOrder().getAccount() );
			accountAddress = getService('accountService').saveAccountAddress( accountAddress );

			// Set the accountAddress
			setAccountAddress( accountAddress );
		}

	}

	// Gift Card Helper Methods

	// @hint Determines whether orderFulfillment has any undelivered order items that require a manual gift card code to be provided.
	public boolean function hasUndeliveredOrderItemsWithoutProvidedGiftCardCode(){
		return arrayLen(this.getUndeliveredOrderItemsWithoutProvidedGiftCardCode()) > 0;
	}

	// @hint this method validates that this order fulfilmment has no order items where any remaining gift card recipient assignments are still required
	public boolean function hasGiftCardOrderItemsWithAllRecipientsAssigned(){
		for(var item in this.getOrderFulfillmentItems()){
			if (item.isGiftCardOrderItem()) {
				if(item.getSku().getGiftCardRecipientRequiredFlag() && !item.hasAllGiftCardsAssigned()){
					return false;
				}
			}
		}
		return true;
	}

	// @hint method validates that this orderFulfillment does not need the email address because gift card recipients exist instead
	public boolean function needsEmailForFulfillment(){
		return !hasGiftCardOrderItemsWithAllRecipientsAssigned();
	}

	public any function getNumberOfNeededGiftCardCodes(){
		var numberOfCodesNeeded = 0;
		for (var orderItem in this.getOrderFulfillmentItems()) {
			if (orderItem.isGiftCardOrderItem() && !orderItem.getSku().getGiftCardAutoGenerateCodeFlag()) {
				numberOfCodesNeeded += orderItem.getQuantityUndelivered();
			}
		}

		return numberOfCodesNeeded;
	}

	public array function getUndeliveredOrderItemsWithoutProvidedGiftCardCode() {
		if (structKeyExists(variables, "undeliveredOrderItemsWithoutProvidedGiftCardCode")) {
			return variables.undeliveredOrderItemsWithoutProvidedGiftCardCode;
		}

		var orderItemsMissingGiftCardCode = [];
		for (var orderItem in this.getOrderFulfillmentItems()) {
			if ( orderItem.isGiftCardOrderItem() 
				 && (!orderItem.getSku().getGiftCardAutoGenerateCodeFlag())
				 && (orderItem.getQuantityUndelivered() > 0)
			) {
				arrayAppend(orderItemsMissingGiftCardCode, orderItem);
			}
		}
		undeliveredOrderItemsWithoutProvidedGiftCardCode = orderItemsMissingGiftCardCode;

		return variables.undeliveredOrderItemsWithoutProvidedGiftCardCode;
	}

	public array function getGiftCardListLabels(){
		var labels = [];
		if(!getService("SettingService").getSettingValue("skuGiftCardAutoGenerateCode")){
			for(var item in this.getOrderFulfillmentItems()){
				if(item.isGiftCardOrderItem()){
					for(var i=0; i < item.getQuantityUndelivered(); i++){
						ArrayAppend(labels, item.getSku().getSkuCode());
					}
				}
			}
		}
		return labels;
	}

	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================

	public any function getShipmentItemMultiplier(){

		//weight overrides quantity
		if(getTotalShippingWeight() > 0){
			return ceiling(getTotalShippingWeight()); //round up.
		}
		else if (getTotalShippingQuantity() > 0){
			return getTotalShippingQuantity();
		}

		return 0;
	}
	
	public any function getShippingIntegrationOptions(){
		var options = [{name=rbKey("entity.Product.option.select"), value=""}];
		var integrationCollectionList = getService('IntegrationService').getIntegrationCollectionList();
		var shippingMethodRate = getShippingMethodRate();
		if(!isNull(shippingMethodRate)){
			//let's test if this has a set integration or if it's a manual rate with multiple choices
			
			var integration = shippingMethodRate.getShippingIntegration();
			if(!isNull(integration)){
				return [{value=integration.getIntegrationID(),name=integration.getIntegrationName()}];
			}
			
			var shippingMethodRateIntegrationMethods = shippingMethodRate.getManualRateIntegrationMethods();
			var integrationIDsList = '';
			for(var shipMethodrateIntegrationMethod in shippingMethodRateIntegrationMethods){
				integrationIDsList = listAppend(integrationIDsList,shipMethodrateIntegrationMethod.getShippingIntegration().getIntegrationID());
			}
			integrationCollectionList.addFilter('integrationID',integrationIDsList,'IN');
			var integrations = integrationCollectionList.getRecords();
			for(var integration in integrations){
				arrayAppend(options,{value=integration['integrationID'],name=integration['integrationName']});
			}	
		}
		return options;
	}

    public any function getAccountAddressOptions() {
    	if( !structKeyExists(variables, "accountAddressOptions")) {
    		variables.accountAddressOptions = [];
			if(!isNull(getOrder().getAccount())){
				var s = getService("accountService").getAccountAddressSmartList();
				s.addFilter(propertyIdentifier="account.accountID",value=getOrder().getAccount().getAccountID(),fetch="false");
				s.addOrder("accountAddressName|ASC");
				var r = s.getRecords();
				for(var i=1; i<=arrayLen(r); i++) {
					arrayAppend(variables.accountAddressOptions, {name=r[i].getSimpleRepresentation(), value=r[i].getAccountAddressID()});
				}
			}
			arrayPrepend(variables.accountAddressOptions, {name=rbKey("define.new"), value=""});
		}
		return variables.accountAddressOptions;
	}

	public numeric function getChargeAfterDiscount() {
		return getService('HibachiUtilityService').precisionCalculate(getFulfillmentCharge() + getChargeTaxAmount() - getDiscountAmount());
	}

	public numeric function getDiscountAmount() {
		var discountAmount = 0;
		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getDiscountAmount());
		}
		return discountAmount;
	}

	public any function getFulfillmentMethodType() {
		return getFulfillmentMethod().getFulfillmentMethodType();
	}

    public numeric function getFulfillmentTotal() {
    	return getService('HibachiUtilityService').precisionCalculate(getSubtotalAfterDiscountsWithTax() + getChargeAfterDiscount());
    }

   	public numeric function getItemDiscountAmountTotal() {
   		if(!structKeyExists(variables, "itemDiscountAmountTotal")) {
   			variables.itemDiscountAmountTotal = 0;
   			for(var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++) {
				variables.itemDiscountAmountTotal = getService('HibachiUtilityService').precisionCalculate(variables.itemDiscountAmountTotal + getOrderFulfillmentItems()[i].getDiscountAmount());
			}
   		}
		return variables.itemDiscountAmountTotal;
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
			for(var orderItem in getOrderFulfillmentItems()){
				//Condtional to check for the nextEstimatedFulfillmentDateTime, also checks to make sure that the nextFulfillmentyDateTime is not the current estimatedFullfillmentDateTime
				if( ( nextEstimatedFulfillmentDateTime == "" || nextEstimatedFulfillmentDateTime > orderItem.getEstimatedFulfillmentDateTime() ) && orderItem.getQuantityUndelivered() > 0 ){
					nextEstimatedFulfillmentDateTime = orderItem.getEstimatedFulfillmentDateTime();
				}
			}
		}

		if ( !isDefined('nextEstimatedFulfillmentDateTime') || nextEstimatedFulfillmentDateTime == ''){
			return javaCast('Null',"");
		}

		return nextEstimatedFulfillmentDateTime;
    }

    //Function that loops over the orderItems and returns the earliest estimatedDeliveryDate
    public any function getNextEstimatedDeliveryDateTime(){
    	var nextEstimatedDeliveryDateTime = "";

    	if(arrayLen(getOrderItems())) {
    		//Loop over orderFulfillments to get the nextEstimatedDeliveryDateTime
			for(var orderItem in getOrderFulfillmentItems()){
				//Condtional to check for the nextEstimatedDeliveryDateTime, also checks to make sure that the nextEstimatedDeliveryDateTime is not the current estimatedDeliveryDateTime
				if( ( nextEstimatedDeliveryDateTime == "" || nextEstimatedDeliveryDateTime > orderItem.getEstimatedDeliveryDateTime() ) && orderItem.getQuantityUndelivered() > 0){
					nextEstimatedDeliveryDateTime = orderItem.getEstimatedDeliveryDateTime();
				}
			}
		}

		if ( !isdefined('nextEstimatedDeliveryDateTime') || nextEstimatedDeliveryDateTime == ''){
			return javaCast('Null',"");
		}

		return nextEstimatedDeliveryDateTime;
    }

	public any function getOrderStatusCode() {
		return getOrder().getStatusCode();
	}

	public any function getStatusCode() {
		return getOrderFulfillmentStatusType().getSystemCode();
	}
	
	public numeric function getQuantityUndelivered() {
    	var quantityUndelivered = 0;

		for(var i=1; i<=arrayLen(getOrderFulfillmentItems());i++) {
			quantityUndelivered += getOrderFulfillmentItems()[i].getQuantityUndelivered();
		}

    	return quantityUndelivered;
    }

    public numeric function getQuantityDelivered() {
    	var quantityDelivered = 0;

		for(var i=1; i<=arrayLen(getOrderFulfillmentItems());i++) {
			quantityDelivered += getOrderFulfillmentItems()[i].getQuantityDelivered();
		}

    	return quantityDelivered;
    }

    public boolean function getRequiredShippingInfoExistsFlag() {
    	return !getService('hibachiValidationService').validate(object=getShippingAddress(), context="full", setErrors=false).hasErrors();
    }

    public any function getShippingMethodOptions() {
    	if( !structKeyExists(variables, "shippingMethodOptions")) {
    		variables.shippingMethodOptions = getService("OrderService").getShippingMethodOptions(this);
    	}
    	return variables.shippingMethodOptions;
    }

	public any function getShippingMethodRate() {
    	if(!isNull(getSelectedShippingMethodOption())) {
    		return getSelectedShippingMethodOption().getShippingMethodRate();
    	}
    }

	public string function getShippingIntegrationName() { 
		if(!isNull(getShippingIntegration())){
			return getShippingIntegration().getIntegrationName(); 
		}
		return ''; 
	} 

	public any function getShippingIntegration() { 
		if(structKeyExists(variables,'shippingIntegration')){
			return variables.shippingIntegration;
		}
		if(!isNull(getShippingMethodRate()) && !isNull(getShippingMethodRate().getShippingIntegration())){
				variables.shippingIntegration = getShippingMethodRate().getShippingIntegration();
				return variables.shippingIntegration;
		}
	}	

    public any function getSelectedShippingMethodOption() {
    	if(!structKeyExists(variables, "selectedShippingMethodOption")) {
    		if(!isNull(getShippingMethod())) {
	    		for(var i=1; i<=arrayLen(getFulfillmentShippingMethodOptions()); i++) {
	    			if(getShippingMethod().getShippingMethodID() == getFulfillmentShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()) {
	    				variables.selectedShippingMethodOption = getFulfillmentShippingMethodOptions()[i];
	    				break;
	    			}
	    		}
	    	}
    	}
    	if(structKeyExists(variables, "selectedShippingMethodOption")) {
    		return variables.selectedShippingMethodOption;
    	}
    }

    public boolean function getSaveAccountAddressFlag() {
    	if(!structKeyExists(variables, "saveAccountAddressFlag")) {
    		variables.saveAccountAddressFlag = 0;
    		if(!isNull(getSaveAccountAddress())) {
    			variables.saveAccountAddressFlag = getSaveAccountAddress();
    		}
    	}
    	return variables.saveAccountAddressFlag;
    }

	public numeric function getSubtotal() {
  		if( !structKeyExists(variables,"subtotal") ) {
	    	variables.subtotal = 0;
	    	for( var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++ ) {
				if(getOrderFulfillmentItems()[i].isRootOrderItem()){
				    variables.subtotal = getService('HibachiUtilityService').precisionCalculate(variables.subtotal + getOrderFulfillmentItems()[i].getExtendedPrice());	    	
	    		}
	    	}
  		}
    	return variables.subtotal;
    }

    public numeric function getSubtotalAfterDiscounts() {
    	return getService('HibachiUtilityService').precisionCalculate(getSubtotal() - getItemDiscountAmountTotal());
    }

    public numeric function getSubtotalAfterDiscountsWithTax() {
    	return getService('HibachiUtilityService').precisionCalculate(getSubtotal() - getItemDiscountAmountTotal() + getTaxAmount());
    }

    public numeric function getTaxAmount() {
    	if( !structkeyExists(variables, "taxAmount") ) {
    		variables.taxAmount = 0;
	    	for( var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++ ) {
	    		variables.taxAmount = getService('HibachiUtilityService').precisionCalculate(variables.taxAmount + getOrderFulfillmentItems()[i].getTaxAmount());
	    	}
    	}
    	return variables.taxAmount;
    }

	public numeric function getChargeTaxAmount() {
		var taxAmount = 0;

		for(var taxApplied in getAppliedTaxes()) {
			taxAmount = getService('HibachiUtilityService').precisionCalculate(taxAmount + taxApplied.getTaxAmount());
		}

		return taxAmount;
	}

	public numeric function getChargeTaxLiabilityAmount() {
		var taxLiabilityAmount = 0;

		for(var taxApplied in getAppliedTaxes()) {
			taxLiabilityAmount = getService('HibachiUtilityService').precisionCalculate(taxLiabilityAmount + taxApplied.getTaxLiabilityAmount());
		}

		return taxLiabilityAmount;
	}

	public numeric function getTotalShippingWeight() {
    	var totalShippingWeight = 0;

    	for( var orderItem in getOrderFulfillmentItems()) {
    		//Only calculate the weight for top level items so that product bundles don't cause weight doubling.
    		if (isNull(orderItem.getParentOrderItem())){	
    			var convertedWeight = getService("measurementService").convertWeightToGlobalWeightUnit(orderItem.getSku().setting('skuShippingWeight'), orderItem.getSku().setting('skuShippingWeightUnitCode'));
    			totalShippingWeight = getService('HibachiUtilityService').precisionCalculate(totalShippingWeight + (convertedWeight * orderItem.getQuantity()));
    		}
    	}

    	return totalShippingWeight;
    }

    public boolean function hasOrderWithMinAmountRecievedRequiredForFulfillment() {
    	return  (   !isNull(this.getOrder())
    				&& (
    				  	this.getOrder().getTotal() == 0
    				  		|| (
		    				  	!isNull(this.getFulfillmentMethod())
		    				  	&& this.getFulfillmentMethod().setting('fulfillmentMethodAutoMinReceivedPercentage')
		    						<= getService('HibachiUtilityService').precisionCalculate( this.getOrder().getPaymentAmountReceivedTotal() * 100 / this.getOrder().getTotal() )
		    				)
    				  )
    			);
    }

     public boolean function isAutoFulfillment() {
		return (this.getFulfillmentMethodType() == "auto" || (
		        !isNull(this.getFulfillmentMethod()) &&
                !isNull(this.getFulfillmentMethod().getAutoFulfillFlag()) &&
                		this.getFulfillmentMethod().getAutoFulfillFlag()));
    }

    public boolean function isAutoFulfillmentReadyToBeFulfilled(){
		return this.isAutoFulfillment() && this.hasOrderWithMinAmountRecievedRequiredForFulfillment() && this.hasGiftCardOrderItemsWithAllRecipientsAssigned();
    }

    public numeric function getTotalShippingQuantity() {
        var totalShippingQuantity = 0;

        for( var orderItem in getOrderFulfillmentItems()) {
            totalShippingQuantity = totalShippingQuantity + orderItem.getQuantity();
        }

        return totalShippingQuantity;
    }

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderFulfillment( this )) {
			arrayAppend(arguments.order.getOrderFulfillments(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderFulfillments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderFulfillments(), index);
		}
		structDelete(variables, "order");
	}

	// Fulfillment Shipping Method Options (one-to-many)
	public void function addFulfillmentShippingMethodOption(required any fulfillmentShippingMethodOption) {
		arguments.fulfillmentShippingMethodOption.setOrderFulfillment( this );
	}
	public void function removeFulfillmentShippingMethodOption(required any fulfillmentShippingMethodOption) {
		arguments.fulfillmentShippingMethodOption.removeOrderFulfillment( this );
	}

	// Applied Promotions (one-to-many)
	public void function addAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.setOrderFulfillment( this );
	}
	public void function removeAppliedPromotion(required any appliedPromotion) {
		arguments.appliedPromotion.removeOrderFulfillment( this );
	}

	// Applied Taxes (one-to-many)
	public void function addAppliedTax(required any appliedTax) {
		arguments.appliedTax.setOrderFulfillment( this );
	}
	public void function removeAppliedTax(required any appliedTax) {
		arguments.appliedTax.removeOrderFulfillment( this );
	}

 	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setOrderFulfillment( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeOrderFulfillment( this );
	}
	
	// Fulfillment Batch Items (one-to-many)
	public void function addFulfillmentBatchItem(required any fulfillmentBatchItem) {
		arguments.fulfillmentBatchItem.setOrderFulfillment( this );
	}
	public void function removeFulfillmentBatchItem(required any fulfillmentBatchItem) {
		arguments.fulfillmentBatchItem.removeOrderFulfillment( this );
	}
	

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================

	public numeric function getFulfillmentCharge() {
		
		if(!structKeyExists(variables, "fulfillmentCharge")) {
			variables.fulfillmentCharge = 0;
		}
		return variables.fulfillmentCharge;
	}

	public boolean function getManualfulfillmentChargeFlag() {
		if(!structKeyExists(variables, "manualFulfillmentChargeFlag")) {
			variables.manualFulfillmentChargeFlag = 0;
		}
		return variables.manualFulfillmentChargeFlag;
	}

	public any function getShippingAddress() {
		// Check Here
		if(structKeyExists(variables, "shippingAddress")) {
			return variables.shippingAddress;

		// Check Account Address
		} else if(!isNull(getAccountAddress())) {

			// Get the account address, copy it, and save as the shipping address
			setShippingAddress( getAccountAddress().getAddress().copyAddress( true ) );
			return variables.shippingAddress;

		// Check Order
		} else if (!isNull(getOrder())) {
			return getOrder().getShippingAddress();
		}

		// Return New
		return getService("addressService").newAddress();
	}

	// sets it up so that the charge for the shipping method is pulled out of the shippingMethodOptions
	public void function setShippingMethod( any shippingMethod ) {
		if(structKeyExists(arguments, "shippingMethod")) {
			if(!arrayLen(getFulfillmentShippingMethodOptions())){
				getService("shippingService").updateOrderFulfillmentShippingMethodOptions( this );
			}
			// make sure that the shippingMethod exists in the fulfillmentShippingMethodOptions
			for(var i=1; i<=arrayLen(getFulfillmentShippingMethodOptions()); i++) {
				if(arguments.shippingMethod.getShippingMethodID() == getFulfillmentShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID()) {

					// Set the method
					variables.shippingMethod = arguments.shippingMethod;

					// Set the charge
					if(!getManualfulfillmentChargeFlag() && (isNull(getThirdPartyShippingAccountIdentifier()) || !len(getThirdPartyShippingAccountIdentifier()))) {
						setFulfillmentCharge( getFulfillmentShippingMethodOptions()[i].getTotalCharge() );
					}else if(len(getThirdPartyShippingAccountIdentifier())){
						setFulfillmentCharge(0);
					}
				}
			}
		} else {
			structDelete(variables, "shippingMethod");
		}
	}

	public string function getSimpleRepresentation() {
		var rep = "";
		if(!isNull(getOrder()) && getOrder().getOrderStatusType().getSystemCode() != "ostNotPlaced") {
			rep &= "#getOrder().getOrderNumber()# - ";
		}
		if(!isNull(getFulfillmentMethod())) {
			rep &= "#rbKey('enity.orderFulfillment.orderFulfillmentType.#getFulfillmentMethodType()#')#";
			if(getFulfillmentMethodType() eq "shipping" && !isNull(getShippingAddress().getStreetAddress())) {
				rep &= " - #getAddress().getStreetAddress()#";
			}
			if(getFulfillmentMethodType() eq "email" && !isNull(getEmailAddress())) {
				rep &= " - #getEmailAddress()#";
			}
			if(getFulfillmentMethodType() eq "email" && !isNull(getAccountEmailAddress())) {
				rep &= " - #getAccountEmailAddress().getEmailAddress()#";
			}
		}
		return rep;
	}

	public any function setAccountAddress( any accountAddress ) {
		if(isNull(arguments.accountAddress)) {
			structDelete(variables, "accountAddress");
		} else {

			// If the shippingAddress is a new shippingAddress
			if(getShippingAddress().getNewFlag()) {
				setShippingAddress( arguments.accountAddress.getAddress().copyAddress( true ) );

			// Else if there was no accountAddress before, or the accountAddress has changed
			} else if (
				!structKeyExists(variables, "accountAddress") 
				|| (
					structKeyExists(variables, "accountAddress") 
					&& variables.accountAddress.getAccountAddressID() != arguments.accountAddress.getAccountAddressID()) 
			) {
				getShippingAddress().populateFromAddressValueCopy( arguments.accountAddress.getAddress() );

			}

			// Set the actual accountAddress
			variables.accountAddress = arguments.accountAddress;
		}
	}

	public any function populate( required struct data={} ) {
		// Before we populate we need to cleanse the shippingAddress data if the shippingAccountAddress is being changed in any way
		if(structKeyExists(arguments.data, "accountAddress")
			&& structKeyExists(arguments.data.accountAddress, "accountAddressID")
			&& len(arguments.data.accountAddress.accountAddressID)
			&& ( !structKeyExists(arguments.data, "shippingAddress") || !structKeyExists(arguments.data.shippingAddress, "addressID") || !len(arguments.data.shippingAddress.addressID) ) ) {

			structDelete(arguments.data, "shippingAddress");
		}

		super.populate(argumentCollection=arguments);
	}

	 public any function getEstimatedFulfillmentDateTime(){
    	if(structKeyExists(variables, "estimatedFulfillmentDateTime")) {
			return variables.estimatedFulfillmentDateTime;
		}else if (!isNull(getOrder())){
			return getOrder().getEstimatedFulfillmentDateTime();
		}
    }

    public any function getEstimatedDeliveryDateTime(){
    	if(structKeyExists(variables, "estimatedDeliveryDateTime")) {
			return variables.estimatedDeliveryDateTime;
		}else if (!isNull(getOrder())){
			return getOrder().getEstimatedDeliveryDateTime();
		}
    }

   	public any function getOrderFulfillmentStatusType() {
		if(!structKeyExists(variables, "orderFulfillmentStatusType")) {
			variables.orderFulfillmentStatusType = getService("typeService").getTypeBySystemCode('ofstUnfulfilled');
		}
		return variables.orderFulfillmentStatusType;
	}


	// ==================  END:  Overridden Methods ========================

    // ==================  START: Validation Methods  ======================
    public boolean function hasQuantityOfOrderFulfillmentsWithinMaxOrderQuantity() {
        var settingVal = getService("settingService").getSettingValue(settingName='globalMaximumFulfillmentsPerOrder');
        if (!isNull(settingVal)
        	&& !isNull(getOrder())
        ){
           return (arrayLen(getOrder().getOrderFulfillments()) <= settingVal);
        }
        return false;
    }
    // ==================  END: Validation Methods  ========================

	// =================== START: ORM Event Hooks  =========================

	public void function preUpdate(Struct oldData){
		//Check to make sure that the previous order is not null and that the new order is different from the old order
		if (
			structKeyExists(arguments.oldData, "order")
			&& !isNull(arguments.oldData.order.getOrderID())
			&& (
				isNull( this.getOrder() )
				|| (!isNull(this.getOrder()) &&  this.getOrder().getOrderID() != arguments.oldData.order.getOrderID() )
			)
		){
			//Reset the order to the old Data
			this.setOrder(arguments.oldData.order);

			//Log that this occurred in the Slatwall Log
			logHibachi("Order Fulfillment: #this.getOrderFulfillmentID()# tried to update it's order. This change has been prevented", true);
		}

		super.preUpdate(argumentCollection=arguments);
	}

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// Now just delegates to getShippingAddress
    public any function getAddress(){
    	return getShippingAddress();
    }

	public numeric function getDiscountTotal() {
		return getService('HibachiUtilityService').precisionCalculate(getDiscountAmount() + getItemDiscountAmountTotal());
	}

	public numeric function getShippingCharge() {
		return getFulfillmentCharge();
	}

	// ==================  END:  Deprecated Methods ========================
}
