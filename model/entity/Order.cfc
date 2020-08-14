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
component displayname="Order" entityname="SlatwallOrder" table="SwOrder" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this" hb_processContexts="addOrderItem,addOrderPayment,addPromotionCode,cancelOrder,changeCurrencyCode,clear,create,createReturn,duplicateOrder,placeOrder,placeOnHold,removeOrderItem,removeOrderPayment,removePersonalInfo,removePromotionCode,takeOffHold,updateStatus,updateOrderAmounts,updateOrderFulfillment,retryPayment,releaseCredits" {

	// Persistent Properties
	property name="orderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderNumber" ormtype="string"  index="PI_ORDERNUMBER";
	property name="currencyCode" ormtype="string" length="3";
	property name="orderOpenDateTime" ormtype="timestamp" hb_displayType="datetime";
	property name="orderOpenIPAddress" ormtype="string";
	property name="orderCloseDateTime" ormtype="timestamp";
	property name="referencedOrderType" ormtype="string" hb_formatType="rbKey";
	property name="estimatedDeliveryDateTime" ormtype="timestamp";
	property name="estimatedFulfillmentDateTime" ormtype="timestamp";
	property name="quotePriceExpiration" ormtype="timestamp";
	property name="quoteFlag" ormtype="boolean" default="0";
	property name="testOrderFlag" ormtype="boolean";
	property name="paymentLastRetryDateTime" ormtype="timestamp";
	property name="paymentProcessingInProgressFlag" ormtype="boolean" default="false";
	property name="paymentTryCount" ormtype="integer" default="0";
	property name="orderCanceledDateTime" ormtype="timestamp";
	property name="orderNotes" ormtype="text";
	property name="addToEntityQueueFlag" ormtype="boolean";
	property name="taxCommitDateTime" ormtype="timestamp";
	
	//used to check whether tax calculations should be run again
	property name="taxRateCacheKey" ormtype="string" hb_auditable="false";
	property name="promotionCacheKey" ormtype="string" hb_auditable="false";
	property name="priceGroupCacheKey" ormtype="string" hb_auditable="false";

	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="assignedAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="assignedAccountID";
	property name="billingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="billingAccountAddressID";
	property name="billingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID";
	property name="defaultStockLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID" hb_formFieldType="typeahead";
	property name="orderTemplate" cfc="OrderTemplate" fieldtype="many-to-one" fkcolumn="orderTemplateID";
	property name="orderType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderType";
	property name="orderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderStatusType";
	property name="orderOrigin" cfc="OrderOrigin" fieldtype="many-to-one" fkcolumn="orderOriginID" hb_optionsNullRBKey="define.none";
	property name="referencedOrder" cfc="Order" fieldtype="many-to-one" fkcolumn="referencedOrderID";	// Points at the "parent" (NOT return) order.
	property name="returnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="returnReasonTypeID";
	property name="shippingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="shippingAccountAddressID";
	property name="shippingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderCreatedSite" hb_populateEnabled="public" cfc="Site" fieldtype="many-to-one" fkcolumn="orderCreatedSiteID";
	property name="orderPlacedSite" hb_populateEnabled="public" cfc="Site" fieldtype="many-to-one" fkcolumn="orderPlacedSiteID";
	property name="orderImportBatch" cfc="OrderImportBatch" fieldtype="many-to-one" fkColumn="orderImportBatchID";

	// Related Object Properties (one-To-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderItems" hb_populateEnabled="public" singularname="orderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="appliedPromotionMessages" singularname="appliedPromotionMessage" cfc="PromotionMessageApplied" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderDeliveries" singularname="orderDelivery" cfc="OrderDelivery" fieldtype="one-to-many" fkcolumn="orderID" cascade="delete-orphan" inverse="true";
	property name="orderFulfillments" hb_populateEnabled="public" singularname="orderFulfillment" cfc="OrderFulfillment" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderPayments" hb_populateEnabled="public" singularname="orderPayment" cfc="OrderPayment" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="orderReturns" hb_populateEnabled="public" singularname="orderReturn" cfc="OrderReturn" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="stockReceivers" singularname="stockReceiver" cfc="StockReceiver" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	property name="referencingOrders" singularname="referencingOrder" cfc="Order" fieldtype="one-to-many" fkcolumn="referencedOrderID" cascade="all-delete-orphan" inverse="true";
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" cfc="AccountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all" inverse="true";
	property name="orderStatusHistory" singularname="orderStatusHistory"  cfc="OrderStatusHistory" type="array" fieldtype="one-to-many" fkcolumn="orderID" cascade="all-delete-orphan" inverse="true";
	
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
	property name="eligibleSavedAccountPaymentMethods" persistent="false";
	property name="itemDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentDiscountAmountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeTotalBeforeHandlingFees" persistent="false" hb_formatType="currency";
	property name="fulfillmentRefundTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentHandlingFeeTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeAfterDiscountTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentChargeNotRefunded" persistent="false" hb_formatType="currency";
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
	property name="qualifiedPromotionRewards" persistent="false";
	property name="qualifiedRewardSkus" persistent="false";
	property name="qualifiedRewardSkuIDs" persistent="false";
	property name="quantityDelivered" persistent="false";
	property name="quantityUndelivered" persistent="false";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	property name="returnItemSmartList" persistent="false";
	property name="referencingPaymentAmountCreditedTotal" persistent="false" hb_formatType="currency";
	property name="refundableAmount" persistent="false" hb_formatType="currency";
	property name="totalAmountCreditedIncludingReferencingPayments" persistent="false" hb_formatType="currency";
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
	property name="VATTotal" persistent="false" hb_formatType="currency";
	property name="taxTotalNotRefunded" persistent="false";
	property name="total" persistent="false" hb_formatType="currency";
	property name="totalItems" persistent="false";
	property name="totalItemQuantity" persistent="false"; 
	property name="totalQuantity" persistent="false";
	property name="totalSaleQuantity" persistent="false";
	property name="totalReturnQuantity" persistent="false";
	property name="totalDepositAmount" persistent="false" hb_formatType="currency";
	property name="refundableAmountMinusRemainingTaxesAndFulfillmentCharge" persistent="false";
	property name="placeOrderFlag" persistent="false" default="false";
	property name="refreshCalculateFulfillmentChargeFlag" persistent="false" default="false"; //Flag for Fulfillment Tax Recalculation 
	property name="orderStatusHistoryTypeCodeList" persistent="false" default="";
	
    //======= Mocking Injection for Unit Test ======	
	property name="orderService" persistent="false" type="any";
	property name="hibachiService" persistent="false" type="any";
	property name='orderDAO' persistent="false" type="any";
	
	property name="calculatedTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedSubTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedFulfillmentTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedDiscountTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedSubTotalAfterItemDiscounts" column="calcSubTotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTaxTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedVATTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTotalItems" ormtype="integer";
	property name="calculatedTotalQuantity" ormtype="integer";
	property name="calculatedTotalSaleQuantity" ormtype="integer";
	property name="calculatedTotalReturnQuantity" ormtype="integer";
	property name="calculatedTotalDepositAmount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTotalItemQuantity" ormtype="integer"; 
	property name="calculatedFulfillmentHandlingFeeTotal" ormtype="big_decimal" hb_formatType="currency";

	//CUSTOM PROPERTIES BEGIN
