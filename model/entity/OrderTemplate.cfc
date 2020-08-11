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
	property name="orderTemplateNumber" ormtype="integer";
	property name="scheduleOrderNextPlaceDateTime" ormtype="timestamp";
	property name="scheduleOrderDayOfTheMonth" ormtype="integer";
	property name="addToEntityQueueFlag" ormtype="boolean" default="false";
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
	property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID" hb_populateEnabled="workflow";
	
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
	property name="calculatedDiscountTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedFulfillmentTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedTaxableAmountTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedFulfillmentDiscount" ormtype="big_decimal" hb_formatType="currency";

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
	property name="discountTotal" persistent="false";
	property name="statusCode" persistent="false";
	property name="typeCode" persistent="false";
	property name="total" persistent="false" hb_formatType="currency";
	

	public any function getOrderTemplateNumber(){
		if(!getNewFlag() && !structKeyExists(variables,'orderTemplateNumber') && !isNull(this.getOrderTemplateStatusType()) && this.getOrderTemplateStatusType().getSystemCode() == 'otstActive'){
			var maxOrderTemplateNumberQuery = new query();
			maxOrderTemplateNumberQuery.setSQL('insert into swordertemplatenumber (orderTemplateID,createdDateTime) VALUES (:orderTemplateID,:createdDateTime)');
			maxOrderTemplateNumberQuery.addParam(name="orderTemplateID",value=this.getOrderTemplateID());
			maxOrderTemplateNumberQuery.addParam(name="createdDateTime",value=now(),cfsqltype="cf_sql_timestamp" );
			variables.orderTemplateNumber = maxOrderTemplateNumberQuery.execute().getPrefix().generatedKey;
		}
	
		if(!isNull(variables.orderTemplateNumber)){
			return variables.orderTemplateNumber;
		}
	}
	public string function getEncodedJsonRepresentation(string nonPersistentProperties='calculatedSubTotal,calculatedFulfillmentTotal,calculatedFulfillmentDiscount,calculatedTotal'){ 
		return getService('hibachiUtilityService').hibachiHTMLEditFormat(serializeJson(getStructRepresentation(arguments.nonPersistentProperties)));
	} 
	
	public struct function getStructRepresentation(string nonPersistentProperties='calculatedSubTotal,calculatedFulfillmentTotal,calculatedFulfillmentDiscount,calculatedTotal', string persistentProperties=''){ 
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
		shippingMethodCollection.addFilter('shippingMethodID',this.getSite().setting('siteOrderTemplateEligibleShippingMethods'),'in'); 
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
	
	public numeric function getDiscountTotal(){
		if(!structKeyExists(variables, 'discountTotal')){
			variables.discountTotal = getService('orderService').getOrderTemplateDiscountTotal(this);
		}
		return variables.discountTotal; 
	}

	public numeric function getTaxableAmountTotal() {
		if(!structKeyExists(variables, 'taxableAmountTotal')){
			variables.taxableAmountTotal = getService('OrderService').getTaxableAmountTotalForOrderTemplate(this); 
		}
		return variables.taxableAmountTotal;
	}

	public numeric function getTotal(){ 
		if(!structKeyExists(variables, 'total')){
			variables.total = getService('orderService').getOrderTemplateTotal(this);
		}
		return variables.total; 
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
	
	public numeric function getOrderTemplateItemsCount(){
		if(!structKeyExists(variables, 'orderTemplateItemsCount')){
			var count = 0;
			var orderTemplateItems = this.getOrderTemplateItems() ?: [];
			for(var item in orderTemplateItems){
				count += item.getQuantity();
			}
			variables.orderTemplateItemsCount = count;
		}
		
		return variables.orderTemplateItemsCount;
	}
	
}
