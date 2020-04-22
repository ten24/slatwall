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
component displayname="OrderTemplate" entityname="SlatwallOrderTemplate" table="SwOrderTemplate" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this" hb_processContexts="create,updateBilling,updateShipping,updateSchedule,addOrderTemplateItem,addPromotionCode,removePromotionCode,cancel,batchCancel,updateCalculatedProperties" {

	// Persistent Properties
	property name="orderTemplateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderTemplateName" ormtype="string" hb_populateEnabled="public";
	property name="scheduleOrderNextPlaceDateTime" ormtype="timestamp";
	property name="scheduleOrderDayOfTheMonth" ormtype="integer";
	property name="scheduleOrderProcessingFlag" ormtype="boolean" default="false";
	property name="currencyCode" ormtype="string" length="3";
	property name="canceledDateTime" ormtype="timestamp";
	property name="lastOrderPlacedDateTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="orderTemplateType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTemplateTypeID";
	property name="orderTemplateStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTemplateStatusTypeID";
	property name="frequencyTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="frequencyTermID" hb_formFieldType="select";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountPaymentMethod"  hb_populateEnabled="public" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID"; 
	property name="billingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="billingAccountAddressID";
	property name="shippingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="shippingAccountAddressID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	//order created for applying promos ahead of scheduled order placement
	property name="temporaryOrder" cfc="Order" fieldtype="many-to-one" fkcolumn="temporaryOrderID";
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID";
	property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
	
	// Related Object Properties (one-to-many)
	property name="orderTemplateItems" hb_populateEnabled="public" singularname="orderTemplateItem" cfc="OrderTemplateItem" fieldtype="one-to-many" fkcolumn="orderTemplateID" cascade="all-delete-orphan" inverse="true" hb_cascadeCalculate="true";
	property name="orders" singularname="order" cfc="Order" fieldtype="one-to-many" fkcolumn="orderTemplateID" inverse="true";
	property name="orderTemplateScheduleDateChangeReasons" singularname="orderTemplateScheduleDateChangeReason" cfc="OrderTemplateScheduleDateChangeReason" fieldtype="one-to-many" fkcolumn="orderTemplateID" inverse="true";
	property name="orderTemplateAppliedGiftCards" singularname="orderTemplateAppliedGiftCard" cfc="OrderTemplateAppliedGiftCard" fieldtype="one-to-many" fkcolumn="orderTemplateID";
	property name="orderTemplateCancellationReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTemplateCancellationReasonTypeID";
	property name="orderTemplateCancellationReasonTypeOther" ormtype="string";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="orderTemplateID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many)
	property name="promotionCodes" singularname="promotionCode" cfc="PromotionCode" fieldtype="many-to-many" linktable="SwOrderTemplatePromotionCode" fkcolumn="orderTemplateID" inversejoincolumn="promotionCodeID";
	
	// Calculated Properties
	property name="calculatedOrderTemplateItemsCount" ormtype="integer";
	property name="calculatedTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedSubTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedFulfillmentTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTaxableAmountTotal" ormtype="big_decimal" hb_formatType="currency";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	property name="fulfillmentDiscount" persistent="false";
	property name="fulfillmentTotal" persistent="false";
	property name="taxableTotal" persistent="false";
	property name="canPlaceOrderFlag" persistent="false";
	property name="canPlaceFutureScheduleOrderFlag" persistent="false";
	property name="orderTemplateItemDetailsHTML" persistent="false";
	property name="orderTemplateScheduleDateChangeReasonTypeOptions" persistent="false";
	property name="orderTemplateCancellationReasonTypeOptions" persistent="false";
	property name="promotionalRewardSkuCollectionConfig" persistent="false"; 
	property name="promotionalFreeRewardSkuCollectionConfig" persistent="false"; 
	property name="encodedPromotionalRewardSkuCollectionConfig" persistent="false"; 
	property name="encodedPromotionalFreeRewardSkuCollectionConfig" persistent="false"; 
	property name="scheduledOrderDates" persistent="false";
	property name="shippingMethodOptions" persistent="false"; 
	property name="subtotal" persistent="false";
	property name="statusCode" persistent="false";
	property name="typeCode" persistent="false";
	property name="total" persistent="false" hb_formatType="currency";
	
	//CUSTOM PROPERTIES BEGIN
