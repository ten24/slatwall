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
component entityname="SlatwallSubscriptionOrderItem" table="SwSubscriptionOrderItem" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="subscriptionService" {

	// Persistent Properties
	property name="subscriptionOrderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Object Properties (many-to-one)
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	
	property name="subscriptionOrderItemType" cfc="Type" fieldtype="many-to-one" fkcolumn="subscriptionOrderItemTypeID" hb_optionsSmartListData="f:parentType.systemCode=subscriptionOrderItemType";
	property name="subscriptionUsage" cfc="SubscriptionUsage" fieldtype="many-to-one" fkcolumn="subscriptionUsageID" cascade="all";

	// Related Object Properties (one-to-many)
	property name="subscriptionOrderDeliveryItems" singularname="subscriptionOrderDeliveryItem" cfc="SubscriptionOrderDeliveryItem" type="array" fieldtype="one-to-many" fkcolumn="subscriptionOrderItemID" cascade="all-delete-orphan" inverse="true";
	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="deferredRevenue" hb_formatType="currency" persistent="false";
	property name="deferredTaxAmount" persistent="false";
	
	//calculatedProperties
	property name="calculatedDeferredRevenue" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedDeferredTaxAmount" ormtype="big_decimal" hb_formatType="currency";
	
	
	public any function getDeferredRevenue(){
		var deferredRevenue = 0;
		var priceEarnedPerItem = 0;
		if(!isNull(getPriceEarnedPerItem())){
			priceEarnedPerItem = getPriceEarnedPerItem();
		}
		var itemNotDelivered = 0;
		if(!isNull(getItemsNotDelivered())){
			itemsNotDelivered = getItemsNotDelivered();
		}
		deferredRevenue = getService('HibachiUtilityService').precisionCalculate(priceEarnedPerItem * itemsNotDelivered);
	
		return deferredRevenue;
	}
	
	public any function getDeferredTaxAmount(){
		var deferredTaxAmount = 0;
		
		deferredTaxAmount = getService('HibachiUtilityService').precisionCalculate(getTaxAmountEarnedPerItem() * getItemsNotDelivered());
	
		return deferredTaxAmount;
	}
	
	public numeric function getItemsNotDelivered(){
		var itemsNotDelivered = 0;
		
		itemsNotDelivered = getItemsToDeliver() - getItemsDelivered();
		
		return itemsNotDelivered;
	}
	
	public numeric function getTaxAmountEarnedPerItem(){
		var taxAmountEarnedPerItem = 0;
		if(getItemsToDeliver() > 0){
			taxAmountEarnedPerItem = getService('HibachiUtilityService').precisionCalculate(getOrderItem().getCalculatedTaxAmount() / getItemsToDeliver());
		}
		return taxAmountEarnedPerItem;
	}
	
	public numeric function getPriceEarnedPerItem(){
		var priceEarnedPerItem = 0;
		var extendedPriceAfterDiscount = 0;
		if(!isNull(getOrderItem()) && !isNull(getOrderItem().getCalculatedExtendedPriceAfterDiscount())){
			extendedPriceAfterDiscount = getOrderItem().getCalculatedExtendedPriceAfterDiscount();
		}
		if(getItemsToDeliver() > 0){
			priceEarnedPerItem = getService('HibachiUtilityService').precisionCalculate(extendedPriceAfterDiscount / getItemsToDeliver());
		}
		return priceEarnedPerItem;
	}
	
	public numeric function getItemsToDeliver(){
		var itemsToDeliver = 0;
		if(
			!isNull(getSubscriptionUsage())
			&& !isNull(getSubscriptionUsage().getSubscriptionTerm())
			&& !isNull(getSubscriptionUsage().getSubscriptionTerm().getItemsToDeliver())
		){
			itemsToDeliver = this.getSubscriptionUsage().getSubscriptionTerm().getItemsToDeliver();
		}
		return itemsToDeliver;
	}
	
	public numeric function getItemsDelivered(){
		var itemsDelivered = 0;
		for(var subscriptionOrderDeliveryItem in getSubscriptionOrderDeliveryItems()){
			itemsDelivered += subscriptionOrderDeliveryItem.getQuantity();
		}
		return itemsDelivered;
	}
	
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		//copy all the info from order items to subscription usage
		if(!isNull(variables.subscriptionUsage)) {
			variables.subscriptionUsage.copyOrderItemInfo(arguments.orderItem);
		}
	}
	
	//calculates the date ranges that the subscription orderItem started and ended
	
	

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Sunscription Usage (many-to-one)
	public void function setSubscriptionUsage(required any subscriptionUsage) {
		variables.subscriptionUsage = arguments.subscriptionUsage;
		if(isNew() or !arguments.subscriptionUsage.hasSubscriptionOrderItem( this )) {
			arrayAppend(arguments.subscriptionUsage.getSubscriptionOrderItems(), this);
		}
	}
	public void function removeSubscriptionUsage(any subscriptionUsage) {
		if(!structKeyExists(arguments, "subscriptionUsage")) {
			arguments.subscriptionUsage = variables.subscriptionUsage;
		}
		var index = arrayFind(arguments.subscriptionUsage.getSubscriptionOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.subscriptionUsage.getSubscriptionOrderItems(), index);
		}
		structDelete(variables, "subscriptionUsage");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