property name="commissionPeriodStartDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="commissionPeriodEndDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="secondaryReturnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="secondaryReturnReasonTypeID"; // Intended to be used by Ops accounts
     property name="monatOrderType" cfc="Type" fieldtype="many-to-one" fkcolumn="monatOrderTypeID" hb_optionsSmartListData="f:parentType.typeID=2c9280846deeca0b016deef94a090038";
    property name="dropSkuRemovedFlag" ormtype="boolean" default=0;

    property name="personalVolumeSubtotal" persistent="false";
    property name="taxableAmountSubtotal" persistent="false";
    property name="commissionableVolumeSubtotal" persistent="false";
    property name="retailCommissionSubtotal" persistent="false";
    property name="productPackVolumeSubtotal" persistent="false";
    property name="retailValueVolumeSubtotal" persistent="false";
    property name="personalVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="taxableAmountSubtotalAfterItemDiscounts" persistent="false";
    property name="commissionableVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="retailCommissionSubtotalAfterItemDiscounts" persistent="false";
    property name="productPackVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="retailValueVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="personalVolumeDiscountTotal" persistent="false";
    property name="taxableAmountDiscountTotal" persistent="false";
    property name="commissionableVolumeDiscountTotal" persistent="false";
    property name="retailCommissionDiscountTotal" persistent="false";
    property name="productPackVolumeDiscountTotal" persistent="false";
    property name="retailValueVolumeDiscountTotal" persistent="false";
    property name="personalVolumeTotal" persistent="false";
    property name="taxableAmountTotal" persistent="false";
    property name="commissionableVolumeTotal" persistent="false";
    property name="retailCommissionTotal" persistent="false";
    property name="productPackVolumeTotal" persistent="false";
    property name="retailValueVolumeTotal" persistent="false";
    property name="vipEnrollmentOrderFlag" persistent="false";
    property name="marketPartnerEnrollmentOrderID" persistent="false";
    
    property name="calculatedVipEnrollmentOrderFlag" ormtype="boolean";
    property name="calculatedPersonalVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedPersonalVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedPersonalVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedPersonalVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
	property name="calculatedPurchasePlusTotal" ormtype="big_decimal" hb_formatType="none";

    property name="accountType" ormtype="string";
    property name="accountPriceGroup" ormtype="string";
	
    property name="shipMethodCode" ormtype="string";
    property name="iceRecordNumber" ormtype="string";
    property name="commissionPeriodCode" ormtype="string";
    property name="lastSyncedDateTime" ormtype="timestamp";
    property name="calculatedPaymentAmountDue" ormtype="big_decimal";
    property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
    property name="upgradeFlag" ormtype="boolean" default="0";

    property name="isLockedInProcessingFlag" persistent="false";
    property name="isLockedInProcessingOneFlag" persistent="false";
    property name="isLockedInProcessingTwoFlag" persistent="false";
	property name="purchasePlusTotal" persistent="false";
	property name="upgradeOrEnrollmentOrderFlag" persistent="false";
	
	
   
 property name="businessDate" ormtype="string";
 property name="commissionPeriod" ormtype="string";
 property name="importFlexshipNumber" ormtype="string";
 property name="initialOrderFlag" ormtype="boolean";
 property name="orderSource" ormtype="string" hb_formFieldType="select";
 property name="commissionPeriodCode" ormtype="string" hb_formFieldType="select";
 property name="undeliverableOrderReasons" ormtype="string" hb_formFieldType="select";
 property name="orderAccountNumber" ormtype="string";
 property name="orderCountryCode" ormtype="string";
 property name="orderPartnerNumber" ormtype="string";
 property name="invoiceNumber" ormtype="string";
 property name="miscChargeAmount" ormtype="string";
 property name="redeemPoints" ormtype="string";
 property name="remoteAmountTotal" ormtype="string";
 property name="orderSourceCode" ormtype="string";
 property name="FSNumber" ormtype="string";
 property name="importOriginalRMANumber" ormtype="string";
 property name="monatOrderType" cfc="Type" fieldtype="many-to-one" fkcolumn="monatOrderTypeID" hb_optionsSmartListData="f:parentType.typeID=2c9280846deeca0b016deef94a090038";
 property name="priceLevelCode" ormtype="string";
 property name="orderTypeCode" ormtype="string";
 property name="orderStatusCode" ormtype="string";//CUSTOM PROPERTIES END
	public void function init(){
		setOrderService(getService('orderService'));
		setOrderDao(getDAO('OrderDAO'));
		super.init();
	}
	
	public void function setOrderService(required any orderService){
		variables.orderService = arguments.orderService;
	}
	
	public void function setOrderDAO(required any orderDAO) {
		//TODO: check if necessary using setORderDAO()
		variables.orderDAO = arguments.orderDAO;
	}


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
	
	public boolean function isNotClosed(){
		return getOrderStatusType().getSystemCode() != "ostClosed";
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
				if(getDao('hibachiDao').getApplicationValue('databaseType') == "MySQL"){
					if(!isNull(this.getOrderID())){
						var maxOrderNumberQuery = new query();
						var maxOrderNumberSQL = 'insert into swordernumber (orderID,createdDateTime) VALUES (:orderID,:createdDateTime)';
						
						maxOrderNumberQuery.setSQL(maxOrderNumberSQL);
						maxOrderNumberQuery.addParam(name="orderID",value=this.getOrderID());
						maxOrderNumberQuery.addParam(name="createdDateTime",value=now(),cfsqltype="cf_sql_timestamp" );
						var insertedID = maxOrderNumberQuery.execute().getPrefix().generatedKey;
						
						setOrderNumber(insertedID);	
					}
				}else{
					var maxOrderNumber = getOrderService().getMaxOrderNumber();
					if( arrayIsDefined(maxOrderNumber,1) ){
						setOrderNumber(maxOrderNumber[1] + 1);
					} else {
						setOrderNumber(1);
					}					
				}
			
			} else {
				setOrderNumber( getService("integrationService").getIntegrationByIntegrationPackage( setting('globalOrderNumberGeneration') ).getIntegrationCFC().getNewOrderNumber(order=this) );
			}

			setOrderOpenDateTime( now() );
			setOrderOpenIPAddress( getRemoteAddress() );

			// Loop over the order payments to setAmount = getAmount so that any null payments get explicitly defined
			for(var orderPayment in getOrderPayments()) {
				orderPayment.setAmount( orderPayment.getAmount() );
			}
			
			// create openorderitem records
			getDAO('InventoryDAO').manageOpenOrderItem(actionType = 'add', orderID = getOrderID());

		}

		// If the order is closed, and has no close dateTime
		if(!isNull(getOrderStatusType()) && !isNull(getOrderStatusType().getSystemCode()) && getOrderStatusType().getSystemCode() == "ostClosed" && isNull(getOrderCloseDateTime())) {
			setOrderCloseDateTime( now() );
			// delete openorderitem records
			getDAO('InventoryDAO').manageOpenOrderItem(actionType = 'delete', orderID = getOrderID());
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
        return getOrderService().orderCanBeCanceled(this);
    }

	public boolean function hasGiftCardOrderItems(orderItemID=""){
		if(!structKeyExists(variables,'giftCardOrderItemsCount')){
			var giftcardProductType = getService('productService').getProductTypeBySystemCode('gift-card');

			var orderItemCollectionList = this.getOrderItemsCollectionList(isNew=true);
			orderItemCollectionList.setDisplayProperties('order.orderID');
			orderItemCollectionList.addDisplayAggregate('orderItemID','COUNT','orderItemCount');
			orderItemCollectionList.addFilter('sku.product.productType.productTypeIDPath','#giftcardProductType.getProductTypeID()#%','Like');
			if(arraylen(orderItemCollectionList.getRecords())){
				variables.giftCardOrderItemsCount = orderItemCollectionList.getRecords()[1]['orderItemCount'] > 0;	
			}else{
				variables.giftCardOrderItemsCount = 0;
			}

		}
		return variables.giftCardOrderItemsCount;
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
	
	public numeric function getTotalQuantityBySkuID(required string skuID){
		var quantity = 0;
		
		for ( var orderItem in getOrderItems() ){
			if (!isNull(orderItem.getSku()) && orderItem.getSku().getSkuID() == arguments.skuID) {
				quantity += orderItem.getQuantity();
			}
		}
		
		return quantity;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getOrderStatusHistoryTypeCodeList() {
		if(!structKeyExists(variables,'orderStatusHistoryTypeCodeList')){
			var list = "";
			var orderStatusHistoryCollection = this.getOrderStatusHistoryCollectionList();
			orderStatusHistoryCollection.setDisplayProperties('createdDateTime,orderStatusHistoryType.typeCode');
			orderStatusHistoryCollection.addOrderBy('createdDateTime|asc');
			var records = orderStatusHistoryCollection.getRecords();
			for(var record in records){
				list = listAppend(list,record['orderStatusHistoryType_typeCode']);
			}
			variables.orderStatusHistoryTypeCodeList = list;
		}
		return variables.orderStatusHistoryTypeCodeList;
	}

	public any function getAddOrderItemSkuOptionsSmartList() {
		var optionsSmartList = getService("skuService").getSkuSmartList();
		optionsSmartList.addFilter('activeFlag', 1);
		optionsSmartList.addFilter('product.activeFlag', 1);
		var showUnpublishedSkusFlag = setting('orderShowUnpublishedSkusFlag');
		if(!isNull(showUnpublishedSkusFlag) && !showUnpublishedSkusFlag){
			optionsSmartList.addFilter('publishedFlag', 1);
		}
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

	public array function getEligibleSavedAccountPaymentMethods() {
		if(!structKeyExists(variables, "eligibleSavedAccountPaymentMethods")) {
			variables.eligibleSavedAccountPaymentMethods = [];
			
			if (!isNull(getAccount()) && isArray(getEligiblePaymentMethodDetails())) {

				var eligiblePaymentMethodIDList = "";

				// Create list of eligible paymentMethodID for order to use for accountPaymentMethod filtering
				for (var eligiblePaymentMethodBean in getEligiblePaymentMethodDetails()) {
					eligiblePaymentMethodIDList = listAppend(eligiblePaymentMethodIDList, eligiblePaymentMethodBean.paymentMethod.getPaymentMethodID());
				}

				/* TODO: Can't use collections without refactoring HibachiUtilityService.buildPropertyIdentifierDataStruct 
				var accountPaymentMethodCollection = getAccount().getAccountPaymentMethodsCollectionList();
				accountPaymentMethodCollection.addFilter('paymentMethod.paymentMethodID','#eligiblePaymentMethodIDList#','IN');
				accountPaymentMethodCollection.addFilter('activeFlag', 1);
				variables.eligibleSavedAccountPaymentMethods = accountPaymentMethodCollection.getRecords();
				*/
				if(len(eligiblePaymentMethodIDList)){
					var accountPaymentMethodSmartList = getAccount().getAccountPaymentMethodsSmartList();
					accountPaymentMethodSmartList.addInFilter('paymentMethod.paymentMethodID','#eligiblePaymentMethodIDList#');
					accountPaymentMethodSmartList.addFilter('activeFlag', 1);
					variables.eligibleSavedAccountPaymentMethods = accountPaymentMethodSmartList.getRecords();
				}else{ 
					variables.eligibleSavedAccountPaymentMethods = [];
					
				}
			}
		}
		
		return variables.eligibleSavedAccountPaymentMethods;
	}

	public numeric function getItemDiscountAmountTotal() {
		var discountTotal = 0;
		var orderItems = getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + orderItems[i].getDiscountAmount());
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal - orderItems[i].getDiscountAmount());
			} else {
				throw("there was an issue calculating the itemDiscountAmountTotal because of a orderItemType associated with one of the items");
			}
		}
		return discountTotal;
	}

	public numeric function getOrderAndItemDiscountAmountTotal(){
		return getItemDiscountAmountTotal() + getOrderDiscountAmountTotal();
	}

	public numeric function getFulfillmentDiscountAmountTotal() {
		var discountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + getOrderFulfillments()[i].getDiscountAmount());
		}
		return discountTotal;
	}

	public numeric function getFulfillmentTotal() {
		return getService('HibachiUtilityService').precisionCalculate(getFulfillmentChargeTotal() - getFulfillmentRefundPreTax());
	}
	
	public numeric function getFulfillmentHandlingFeeTotal() {
		var handlingFeeTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			handlingFeeTotal = getService('HibachiUtilityService').precisionCalculate(handlingFeeTotal + getOrderFulfillments()[i].getHandlingFee());
		}
		return handlingFeeTotal;
	}

	public numeric function getFulfillmentChargeTotal() {
		var fulfillmentChargeTotal = 0;
		var numFulfillments = arrayLen(getOrderFulfillments());
		for(var i=1; i<=numFulfillments; i++) {
			fulfillmentChargeTotal = getService('HibachiUtilityService').precisionCalculate(fulfillmentChargeTotal + getOrderFulfillments()[i].getFulfillmentCharge());
		}
		fulfillmentChargeTotal = getService('HibachiUtilityService').precisionCalculate(fulfillmentChargeTotal + getFulfillmentHandlingFeeTotal());
		
		return fulfillmentChargeTotal;
	}
	
	public numeric function getFulfillmentChargeTotalBeforeHandlingFees() {
		var fulfillmentChargeTotalBeforeHandlingFees = 0;
		var numFulfillments = arrayLen(getOrderFulfillments());
		for(var i=1; i<=numFulfillments; i++) {
			fulfillmentChargeTotalBeforeHandlingFees = getService('HibachiUtilityService').precisionCalculate(fulfillmentChargeTotalBeforeHandlingFees + getOrderFulfillments()[i].getFulfillmentCharge());
		}
		
		fulfillmentChargeTotalBeforeHandlingFees -= getFulfillmentRefundPreTax();
		
		return fulfillmentChargeTotalBeforeHandlingFees;
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
		fulfillmentChargeAfterDiscountTotal -= getFulfillmentRefundTotal();
		return fulfillmentChargeAfterDiscountTotal;
	}
	
	public numeric function getFulfillmentChargeAfterDiscountPreTaxTotal() {
		var fulfillmentChargeAfterDiscountTotal = 0;
		for(var i=1; i<=arrayLen(getOrderFulfillments()); i++) {
			fulfillmentChargeAfterDiscountTotal = getService('HibachiUtilityService').precisionCalculate(fulfillmentChargeAfterDiscountTotal + getOrderFulfillments()[i].getChargeAfterDiscountPreTax());
		}
		fulfillmentChargeAfterDiscountTotal -= getFulfillmentRefundPretax();
		return fulfillmentChargeAfterDiscountTotal;
	}
	
	public numeric function getFulfillmentChargeNotRefunded() {
		return getService('HibachiUtilityService').precisionCalculate(getFulfillmentChargeAfterDiscountPreTaxTotal() - getFulfillmentRefundPreTaxOnReferencingOrders());
	}
	
	public numeric function getFulfillmentRefundPreTaxOnReferencingOrders(){
		var fulfillmentRefundTotal = 0;
		for(var referencingOrder in getReferencingOrders()){
			if(!listFindNoCase('ostNotPlaced,ostCanceled',referencingOrder.getOrderStatusType().getSystemCode())){
				fulfillmentRefundTotal += referencingOrder.getFulfillmentRefundPreTax();
				fulfillmentRefundTotal -= referencingOrder.getFulfillmentChargeAfterDiscountPreTaxTotal();
			}
		}
		return fulfillmentRefundTotal;
	}
	
	public numeric function getFulfillmentRefundPreTax(){
		var fulfillmentRefundPreTax = 0;
		for(var i=1; i<=arrayLen(getOrderReturns()); i++) {
			fulfillmentRefundPreTax = getService('HibachiUtilityService').precisionCalculate(fulfillmentRefundPreTax + getOrderReturns()[i].getFulfillmentRefundPreTax());
		}

		return fulfillmentRefundPreTax;
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

	public any function getDynamicChargeOrderPayment(any orderPayment) {
			
		var orderPayments = getOrderPayments();  
		for(var orderPayment in orderPayments) {
			
			//don't consider a passed orderPayment as the dynamic 
			if( structKeyExists(arguments, 'orderPayment') &&
				arguments.orderPayment.getOrderPaymentID() == orderPayment.getOrderPaymentID() 
			){
				continue; 	
			} 
			
			if(orderPayment.getDynamicAmountFlag() &&
			   orderPayment.getStatusCode() == 'opstActive' &&
			   orderPayment.getOrderPaymentType().getSystemCode() == 'optCharge'
			){
				return orderPayment;
			} 
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
	    var paymentAmountDue = getService('HibachiUtilityService').precisionCalculate(getService('HibachiUtilityService').precisionCalculate(getTotal() - getPaymentAmountReceivedTotal()) + getPaymentAmountCreditedTotal());
	    if(paymentAmountDue > 0 && this.hasGiftCardOrderPaymentAmount()){
	        paymentAmountDue = paymentAmountDue - this.getGiftCardOrderPaymentAmountNotReceived();
	    }
	    return paymentAmountDue;
	}
	
	//the payments have all been received
	public boolean function isOrderPaidFor(){
		return val(getService('HibachiUtilityService').precisionCalculate(getPaymentAmountReceivedTotal() - getPaymentAmountCreditedTotal())) == getTotal();
	}
	
	public boolean function isOrderFullyDelivered(){
		return getQuantityUndelivered() == 0 && getQuantityUnreceived() == 0;
	}
	
	public boolean function hasDropSku(){
		 var orderItemCollectionList = getOrderService().getOrderItemCollectionList();
		 orderItemCollectionList.addFilter('order.orderID', this.getOrderID());
		 orderItemCollectionList.addFilter('rewardSkuFlag', 1);
		 orderItemCollectionList.setPageRecordsShow(1);
		 return arrayLen(orderItemCollectionList.getPageRecords(formatRecords=false));
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
	
	public numeric function getPaymentAmountCapturedTotal() {
		var totalPaymentsCaptured = 0;

		for(var orderPayment in getOrderPayments()) {
			if(orderPayment.getStatusCode() eq "opstActive") {
				totalPaymentsCaptured = getService('HibachiUtilityService').precisionCalculate(totalPaymentsCaptured + orderPayment.getAmountCaptured());
			}
		}

		return totalPaymentsCaptured;
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
				totalPaymentsCredited = val(precisionEvaluate(totalPaymentsCredited + orderPayment.getAmountCredited()));
			}
		}

		return totalPaymentsCredited;
	}

	public numeric function getReferencingPaymentAmountCreditedTotal() {
		var totalReferencingPaymentsCredited = 0;

		for(var orderPayment in getOrderPayments()) {
			for(var referencingOrderPayment in orderPayment.getReferencingOrderPayments()) {
				if(referencingOrderPayment.getStatusCode() eq "opstActive") {
					totalReferencingPaymentsCredited = val(precisionEvaluate(totalReferencingPaymentsCredited + referencingOrderPayment.getAmountCredited()));
				}
			}
		}

		return totalReferencingPaymentsCredited;
	}
	
	public numeric function getTotalAmountCreditedIncludingReferencingPayments(){
		return getPaymentAmountCreditedTotal() + getReferencingPaymentAmountCreditedTotal();
	}
	
	public numeric function getRefundableAmount(){
		if(!structKeyExists(variables,'refundableAmount')){
			var refundableAmount = 0;
			for(var orderPayment in getOrderPayments()){
				refundableAmount += orderPayment.getRefundableAmount();
			}
			variables.refundableAmount = refundableAmount;
		}
		return variables.refundableAmount;
	}
	/* This function does exactly what it says, don't @ me */
	public numeric function getRefundableAmountMinusRemainingTaxesAndFulfillmentCharge(){
		return getRefundableAmount() - getTaxTotalNotRefunded() - getFulfillmentChargeNotRefunded();
	}
	
	public numeric function getTaxTotalNotRefunded(){
		return getService('HibachiUtilityService').precisionCalculate(getTaxTotal() + getTaxTotalOnReturnOrders());
	}
	
	public numeric function getTaxTotalOnReturnOrders(){
		var taxTotalOnReturnOrders = 0;
		
		for(var referencingOrder in getReferencingOrders()){
			if(!listFindNoCase('ostNotPlaced,ostCanceled',referencingOrder.getOrderStatusType().getSystemCode()) && listFindNoCase('otReturnOrder,otExchangeOrder,otRefundOrder',referencingOrder.getOrderType().getSystemCode())){
				taxTotalOnReturnOrders += referencingOrder.getTaxTotal();
			}
		}
		return taxTotalOnReturnOrders;
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
			// get all the promotion codes applied and attached it to applied Promotion Struct
			var appliedPromotionCodesCollectionList = this.getPromotionCodesCollectionList();
			appliedPromotionCodesCollectionList.setDisplayProperties('promotion.promotionID,promotionCodeID,promotionCode,promotion.promotionName');
			
			var appliedPromotionCodesOrderItemCollectionList = appliedPromotionCodesCollectionList.duplicateCollection();
			
			var appliedPromotionCodesOrderFulfillmentCollectionList = appliedPromotionCodesCollectionList.duplicateCollection();
			
			appliedPromotionCodesCollectionList.addFilter('promotion.appliedPromotions.order.orderID', getOrderID(), "=");
			
			appliedPromotionCodesOrderItemCollectionList.addFilter('promotion.appliedPromotions.orderItem.order.orderID', getOrderID(), "=");
			
			appliedPromotionCodesOrderFulfillmentCollectionList.addFilter('promotion.appliedPromotions.orderFulfillment.order.orderID', getOrderID(), "=");

			var appliedPromotionCodes = appliedPromotionCodesCollectionList.getRecords();
			arrayAppend(appliedPromotionCodes,appliedPromotionCodesOrderItemCollectionList.getRecords(),true);
			arrayAppend(appliedPromotionCodes,appliedPromotionCodesOrderFulfillmentCollectionList.getRecords(),true);
			
			var promotionCodeCollectionlist = getService('promotionService').getPromotionCodeCollectionList();
			promotionCodeCollectionlist.addFilter('orders.orderID',getOrderID());
			promotionCodeCollectionlist.setDisplayProperties('promotion.promotionID,promotionCodeID,promotionCode,promotion.promotionName,promotion.promotionID');
			
			var qualifiedPromotions = '';
			
			for(var appliedPromotionCode in appliedPromotionCodes) {
				promotionToAdd = {}; 
				promotionToAdd["qualified"] = true; 
				promotionToAdd["promotionCodeID"] = appliedPromotionCode['promotionCodeID'];
				promotionToAdd["promotionCode"] = appliedPromotionCode['promotionCode'];
				promotionToAdd["promotion_promotionName"] = appliedPromotionCode['promotion_promotionName'];  
				promotionToAdd["promotion_promotionID"] = appliedPromotionCode['promotion_promotionID'];
				qualifiedPromotions = listAppend(qualifiedPromotions,promotionToAdd["promotion_promotionID"]);
				arrayAppend(variables.allAppliedPromotions, promotionToAdd); 
			}   

			promotionCodeCollectionlist.addFilter('promotion.promotionID',qualifiedPromotions,'NOT IN');
			var unQualifiedPromotionCodes = promotionCodeCollectionlist.getRecords();
			
			for(var unQualifiedPromotionCode in unQualifiedPromotionCodes){
				promotionToAdd = {}; 
				promotionToAdd["qualified"] = false;
				promotionToAdd["promotionCodeID"] = unQualifiedPromotionCode['promotionCodeID'];
				promotionToAdd["promotionCode"] = unQualifiedPromotionCode['promotionCode'];
				promotionToAdd["promotion_promotionName"] = unQualifiedPromotionCode['promotion_promotionName'];  
			    	promotionToAdd["promotion_promotionID"] = unQualifiedPromotionCode['promotion_promotionID'];
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

	public any function getRootOrderItemsCollectionList(){
		var rootOrderItemsCollectionList = getService('orderService').getOrderItemCollectionList();
		rootOrderItemsCollectionList.addFilter('order.orderID',this.getOrderID());
		rootOrderItemsCollectionList.addFilter('parentOrderItem','NULL','IS');
		return rootOrderItemsCollectionList;
	}

	public any function getRootOrderItems(){
		var rootOrderItems = [];
	
		for(var orderItem in this.getOrderItems()){
			if(isNull(orderItem.getParentOrderItem())){
				ArrayAppend(rootOrderItems, orderItem);
			}
		}
		variables.rootOrderItems = rootOrderItems;

		return variables.rootOrderItems;
	}

	public numeric function getTotalQuantity() {
		if(!structKeyExists(variables,'totalQuantity')){
			var totalQuantity = 0;
			for(var i=1; i<=arrayLen(getOrderItems()); i++) {
				totalQuantity += getOrderItems()[i].getQuantity();
			}
			variables.totalQuantity = totalQuantity;
		}
		

		return variables.totalQuantity;
	}

	public numeric function getTotalSaleQuantity() {
		var saleQuantity = 0;
		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",getOrderItems()[i].getOrderItemType().getSystemCode()) ) {
				saleQuantity += getOrderItems()[i].getQuantity();
			}
		}
		return saleQuantity;
	}
	
	/** returns the sum of all deposits required on the order with tax. we can
 	 *  tell if a deposit is required because a setting will indicate that they can pay a fraction
 	 *  of the whole. Returns the total deposit amount rounded to two decimal places IE. 3.495 becomes 3.50.
 	 */
 	public numeric function getTotalDepositAmount() {
 		var totalDepositAmount = 0;
 		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
 			if(getOrderItems()[i].getOrderItemType().getSystemCode() eq "oitSale" && !isNull(getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder"))  && len(getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder")) != 0) {
 				if (getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder") == 0){
 					totalDepositAmount += val(precisionEvaluate("(getOrderItems()[i].getSku().setting('skuMinimumPercentageAmountRecievedRequiredToPlaceOrder')) * getOrderItems()[i].getExtendedPrice()")) ;	
 				}else if (getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder") > 0){
 					totalDepositAmount += val(precisionEvaluate("(getOrderItems()[i].getSku().setting('skuMinimumPercentageAmountRecievedRequiredToPlaceOrder')/100) * (getOrderItems()[i].getExtendedPrice() + getOrderItems()[i].getTaxAmount()) ")) ;
 				}	
 			}
 		}
 		totalDepositAmount = val(precisionEvaluate("round(totalDepositAmount * 100)/100"));
 		return totalDepositAmount;
 	}

	public boolean function isAllowedToPlaceOrderWithoutPayment(){
		return getService("orderService").isAllowedToPlaceOrderWithoutPayment(this);
	}

 	public boolean function hasDepositItemsOnOrder(){
		var orderItemsCount = arrayLen(getOrderItems());  
 		for(var i=1; i<=orderItemsCount; i++) {
 			if(getOrderItems()[i].getOrderItemType().getSystemCode() eq "oitSale" && !isNull(getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder")) && len(getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder")) != 0) {
 				
 				return true;
 			}
 		}
 		
 		return false;
 	}
 	
 	public boolean function hasNonDepositItemsOnOrder(){
 		//and has at least one sale item
 		for(var i=1; i<=arrayLen(getOrderItems()); i++) {
 			if(getOrderItems()[i].getOrderItemType().getSystemCode() eq "oitSale" && isNull(getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder") || len(getOrderItems()[i].getSku().setting("skuMinimumPercentageAmountRecievedRequiredToPlaceOrder")) == 0)) {
 				return true;
 			}
 		}
 		return false;
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
		
		return getDao('orderDao').getDeliveredQuantitySumByOrderID(getOrderID());
		
	}

	public numeric function getQuantityUndelivered() {
		return this.getTotalSaleQuantity() - this.getQuantityDelivered();
	}

	public numeric function getQuantityReceived() {
		var quantityReceived = 0;
		
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
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
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
	
	public numeric function getVATTotal() {
		var vatTotal = 0;
		var orderItems = this.getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				vatTotal = getService('HibachiUtilityService').precisionCalculate(vatTotal + orderItems[i].getVATAmount());
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				vatTotal = getService('HibachiUtilityService').precisionCalculate(vatTotal - orderItems[i].getVATAmount());
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		
		vatTotal = getService('HibachiUtilityService').precisionCalculate(vatTotal + this.getFulfillmentChargeVATAmount());
		vatTotal = getService('HibachiUtilityService').precisionCalculate(vatTotal - this.getOrderReturnFulfillmentVATRefund());
		
		variables.vatTotal = vatTotal;
		
		return variables.vatTotal;
	}
	

	public numeric function getTaxTotal() {
		var taxTotal = 0;
		var orderItems = this.getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				taxTotal = getService('HibachiUtilityService').precisionCalculate(taxTotal + orderItems[i].getTaxAmount());
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				taxTotal = getService('HibachiUtilityService').precisionCalculate(taxTotal - orderItems[i].getTaxAmount());
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}

		taxTotal += getFulfillmentChargeTaxAmount();
		taxTotal -= getOrderReturnFulfillmentTaxRefund();
		variables.taxTotal = taxTotal;

		return taxTotal;
	}
	
	public numeric function getOrderReturnFulfillmentTaxRefund(){
		if(!structKeyExists(variables,'orderReturnFulfillmentTaxRefund') || ( variables.refreshCalculateFulfillmentChargeFlag ) ){
			var taxTotal = 0;
			for(var orderReturn in this.getOrderReturns()) {
				taxTotal = getService('HibachiUtilityService').precisionCalculate(taxTotal + orderReturn.getFulfillmentTaxRefund());
			}
			variables.orderReturnFulfillmentTaxRefund = taxTotal;
			
			variables.refreshCalculateFulfillmentChargeFlag = false;
		}
		return variables.orderReturnFulfillmentTaxRefund;
	}
	
	public numeric function getOrderReturnFulfillmentVATRefund(){
		if(!structKeyExists(variables,'orderReturnFulfillmentVATRefund') || ( variables.refreshCalculateFulfillmentChargeFlag ) ){
			var vatTotal = 0;
			for(var orderReturn in this.getOrderReturns()) {
				vatTotal = getService('HibachiUtilityService').precisionCalculate(vatTotal + orderReturn.getFulfillmentVATRefund());
			}
			variables.orderReturnFulfillmentVATRefund = vatTotal;
			
			variables.refreshCalculateFulfillmentChargeFlag = false;
		}
		return variables.orderReturnFulfillmentVATRefund;
	}
	
	public numeric function getFulfillmentChargeTaxAmount(){
		if(!structKeyExists(variables,'fulfillmentChargeTaxAmount') || ( variables.refreshCalculateFulfillmentChargeFlag ) ){
			var taxTotal = 0;
			for(var orderFulfillment in this.getOrderFulfillments()) {
				taxTotal = getService('HibachiUtilityService').precisionCalculate(taxTotal + orderFulfillment.getChargeTaxAmount());
			}
			variables.fulfillmentChargeTaxAmount = taxTotal;
			
			variables.refreshCalculateFulfillmentChargeFlag = false;
		}
		return variables.fulfillmentChargeTaxAmount;
	}
	
	public numeric function getFulfillmentChargeVATAmount(){
		if(!structKeyExists(variables,'fulfillmentChargeVATAmount') || ( variables.refreshCalculateFulfillmentChargeFlag ) ){
			var vatTotal = 0;
			for(var orderFulfillment in this.getOrderFulfillments()) {
				vatTotal = getService('HibachiUtilityService').precisionCalculate(vatTotal + orderFulfillment.getChargeVATAmount());
			}
			variables.fulfillmentChargeVATAmount = vatTotal;
			variables.refreshCalculateFulfillmentChargeFlag = false;
		}
		return variables.fulfillmentChargeVATAmount;
	}

	public numeric function getTotal() {
		return val(getService('HibachiUtilityService').precisionCalculate(getSubtotal() + getTaxTotal() + getFulfillmentTotal() - getDiscountTotal()));
	}

	public numeric function getTotalItems() {
		return arrayLen(getOrderItems());
	}
	
	public any function getOrderCreatedSiteOptions(){
		var collectionList = getService('SiteService').getCollectionList('Site');
		
		collectionList.setDisplayProperties('siteID|value,siteName|name');
		
		var options = [{value ="", name="None"}];
		
		arrayAppend(options, collectionList.getRecords(), true );
		
		return options;
	}
	
	public numeric function getTotalItemQuantity(){
		var orderItems = this.getOrderItems();
		var totalItemQuantity = 0; 
		for(var orderItem in orderItems){
			if (isNull(orderItem.getParentOrderItem())){
				totalItemQuantity += orderItem.getQuantity();
			} 
		}
		return totalItemQuantity; 
	}
	
	public array function getQualifiedPromotionRewards( boolean refresh=false ){
		if(!structKeyExists(variables, 'qualifiedPromotionRewards') || arguments.refresh ){
			return getService('PromotionService').getQualifiedPromotionRewardsForOrder( this );
		}
	}
	
	public array function getQualifiedPromotionRewardSkus( numeric pageRecordsShow=25, boolean refresh=false ){
		if( !structKeyExists(variables,'qualifiedRewardSkus') || arguments.refresh ){
			
			variables.qualifiedRewardSkus = getService('PromotionService').getQualifiedPromotionRewardSkusForOrder( order=this, pageRecordsShow=arguments.pageRecordsShow );
		}
		return variables.qualifiedRewardSkus;
	}
	
	public string function getQualifiedPromotionRewardSkuIDs( numeric pageRecordsShow=25, boolean refresh=false ){
		if( !structKeyExists(variables,'qualifiedRewardSkuIDs') || arguments.refresh ){
			variables.qualifiedRewardSkuIDs = getService('PromotionService').getQualifiedPromotionRewardSkuIDsForOrder( order=this, pageRecordsShow=arguments.pageRecordsShow );
		}
		return variables.qualifiedRewardSkuIDs;
	}
	
	public string function getQualifiedFreePromotionRewardSkuIDs( numeric pageRecordsShow=25 ){
		
		return getService('PromotionService').getQualifiedFreePromotionRewardSkuIDs( order=this, pageRecordsShow=arguments.pageRecordsShow )?:"";
		
	}


	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Account (many-to-one)
	public any function setAccount(required any account, boolean skipBidirectional=false) {
		variables.account = arguments.account;
		if(arguments.skipBidirectional){
			return this;
		} 
		arguments.order = this;
		return getService('AccountService').addOrderToAccount(argumentCollection=arguments);
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
		structDelete(variables,'rootOrderItems');
	}
	public void function removeOrderItem(required any orderItem) {
		arguments.orderItem.removeOrder( this );
		structDelete(variables,'rootOrderItems');
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
	
	// Order Status History (one-to-many)
	public void function addOrderStatusHistory(required any orderStatusHistory) {
		arguments.orderStatusHistory.setOrder( this );
	}
	
	public void function removeOrderStatusHistory(required any orderStatusHistory) {
		arguments.orderStatusHistory.removeOrder( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================
	
	public boolean function getQuoteFlag(){
		if(!structKeyExists(variables,'quoteFlag')){
			variables.quoteFlag = false;
		}
		return variables.quoteFlag;
	}
	
	public void function setQuoteFlag(boolean quoteFlag=false){
		//if the quoteFlag was previously false and is being set to true then we should reset the quote price expiration
		if(!getQuoteFlag() && arguments.quoteFlag){
			setQuotePriceExpiration(generateQuotePriceExpiration());
		}
		variables.quoteFlag = arguments.quoteFlag;
	}
	
	public any function generateQuotePriceExpiration(string datePart="d"){
		var generatedQuotePriceExpiration = dateAdd(arguments.datePart,setting('globalQuotePriceFreezeExpiration'),now());
		return generatedQuotePriceExpiration;
	}

	public any function getQuotePriceExpiration(){
		if(!structKeyExists(variables,'quotePriceExpiration')){
			//snap shot expiration by setting
			variables.quotePriceExpiration = generateQuotePriceExpiration();
		}
		if(structKeyExists(variables,'quotePriceExpiration')){
			return variables.quotePriceExpiration;
		}
	}
	
	public boolean function isQuotePriceExpired(){
		var isQuotePriceExpired = now() > getQuotePriceExpiration();
		
		if(isQuotePriceExpired){
			//if quote price is expired then it is no longer a quote and is instead an abandoned cart
			structDelete(variables,'quoteFlag');
			structDelete(variables,'quotePriceExpiration');
		}
		
		return isQuotePriceExpired;
	}

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
		return getOrderService().getSimpleRepresentation(this);
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
		//CUSTOM FUNCTIONS BEGIN

public numeric function getPersonalVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('personalVolume');
    }
    public numeric function getTaxableAmountSubtotal(){
        return getCustomPriceFieldSubtotal('taxableAmount');
    }
    public numeric function getCommissionableVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('commissionableVolume');
    }
    public numeric function getRetailCommissionSubtotal(){
        return getCustomPriceFieldSubtotal('retailCommission');
    }
    public numeric function getProductPackVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('productPackVolume');
    }
    public numeric function getRetailValueVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('retailValueVolume');
    }
    public numeric function getPersonalVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('personalVolume');
    }
    public numeric function getTaxableAmountSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('taxableAmount');
    }
    public numeric function getCommissionableVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('commissionableVolume');
    }
    public numeric function getRetailCommissionSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('retailCommission');
    }
    public numeric function getProductPackVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('productPackVolume');
    }
    public numeric function getRetailValueVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('retailValueVolume');
    }
    public numeric function getPersonalVolumeTotal(){
        return getCustomPriceFieldTotal('personalVolume');
    }
    public numeric function getTaxableAmountTotal(){
        return getCustomPriceFieldTotal('taxableAmount');
    }
    public numeric function getCommissionableVolumeTotal(){
        return getCustomPriceFieldTotal('commissionableVolume');
    }
    public numeric function getRetailCommissionTotal(){
        return getCustomPriceFieldTotal('retailCommission');
    }
    public numeric function getProductPackVolumeTotal(){
        return getCustomPriceFieldTotal('productPackVolume');
    }
    public numeric function getRetailValueVolumeTotal(){
        return getCustomPriceFieldTotal('retailValueVolume');
    }
    public numeric function getPersonalVolumeDiscountTotal(){
        return getCustomDiscountTotal('personalVolume');
    }
    public numeric function getTaxableAmountDiscountTotal(){
        return getCustomDiscountTotal('taxableAmount');
    }
    public numeric function getCommissionableVolumeDiscountTotal(){
        return getCustomDiscountTotal('commissionableVolume');
    }
    public numeric function getRetailCommissionDiscountTotal(){
        return getCustomDiscountTotal('retailCommission');
    }
    public numeric function getProductPackVolumeDiscountTotal(){
        return getCustomDiscountTotal('productPackVolume');
    }
    public numeric function getRetailValueVolumeDiscountTotal(){
        return getCustomDiscountTotal('retailValueVolume');
    }
    
    public numeric function getCustomPriceFieldSubtotal(required string customPriceField){
        var subtotal = 0;
		var orderItems = this.getRootOrderItems();
		var orderItemsCount = arrayLen(orderItems);
		for(var i=1; i<=orderItemsCount; i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal + orderItems[i].getCustomExtendedPrice(arguments.customPriceField));
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal - orderItems[i].getCustomExtendedPrice(arguments.customPriceField));
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return subtotal;
    }
	
	public numeric function getCustomPriceFieldSubtotalAfterItemDiscounts(customPriceField) {
		return getService('HibachiUtilityService').precisionCalculate(getCustomPriceFieldSubtotal(arguments.customPriceField) - getItemCustomDiscountAmountTotal(arguments.customPriceField));
	}
    
    public numeric function getItemCustomDiscountAmountTotal(required string customPriceField) {
		var discountTotal = 0;
		var orderItems = getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + orderItems[i].getCustomDiscountAmount(arguments.customPriceField));
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal - orderItems[i].getCustomDiscountAmount(arguments.customPriceField));
			} else {
				throw("there was an issue calculating the itemDiscountAmountTotal because of a orderItemType associated with one of the items");
			}
		}
		return discountTotal;
	}
    
    public numeric function getCustomDiscountTotal(customPriceField) {
		return getService('HibachiUtilityService').precisionCalculate(getItemCustomDiscountAmountTotal(arguments.customPriceField) + getOrderCustomDiscountAmountTotal(arguments.customPriceField));
	}
	
	public numeric function getOrderCustomDiscountAmountTotal(customPriceField) {
		var discountAmount = 0;

		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getCustomDiscountAmount(arguments.customPriceField));
		}

		return discountAmount;
	}
	
	public numeric function getCustomPriceFieldTotal(customPriceField) {
		return val(getService('HibachiUtilityService').precisionCalculate(getCustomPriceFieldSubtotal(arguments.customPriceField)  - getCustomDiscountTotal(arguments.customPriceField)));
	}
	
	public boolean function isNotPaid() {
		return getPaymentAmountDue() > 0;
	}
	
	public boolean function getVipEnrollmentOrderFlag(){
	    var orderItemCollectionList = getService("OrderService").getOrderItemCollectionList();
	    orderItemCollectionList.addFilter("order.orderID",this.getOrderID());
	    //Product code for the VIP registration fee
	    orderItemCollectionList.addFilter("sku.product.productType.urlTitle","vpn-customer-registr");
	    orderItemCollectionList.setDisplayProperties("orderItemID");
	    return orderItemCollectionList.getRecordsCount() > 0;
	}
	
	public any function getMarketPartnerEnrollmentOrderID(){
	    if (!structKeyExists(variables, "marketPartnerEnrollmentOrderID")){
    	    var orderItemCollectionList = getService("OrderService").getOrderItemCollectionList();
    	    orderItemCollectionList.addFilter("order.account.accountID", "#getAccount().getAccountID()#");
    	    orderItemCollectionList.addFilter("order.orderStatusType.systemCode", "ostNotPlaced", "!=");
    	    orderItemCollectionList.addFilter("order.monatOrderType.typeCode","motMPEnrollment");
    	    orderItemCollectionList.setDisplayProperties("order.orderID");// Date placed 
    	    var records = orderItemCollectionList.getRecords();
    	    if (arrayLen(records)){
    	        variables.marketPartnerEnrollmentOrderID = records[1]['order_orderID'];
    	        return records[1]['order_orderID'];
    	    }
	    }
	    
	    if (!isNull(variables.marketPartnerEnrollmentOrderID)){
	    	return variables.marketPartnerEnrollmentOrderID;
	    }
	}
	
	public any function getAccountType() {
	    
	    if (structKeyExists(variables, "accountType")){
	        return variables.accountType;
	    }

	    if (!isNull(getAccount()) && !isNull(getAccount().getAccountType()) && len(getAccount().getAccountType())){
	        variables.accountType = getAccount().getAccountType();
	    }else{
	        variables.accountType = "";
	    }
	    return variables.accountType;
	}
	
	public any function getAccountPriceGroup() {
	    if (structKeyExists(variables, "accountPriceGroup")){
	        return variables.accountPriceGroup;
	    }
	    
	    if (!isNull(getAccount()) && !isNull(getAccount().getPriceGroups())){
	        var priceGroups = getAccount().getPriceGroups();
    	    if (arraylen(priceGroups)){
    	        //there should only be 1 max.
    	        variables.accountPriceGroup = priceGroups[1].getPriceGroupCode();
    	        return variables.accountPriceGroup;
    	    }
	    }
	   
	}
	
	public struct function getListingSearchConfig() {
	   	param name = "arguments.selectedSearchFilterCode" default="lastTwoMonths"; //limiting listingdisplays to show only last 3 months of record by default
	    param name = "arguments.wildCardPosition" default = "exact";
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function hasMPRenewalFee() {
	    if(!structKeyExists(variables,'orderHasMPRenewalFee')){
            variables.orderHasMPRenewalFee = getService('orderService').orderHasMPRenewalFee(this.getOrderID());
		}
		return variables.orderHasMPRenewalFee;
	}
	
	public boolean function hasProductPack() {
	    if(!structKeyExists(variables,'orderHasProductPack')){
            variables.orderHasProductPack = getService('orderService').orderHasProductPack(this.getOrderID());
		}
		return variables.orderHasProductPack;
	}
	
	public boolean function subtotalWithinAllowedPercentage(){
	    var referencedOrder = this.getReferencedOrder();
	    if(isNull(referencedOrder)){
	        return true;
	    }
	    var dateDiff = 0;
	    if(!isNull(referencedOrder.getOrderCloseDateTime())){
    	         dateDiff = dateDiff('d',referencedOrder.getOrderCloseDateTime(),now());
	    }
	    if(dateDiff <= 30){
	        return true;
	    }else if(dateDiff > 365){
	        return false;
	    }else{
	        var originalSubtotal = referencedOrder.getSubTotal();
	        
	        var returnSubtotal = 0;
	        
	        var originalOrderReturnCollectionList = getService('OrderService').getOrderCollectionList();
	        originalOrderReturnCollectionList.setDisplayProperties('orderID,calculatedSubTotal');
	        originalOrderReturnCollectionList.addFilter('referencedOrder.orderID',referencedOrder.getOrderID());
	        originalOrderReturnCollectionList.addFilter("orderType.systemCode","otReturnOrder,otRefundOrder","in");
	        originalOrderReturnCollectionList.addFilter("orderID", "#getOrderID()#","!=");
	        originalOrderReturnCollectionList.addFilter("orderStatusType.systemCode","ostNew,ostClosed,ostProcessing","IN");
	        var originalOrderReturns = originalOrderReturnCollectionList.getRecords(formatRecords=false);
	        
	        for(var order in originalOrderReturns){
	            returnSubtotal += order['calculatedSubTotal'];
	        }

	        return abs(originalSubtotal * 0.9) - abs(returnSubtotal) >= abs(getSubTotal());
	    }
        return true;
	}
	
	public boolean function hasProductPackOrderItem(){
        var orderItemCollectionList = getService('orderService').getOrderItemCollectionList();
        orderItemCollectionList.addFilter('order.orderID',getOrderID());
        orderItemCollectionList.addFilter('sku.product.productType.urlTitle','productPack,starter-kit','in');
        return orderItemCollectionList.getRecordsCount() > 0;
	}
	
	/**
	 * This validates that the orders site matches the accounts created site
	 * if the order has an account already.
	 **/
	public boolean function orderCreatedSiteMatchesAccountCreatedSite(){
        if (!isNull(this.getAccount()) && !isNull(this.getAccount().getAccountCreatedSite())){
            if (this.getOrderCreatedSite().getSiteID() != this.getAccount().getAccountCreatedSite().getSiteID()){
                return false;
            }
        }
        return true;
	}
	 
	 
	 /**
	  * 2. If Site is UK and account is MP Max Order 1 placed in first 7 days 
	  * after enrollment order.
	  **/
	 public boolean function marketPartnerValidationMaxOrdersPlaced(){
	     
	    if( isNull( this.getAccount() ) 
	        || this.getAccount().getAccountType() != "marketPartner" 
	        || this.getOrderCreatedSite().getSiteCode() != "mura-uk" 
	        || isNull( this.getMarketPartnerEnrollmentOrderID() ) // If they've never enrolled, they can enroll.
	    ){
	        return true;
	    }

        var initialEnrollmentPeriodForMarketPartner = this.getOrderCreatedSite().setting("siteInitialEnrollmentPeriodForMarketPartner");
        
        if( isNull(initialEnrollmentPeriodForMarketPartner) ){
            return true;
        }
        if( isNull( this.getAccount().getEnrollmentDate() ) ){
            return true;
        }
        
        //If a UK MP is within the first 7 days of enrollment, check that they have not already placed more than 1 order.
		if ( dateDiff("d", this.getAccount().getEnrollmentDate(), now() ) <= initialEnrollmentPeriodForMarketPartner ){
		
			//This order is 1, so if they have any previous that is not the enrollment order,
			//they can't place this one.
			var previouslyOrdered = getService("orderService").getOrderCollectionList();

			//Find if they have placed more than the initial enrollment order already.
			previouslyOrdered.addFilter("orderID", getMarketPartnerEnrollmentOrderID(), "!=");
			previouslyOrdered.addFilter("account.accountID", getAccount().getAccountID());
			previouslyOrdered.addFilter("orderStatusType.systemCode", "ostNotPlaced", "!=");
			previouslyOrdered.addFilter("orderType.systemCode", "otSalesOrder");
			
			if ( previouslyOrdered.getRecordsCount() > 0 ){
				return false; //they can not purchase this because they already have purchased it.
			}
		}
		
		return true;
	 }
	 
	 /**
	  * 3. MP (Any site) can't purchase one past 30 days from account creation.
	  **/
	 public boolean function marketPartnerValidationMaxProductPacksPurchased(){
	 	
	 	if(this.getOrderStatusType().getSystemCode() != 'ostNotPlaced'){
	 		return true;
	 	}
	    
	    var maxDaysAfterAccountCreate = this.getOrderCreatedSite().setting("siteMaxDaysAfterAccountCreate");
	    
	    //Check if this is MP account AND created MORE THAN 30 days AND is trying to add a product pack.
		if (!isNull(maxDaysAfterAccountCreate) && !isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
			&& !isNull(getAccount().getCreatedDateTime()) 
			&& dateDiff("d", getAccount().getCreatedDateTime(), now()) > maxDaysAfterAccountCreate
			&& this.hasProductPackOrderItem()){
		
			return false; //they can not purchase this because they already have purchased it.
		
		//Check if they have previously purchased a product pack, then they also can't purchase a new one.
		} else if (!isNull(maxDaysAfterAccountCreate) && !isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
				&& !isNull(getAccount().getCreatedDateTime()) 
				&& dateDiff("d", getAccount().getCreatedDateTime(), now()) <= maxDaysAfterAccountCreate
				&& this.hasProductPackOrderItem()){

			var previouslyPurchasedProductPacks = getService("OrderService").getOrderItemCollectionList();

			//Find all valid previous placed sales orders for this account with a product pack on them.
			previouslyPurchasedProductPacks.addFilter("order.account.accountID", getAccount().getAccountID());
			previouslyPurchasedProductPacks.addFilter("order.orderStatusType.systemCode", "ostNotPlaced", "!=");
			previouslyPurchasedProductPacks.addFilter("order.orderType.systemCode", "otSalesOrder");
			previouslyPurchasedProductPacks.addFilter("sku.product.productType.productTypeName", "Product Pack");

			if (previouslyPurchasedProductPacks.getRecordsCount() > 0){
				return false; //they can not purchase this because they already have purchased it.
			}
		}
		return true;
	 }
	 
	public any function getDefaultStockLocation(){
	 	if(!structKeyExists(variables,'defaultStockLocation')){
	 		if(!isNull(getOrderCreatedSite())){
	 			var locations = getOrderCreatedSite().getLocations();
	 			if(!isNull(locations) && arrayLen(locations)){
	 				variables.defaultStockLocation = locations[1];
	 			}
	 		}
	 	}
	 	if(structKeyExists(variables,'defaultStockLocation')){
	 		return variables.defaultStockLocation;
	 	}
	}
	 
	public boolean function getIsLockedInProcessingOneFlag(){
		return getOrderStatusType().getSystemCode() == "ostProcessing" && getOrderStatusType().getTypeCode() == "processing1";
	}
	
	public boolean function getIsLockedInProcessingTwoFlag(){
		return getOrderStatusType().getSystemCode() == "ostProcessing" && getOrderStatusType().getTypeCode() == "processing2";
	}
	
	public boolean function getIsLockedInProcessingFlag(){
	
		return  (
					getOrderStatusType().getSystemCode() == "ostProcessing" 
					&& 
					(
						getOrderStatusType().getTypeCode() == "processing1"
						||
						getOrderStatusType().getTypeCode() == "processing2"
					)
				);
	}
	
	public numeric function getPurchasePlusTotal(){
	
		var purchasePlusRecords = getService('orderService').getPurchasePlusInformationForOrderItems(this.getOrderID());
		var total = 0;

		if(!isArray(purchasePlusRecords)){
			purchasePlusRecords = purchasePlusRecords.getRecords();
			for (var item in purchasePlusRecords){
				total +=  item.discountAmount;
			}
		}
		variables.purchasePlusTotal = total;

		
		return variables.purchasePlusTotal;
	}
	
	public boolean function orderPriceGroupMatchesAccount(){
		//first check account, account price groups should both not be null and have a length  
		//then we check if the order has a price group, if it does it should match the price group on the account - inverses are checked as to avoid nested logic
		return (isNull(this.getAccount().getPriceGroups()) || !arrayLen(this.getAccount().getPriceGroups()) 
				|| (!isNull(this.getPriceGroup().getPriceGroupCode()) && this.getPriceGroup().getPriceGroupCode() != this.getAccount().getPriceGroups()[1].getPriceGroupCode()) ) ? false : true;
	}
	
	public any function getCurrencyCode(){
		if(
			isNull(variables.currencyCode) 
			|| (
				!isNull(getOrderCreatedSite()) 
				&& !isNull(getOrderCreatedSite().getCurrencyCode())
				&& getOrderCreatedSite().getCurrencyCode() != variables.currencyCode
			)
		){
			variables.currencyCode = getOrderCreatedSite().getCurrencyCode()
		}
		return variables.currencyCode;
	}
	
	public boolean function marketPartnerValidationMaxOrderAmount(){
	 	
	 	var site = this.getOrderCreatedSite();
	 	if(isNull(site) || site.getSiteCode() != 'mura-uk'){
	 	    return true; 
	 	} 
	 	
	 	var accountType = this.getAccountType();
	 	if(isNull(accountType) || accountType != 'marketPartner'){
	 		return true;
	 	}
	 	
	    var initialEnrollmentPeriodForMarketPartner = site.setting("siteInitialEnrollmentPeriodForMarketPartner"); // 7-days
	    
        var enforceEnrollmentPeriod = isNull(this.getAccount()) || isNull(this.getAccount().getEnrollmentDate() ) || dateDiff( "d", this.getAccount().getEnrollmentDate(), now() ) <= initialEnrollmentPeriodForMarketPartner;

        var enforceUpgradePeriod = false;
        if( !isNull(this.getAccount()) ){
            var mpUpgradeDateTime = this.getAccount().getMpUpgradeDateTime();
            enforceUpgradePeriod = this.getUpgradeFlag() || ( !isNull(mpUpgradeDateTime) && dateDiff( "d", mpUpgradeDateTime, now() ) <= initialEnrollmentPeriodForMarketPartner );
        }

        //If a UK MP is within the first 7 days of enrollment/upgrade, check that they have not already placed more than 1 order.
		if ( enforceEnrollmentPeriod || enforceUpgradePeriod  ){
			var total = 0;
			
			if(!isNull(this.getAccount())){
				var orderCollectionList = account.getOrdersCollectionList();
				orderCollectionList.setDisplayProperties('calculatedTotal');
				orderCollectionList.addFilter('accountType','marketPartner');
				orderCollectionList.addFilter('orderStatusType.systemCode', 'ostNew,ostProcessing,ostClosed', 'IN');
				orderCollectionList.addFilter('orderID',this.getOrderID(),'!=')
				var orders = orderCollectionList.getRecords();
				for(var order in orders){
					total+=order.calculatedTotal;
				}
			}
			
			total += this.getTotal();
            
            var maxAmountAllowedToSpendDuringInitialEnrollmentPeriod = site.setting("siteMaxAmountAllowedToSpendInInitialEnrollmentPeriod");//200
			//If adding the order item will increase the order to over 200 EU return false  
			if (total > maxAmountAllowedToSpendDuringInitialEnrollmentPeriod){
			    return false; // they already have too much.
			}
	    }
	    return true;
	 }
	 
	 public boolean function getUpgradeOrEnrollmentOrderFlag(){
	 	 
		if (this.getUpgradeFlag()) {
			return true;
		}
		
		if( 
			this.hasMonatOrderType() && 
			ListFindNoCase("motMpEnrollment,motVipEnrollment", this.getMonatOrderType().getTypeCode()) 
		){
			return true;
		}
		
		return false;
	}
	
	//Returns an array of one shipping fulfillment if there is a shipping fulfillment on the order, otherwise it returns an empty array
	public array function getFirstShippingFulfillment(){
		
		if(isNull(variables.firstShippingFulfillmentArray)){
			var shippingFulfillmentArray = [];
			var fulfillments = this.getOrderFulfillments() ?:[];
			for(var fulfillment in fulfillments){
				if(!isNull(fulfillment.getFulfillmentMethod()) && fulfillment.getFulfillmentMethod().getFulfillmentMethodType() =='shipping'){
					arrayAppend(shippingFulfillmentArray, fulfillment);
					break;
				}
			}
			variables.firstShippingFulfillmentArray = shippingFulfillmentArray;
		}
		
		return variables.firstShippingFulfillmentArray;
	}
	
	public boolean function validateActiveStatus(){
		var isValidOrder = false;
		if(
			!isNull(this.getAccount())
			&& (
				this.getAccount().getActiveFlag()
				||	(
						!this.getAccount().getActiveFlag() 
						&& this.getUpgradeOrEnrollmentOrderFlag()
						&& !isNull(this.getAccount().getAccountStatusType())
						&& this.getAccount().getAccountStatusType().getSystemCode() == 'astEnrollmentPending'
					)
				)
			)
		{
			isValidOrder = true;
		}
		
		return isValidOrder;
	}//CUSTOM FUNCTIONS END
}