property name="lastSyncedDateTime" ormtype="timestamp";
	
	//calculated properties
	property name="calculatedCommissionableVolumeTotal" ormtype="integer";
	property name="calculatedPersonalVolumeTotal" ormtype="integer";
	property name="calculatedProductPackVolumeTotal" ormtype="integer";
	property name="calculatedRetailCommissionTotal" ormtype="integer"; 
	property name="calculatedTaxTotal" ormtype="big_decimal" hb_formatType="currency"; 
	property name="calculatedVatTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedFulfillmentHandlingFeeTotal" ormtype="big_decimal" hb_formatType="currency"; 
	
	//non-persistents
	property name="accountIsNotInFlexshipCancellationGracePeriod" persistent="false";
	property name="lastGeneratedDateTime" ormtype="timestamp";
	property name="deletedDateTime" ormtype="timestamp";
	property name="canceledCode" ormtype="string";
	property name="lastOrderNumber" ormtype="string";
	property name="priceLevelCode" ormtype="string";
	property name="flexshipStatusCode" ormtype="string";
	property name="addressValidationCode" ormtype="string";
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="purchasePlusTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false";
	property name="productPackVolumeTotal" persistent="false"; 
	property name="retailCommissionTotal" persistent="false";
	property name="flexshipQualifiedOrdersForCalendarYearCount" persistent="false"; 
	property name="flexshipQualifiedOrdersForCalendarYearCount" persistent="false"; 
	property name="qualifiesForOFYProducts" persistent="false";
	property name="cartTotalThresholdForOFYAndFreeShipping" persistent="false";
	property name="appliedPromotionMessagesJson" persistent="false"; 
	property name="taxTotal" persistent="false" hb_formatType="currency"; 
	property name="vatTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentHandlingFeeTotal" persistent="false" hb_formatType="currency";
	
