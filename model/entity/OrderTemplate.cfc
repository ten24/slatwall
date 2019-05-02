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
component displayname="OrderTemplate" entityname="SlatwallOrderTemplate" table="SwOrderTemplate" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this" hb_processContexts="create,updateBilling,updateShipping,updateSchedule,addOrderTemplateItem,addPromotionCode,removePromotionCode" {

	// Persistent Properties
	property name="orderTemplateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderTemplateName" ormtype="string";
	
	property name="scheduleOrderNextPlaceDateTime" ormtype="timestamp";
	property name="scheduleOrderDayOfTheMonth" ormtype="integer";

	property name="currencyCode" ormtype="string" length="3";

	property name="orderTemplateType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTypeID";
	property name="orderTemplateStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID";
	property name="frequencyTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="frequencyTermID" hb_formFieldType="select";

	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID"; 

	property name="billingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="billingAccountAddressID";
	property name="shippingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="shippingAccountAddressID";

	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";

	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID";

	property name="orderTemplateItems" hb_populateEnabled="public" singularname="orderTemplateItem" cfc="OrderTemplateItem" fieldtype="one-to-many" fkcolumn="orderTemplateID" cascade="all-delete-orphan" inverse="true";

	property name="orders" singularname="order" cfc="Order" fieldtype="one-to-many" fkcolumn="orderTemplateID" inverse="true";
	property name="orderTemplateScheduleDateChangeReasons" singularname="orderTemplateScheduleDateChangeReason" cfc="OrderTemplateScheduleDateChangeReason" fieldtype="one-to-many" fkcolumn="orderTemplateID" inverse="true";
	
	property name="promotionCodes" singularname="promotionCode" cfc="PromotionCode" fieldtype="many-to-many" linktable="SwOrderTemplatePromotionCode" fkcolumn="orderTemplateID" inversejoincolumn="promotionCodeID";

	property name="calculatedTotal" ormtype="big_decimal" hb_formatType="currency";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	property name="orderTemplateScheduleDateChangeReasonTypeOptions" persistent="false";
	property name="lastOrderPlacedDateTime" persistent="false";
	property name="scheduledOrderDates" persistent="false";

	public any function getDefaultCollectionProperties(string includesList = "orderTemplateID,orderTemplateName,account.firstName,account.lastName,account.primaryEmailAddress.emailAddress,createdDateTime,calculatedTotal,scheduleOrderNextPlaceDateTime", string excludesList=""){
		return super.getDefaultCollectionProperties(argumentCollection=arguments);
	}

	public any function getOrderTemplateScheduleDateChangeReasonTypeOptions(){
		if(!structKeyExists(variables, 'orderTemplateScheduleDateChangeReasonTypeOptions')){	
			var typeCollection = getService('TypeService').getTypeCollectionList(); 
			typeCollection.setDisplayProperties('typeDescription|name,typeID|value'); 
			typeCollection.addFilter('parentType.systemCode','orderTemplateScheduleDateChangeReasonType');
			variables.orderTemplateScheduleDateChangeReasonTypeOptions = typeCollection.getRecords(); 
		}
		return variables.orderTemplateScheduleDateChangeReasonTypeOptions;  
	}

	public string function getLastOrderPlacedDateTime(){
		var orderCollectionList = getService('OrderService').getOrderCollectionList();
		orderCollectionList.addDisplayProperty('createdDateTime');  
		orderCollectionList.addFilter('orderTemplate.orderTemplateID', getOrderTemplateID());
		orderCollectionList.addOrderBy('createdDateTime|DESC');
		var records = orderCollectionList.getPageRecords();

		if(!arrayIsEmpty(records)){
			return records[1]['createdDateTime'];
		} else { 
			return '';
		}
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
		var termCollection = getService('SettingService').getTermCollectionList();
		termCollection.setDisplayProperties('termID|value,termName|name');
		termCollection.addFilter('termID', getService('SettingService').getSettingValue('orderTemplateEligibleTerms'),'in');
		return termCollection.getRecords();
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

}