//CUSTOM PROPERTIES END
	public string function getEncodedJsonRepresentation(string nonPersistentProperties='subtotal,fulfillmentTotal,fulfillmentDiscount,total'){ 
		return getService('hibachiUtilityService').hibachiHTMLEditFormat(serializeJson(getStructRepresentation(arguments.nonPersistentProperties)));
	} 
	
	public struct function getStructRepresentation(string nonPersistentProperties='subtotal,fulfillmentTotal,fulfillmentDiscount,total', string persistentProperties=''){ 
		var properties = listAppend(getDefaultPropertyIdentifiersList(), arguments.persistentProperties); 

		var orderTemplateStruct = super.getStructRepresentation(properties);

		var propertiesToDisplay = listToArray(arguments.nonPersistentProperties);

		for(var property in propertiesToDisplay){
			orderTemplateStruct[property] = invokeMethod('get' & property);
		} 

		return orderTemplateStruct;  
	} 

	public string function getStatusCode() {
		if(!isNull(getOrderTemplateStatusType())){
			return getOrderTemplateStatusType().getSystemCode();
		}
	}

	public string function getTypeCode() {
		if(!isNull(getOrderTemplateType()) ){
			return getOrderTemplateType().getSystemCode();
		}
	}

	public any function getShippingMethodOptions(){
		var shippingMethodCollection = getService('ShippingService').getShippingMethodCollectionList();
		shippingMethodCollection.setDisplayProperties('shippingMethodName|name,shippingMethodID|value'); 
		shippingMethodCollection.addFilter('shippingMethodID',setting('orderTemplateEligibleShippingMethods'),'in'); 
		return shippingMethodCollection.getRecords();
	}
	
	public boolean function getCanPlaceOrderFlag(){
		if(!structKeyExists(variables, 'canPlaceOrderFlag')){
			variables.canPlaceOrderFlag = getService('OrderService').getOrderTemplateCanBePlaced(this);
		} 
		return variables.canPlaceOrderFlag;
	}

	public struct function getPromotionalRewardSkuCollectionConfig(){
		if(!structKeyExists(variables, 'promotionalRewardSkuCollectionConfig')){
			variables.promotionalRewardSkuCollectionConfig = getService('OrderService').getPromotionalRewardSkuCollectionConfigForOrderTemplate(this);	
		} 
		return variables.promotionalRewardSkuCollectionConfig; 	
	}

	public struct function getPromotionalFreeRewardSkuCollectionConfig(){
		if(!structKeyExists(variables, 'promotionalRewardSkuCollectionConfig')){
			variables.promotionalFreeRewardSkuCollectionConfig = getService('OrderService').getPromotionalFreeRewardSkuCollectionConfigForOrderTemplate(this);	
		} 
		return variables.promotionalFreeRewardSkuCollectionConfig; 	
	}

	public string function getEncodedPromotionalRewardSkuCollectionConfig(){
		if(!structKeyExists(variables, 'encodedPromotionalRewardSkuCollectionConfig')){
			variables.encodedPromotionalRewardSkuCollectionConfig = getService('hibachiUtilityService').hibachiHTMLEditFormat(serializeJson(getPromotionalRewardSkuCollectionConfig()));  
		} 
		return variables.encodedPromotionalRewardSkuCollectionConfig; 	
		
	}

	public string function getEncodedPromotionalFreeRewardSkuCollectionConfig(){
		if(!structKeyExists(variables, 'encodedPromotionalFreeRewardSkuCollectionConfig')){
			variables.encodedPromotionalFreeRewardSkuCollectionConfig = getService('hibachiUtilityService').hibachiHTMLEditFormat(serializeJson(getPromotionalFreeRewardSkuCollectionConfig()));  
		} 
		return variables.encodedPromotionalFreeRewardSkuCollectionConfig; 	
		
	}	

	public boolean function getCanPlaceFutureScheduleOrderFlag(){ 
		if(!structKeyExists(variables, 'canPlaceFutureScheduleOrderFlag')){
			variables.canPlaceFutureScheduleOrderFlag = true;
			if(
				!setting('orderTemplateCanPlaceFutureScheduleDateFlag') && 
				!isNull(getHibachiScope().getAccount()) && 
				getHibachiScope().getAccount().getAdminAccountFlag()	
			){
				variables.canPlaceFutureScheduleOrderFlag = dateCompare(now(), getScheduleOrderNextPlaceDateTime()) > -1; 
			} 
		}
		return variables.canPlaceFutureScheduleOrderFlag;
	}  

	public numeric function getFulfillmentDiscount() {
		if(!structKeyExists(variables, 'fulfillmentDiscount')){
			variables.fulfillmentDiscount = getService('OrderService').getFulfillmentDiscountForOrderTemplate(this); 
		}
		return variables.fulfillmentDiscount;
	}

	public numeric function getFulfillmentTotal() {
		if(!structKeyExists(variables, 'fulfillmentTotal')){
			variables.fulfillmentTotal = getService('OrderService').getFulfillmentTotalForOrderTemplate(this); 
		}
		return variables.fulfillmentTotal;
	}

	public numeric function getSubtotal(){
		if(!structKeyExists(variables, 'subtotal')){
			variables.subtotal = getService('orderService').getOrderTemplateSubtotal(this);
		}
		return variables.subtotal; 
	}

	public numeric function getTaxableAmountTotal() {
		if(!structKeyExists(variables, 'taxableAmountTotal')){
			variables.taxableAmountTotal = getService('OrderService').getTaxableAmountTotalForOrderTemplate(this); 
		}
		return variables.taxableAmountTotal;
	}

	public numeric function getTotal(){ 
		return this.getSubtotal() + this.getFulfillmentTotal(); 
	} 

	public any function getDefaultCollectionProperties(string includesList = "orderTemplateID,orderTemplateName,account.accountID,account.firstName,account.lastName,account.primaryEmailAddress.emailAddress,createdDateTime,calculatedTotal,currencyCode,scheduleOrderNextPlaceDateTime,site.siteName,account.accountNumber", string excludesList=""){
		arguments.includesList = listAppend(arguments.includesList, 'orderTemplateStatusType.systemCode'); 
		return super.getDefaultCollectionProperties(argumentCollection=arguments);
	}

	public any function getOrderTemplateScheduleDateChangeReasonTypeOptions(){
		if(!structKeyExists(variables, 'orderTemplateScheduleDateChangeReasonTypeOptions')){	
			var typeCollection = getService('TypeService').getTypeCollectionList(); 
			typeCollection.setDisplayProperties('systemCode,typeDescription|name,typeID|value');
			typeCollection.addFilter('parentType.systemCode','orderTemplateScheduleDateChangeReasonType');
			typeCollection.addOrderBy('sortOrder'); 
			variables.orderTemplateScheduleDateChangeReasonTypeOptions = typeCollection.getRecords(); 
		}
		return variables.orderTemplateScheduleDateChangeReasonTypeOptions;  
	}

	public any function getOrderTemplateCancellationReasonTypeOptions(){
		if(!structKeyExists(variables, 'orderTemplateCancellationReasonTypeOptions')){
			var typeCollection = getService('TypeService').getTypeCollectionList(); 
			typeCollection.setDisplayProperties('systemCode,typeDescription|name,typeID|value'); 
			typeCollection.addFilter('parentType.systemCode','orderTemplateCancellationReasonType');
			typeCollection.addOrderBy('sortOrder'); 
			variables.orderTemplateCancellationReasonTypeOptions = typeCollection.getRecords(); 
		}
		return variables.orderTemplateCancellationReasonTypeOptions;
	} 

	public string function getScheduledOrderDates(numeric iterations = 5){
		
		var scheduledOrderDates = DateFormat(this.getScheduleOrderNextPlaceDateTime(), 'mm/dd/yyyy'); 
		var currentDate = this.getScheduleOrderNextPlaceDateTime();  

		arguments.iterations--;

		for(var i=1; i <= arguments.iterations; i++){
			currentDate = DateFormat(this.getFrequencyTerm().getEndDate(currentDate), 'mm/dd/yyyy');
			scheduledOrderDates = listAppend(scheduledOrderDates, currentDate); 	
		}

		return replaceNoCase(scheduledOrderDates,',',', ', 'all');
	}

	public array function getFrequencyTermOptions(){
		return getService("OrderService").getOrderTemplateFrequencyTermOptions();
	} 
	
	public array function getFrequencyDateOptions() {
		getService('OrderService').getOrderTemplateFrequencyDateOptions();
	}

	// Account (many-to-one)
	public any function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasOrderTemplate( this )) {
			arrayAppend(arguments.account.getOrderTemplates(), this);
		}
		return this;
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getOrderTemplates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getOrderTemplates(), index);
		}
		structDelete(variables, "account");
	}	

	// Account Payment Method(many-to-one)
	public any function setAccountPaymentMethod(required any accountPaymentMethod) {
		variables.accountPaymentMethod = arguments.accountPaymentMethod;
		if(isNew() or !arguments.accountPaymentMethod.hasOrderTemplate( this )) {
			arrayAppend(arguments.accountPaymentMethod.getOrderTemplates(), this);
		}
		return this;
	}
	public void function removeAccountPaymentMethod(any accountPaymentMethod) {
		if(!structKeyExists(arguments, "accountPaymentMethod")) {
			arguments.accountPaymentMethod = variables.accountPaymentMethod;
		}
		var index = arrayFind(arguments.accountPaymentMethod.getOrderTemplates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.accountPaymentMethod.getOrderTemplates(), index);
		}
		structDelete(variables, "accountPaymentMethod");
	}

	// Order Template Items (one-to-many)
	public void function addOrderTemplateItem(required any orderTemplateItem) {
		arguments.orderTemplateItem.setOrderTemplate( this );
	}
	public void function removeOrderItem(required any orderItem) {
		arguments.orderItem.removeOrder( this );
	}
	
	// AttributeValues (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setOrderTemplate( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeOrderTemplate( this );
	}


	//Email Template Helpers
	public string function getOrderTemplateItemDetailsHTML(){
		var html = "<ul>";

		var columnConfig = {
			'arguments': {
				'currencyCode': this.getCurrencyCode(),
				'accountID': this.getAccount().getAccountID()
			}
		}

		var orderTemplateItemCollection = this.getOrderTemplateItemsCollectionList();
		orderTemplateItemCollection.setDisplayProperties('sku.skuCode, sku.skuDefinition, sku.priceByCurrencyCode, quantity', columnConfig);
		var orderTemplateItems = orderTemplateItemCollection.getRecords(formatRecords=false);

		for( var orderTemplateItem in orderTemplateItems ){
			html &= "<li>";
			
			html &= orderTemplateItem['sku_skuCode'] & ' - ';
			html &= orderTemplateItem['sku_skuDefinition'];
			
			html &= ' ' & rbKey('define.price') & ': ';
			html &= orderTemplateItem['sku_priceByCurrencyCode'];
			
			html &= ' ' & rbKey('define.quantity') & ': ';
			html &= orderTemplateItem['quantity'];
			
			html &= "</li>";
		} 

		html &= "</ul>";

		return getHibachiScope().hibachiHTMLEditFormat(html); 
	}

	
	//CUSTOM FUNCTIONS BEGIN

public boolean function getAccountIsNotInFlexshipCancellationGracePeriod(){
		if(	getHibachiScope().getAccount().getAdminAccountFlag() ){
			return true;
		}

		if(!structKeyExists(variables, "accountIsNotInFlexshipCancellationGracePeriod")){
			variables.accountIsNotInFlexshipCancellationGracePeriod = true;
			
			if( !IsNull(this.getAccount()) && this.getAccount().getAccountType() == 'MarketPartner' ){
				
				variables.accountIsNotInFlexshipCancellationGracePeriod = !getService("OrderService")
														.getAccountIsInFlexshipCancellationGracePeriod( this );
			}
		}
		
		return variables.accountIsNotInFlexshipCancellationGracePeriod;
	}

	public numeric function getPersonalVolumeTotal(){
	
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = getService('OrderService').getPersonalVolumeTotalForOrderTemplate(this);

		}	
		return variables.personalVolumeTotal; 	
	}

	public numeric function getCommissionableVolumeTotal(){
		
		if(!structKeyExists(variables, 'commissionableVolumeTotal')){
			variables.commissionableVolumeTotal = getService('OrderService').getCommissionableVolumeTotalForOrderTemplate(this);	
		}	
		return variables.commissionableVolumeTotal;
	} 
	
	public numeric function getPurchasePlusTotal(){
		if(!structKeyExists(variables, 'purchasePlusTotal')){
			variables.purchasePlusTotal = getService('OrderService').getPurchasePlusTotalForOrderTemplate(this);	
		}	
		return variables.purchasePlusTotal;
	} 

	public numeric function getProductPackVolumeTotal(){
		
		if(!structKeyExists(variables, 'productPackVolumeTotal')){
			variables.productPackVolumeTotal = getService('OrderService').getProductPackVolumeTotalForOrderTemplate(this);	
		}	
		return variables.productPackVolumeTotal;
	} 

	public numeric function getFlexshipQualifiedOrdersForCalendarYearCount(){

		if(!structKeyExists(variables, 'flexshipQualifiedOrdersForCalendarYearCount')){
			var orderCollection = getService('OrderService').getOrderCollectionList(); 
			orderCollection.setDisplayProperties('orderID'); 
			orderCollection.addFilter('orderTemplate.orderTemplateID', this.getOrderTemplateID());
			
			var currentYear = year(now()); 

			orderCollection.addFilter('orderCloseDateTime', createDateTime(currentYear, '1', '1', 0, 0, 0),'>=');
			orderCollection.addFilter('orderCloseDateTime', createDateTime(currentYear, '12', '31', 0, 0, 0),'<=');

			orderCollection.addFilter('orderStatusType.typeCode', '5'); //Shipped status can't use ostClosed because of returns

			variables.flexshipQualifiedOrdersForCalendarYearCount = orderCollection.getRecordsCount(); 	
		} 
		return variables.flexshipQualifiedOrdersForCalendarYearCount; 
	}  

	public numeric function getCartTotalThresholdForOFYAndFreeShipping(){
		if(!structKeyExists(variables, 'cartTotalThresholdForOFYAndFreeShipping')){
			
			if(!isNull(this.getAccount()) && this.getAccount().getAccountType() == 'MarketPartner') {
				variables.cartTotalThresholdForOFYAndFreeShipping =  this.getSite().setting('integrationmonatSiteMinCartTotalAfterMPUserIsEligibleForOFYAndFreeShipping');
			} else {
				variables.cartTotalThresholdForOFYAndFreeShipping =  this.getSite().setting('integrationmonatSiteMinCartTotalAfterVIPUserIsEligibleForOFYAndFreeShipping');
			}
		}	
		return variables.cartTotalThresholdForOFYAndFreeShipping;
	}
	
	public boolean function getQualifiesForOFYProducts(){
		
		if(!structKeyExists(variables, 'qualifiesForOFYProducts')) {
			variables.qualifiesForOFYProducts =  getService('OrderService').orderTemplateQualifiesForOFYProducts(this);
		}	
		return variables.qualifiesForOFYProducts;
	}
	
	/**
	 * These next two functions deal with this requirement around the Refer a Friend feature.
	 * As a VIP I may only redeem EITHER an RAF Promo OR RAF Gift Card (limited to the value of one credit, per task:  ) 
	 * on the same Flexship. I may not redeem both on the same Flexship.
	 * 
	 * Context:  This scenario would occur in an edge case where a newly referred VIP has earned their Referee Promo and has 
	 * also referred new VIP's themselves, BEFORE they have had the opportunity to use their RAF promo on their first Flexship.  
	 * Thus, resulting in them having both the RAF Promo and balance on their RAF Gift Card.  
	 * They must use their Promo before redeeming their gift card, as the Promo must be used on their 1st Flexship.  
	 * 
	 **/
	public boolean function getHasRafGiftCardAppliedToFlexship(){
		
		for (var appliedGiftCard in variables.orderTemplateAppliedGiftCards){
			if (appliedGiftCard.getGiftCard().getSku().getSkuCode() == "raf-gift-card-1"){
				return true;
			}
		}
		
		return false;
	}
	
	public boolean function getHasRafPromoAppliedToFlexship(){
		for (var promoCode in variables.promotionCodes){
			if (promoCode.getPromotion().getPromotionName() == "Monat - Refer A Friend"){
				return true;
			}
		}
		
		return false;
	}
	
	public boolean function hasRafPromoOrGiftCardButNotBoth(){ 
		
		//This only applied to VIP accounts
		if (!isVIP()){
			return true;
		}
		
		var hasGiftCard = getHasRafGiftCardAppliedToFlexship();
		var hasPromo = getHasRafPromoAppliedToFlexship();
		
		//Has either gift card or promo is fine.
		if (!hasGiftCard && !hasPromo){
		
			return true;
		}
		
		//Has a gift card and no promo is fine.
		if (hasGiftCard && !hasPromo){
			return true;
		}
		
		//Has a promo and no gift card is also fine.
		if (hasPromo && !hasGiftCard){
			return true;
		}
		
		return false;
		
	}
	
	public boolean function isVIP(){
		if (!isNull(this.getAccount()) && !isNull(this.getAccount().getAccountType())){
			return this.getAccount().getAccountType() == "VIP";
		}
		return false;
	}
	
	public struct function getListingSearchConfig() {
	    param name = "arguments.wildCardPosition" default = "exact";
	    
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function userCanCancelFlexship(){
		return getAccount().getAccountType() == 'MarketPartner' || getHibachiScope().getAccount().getAdminAccountFlag();
	}
	
	public any function getappliedPromotionMessagesJson(){
	
		if(!structKeyExists(variables, 'appliedPromotionMessagesJson')){
			variables.appliedPromotionMessagesJson = getService('OrderService').getappliedPromotionMessagesJsonForOrderTemplate(this);
		}	
		
		return variables.appliedPromotionMessagesJson; 	
	}
	
	public numeric function getTaxTotal(){
	
		if(!structKeyExists(variables, 'taxTotal')){
			variables.taxTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('taxTotal', this);
		}	
		
		return variables.taxTotal; 	
	}
	
	public numeric function getVatTotal(){
	
		if(!structKeyExists(variables, 'vatTotal')){
			variables.vatTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('vatTotal', this);
		}	
		
		return variables.vatTotal; 	
	}
	
	public numeric function getFulfillmentHandlingFeeTotal(){
	
		if(!structKeyExists(variables, 'fulfillmentHandlingFeeTotal')){
			variables.fulfillmentHandlingFeeTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('fulfillmentHandlingFeeTotal', this);
		}	
		
		return variables.fulfillmentHandlingFeeTotal; 	
	}	
	
	public numeric function getFulfillmentTotal(){
	
		if(!structKeyExists(variables, 'fulfillmentTotal')){
			variables.fulfillmentTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('fulfillmentTotal', this);
		}	
		
		return variables.fulfillmentTotal; 	
	}
	//CUSTOM FUNCTIONS END
}
