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
component entityname="SlatwallVendorOrderItem" table="SwVendorOrderItem" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="vendorOrderService" hb_permission="vendorOrder.vendorOrderItems" {

	// Persistent Properties
	property name="vendorOrderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="float" default=0;
	property name="cost" ormtype="big_decimal" hb_formatType="currency";
	property name="price" ormtype="big_decimal" hb_formatType="currency";
	property name="skuPrice" ormtype="big_decimal" hb_formatType="currency" hint="Stores the price of the sku at time of order based on currency code.";

	property name="shippingWeight" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	property name="estimatedReceivalDateTime" ormtype="timestamp";

	// Related Object Properties (Many-to-One)
	property name="vendorOrderItemType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorOrderItemTypeID" hb_optionsSmartListData="f:parentType.systemCode=vendorOrderItemType";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	property name="vendorAlternateSkuCode" cfc="AlternateSkuCode" fieldtype="many-to-one" fkcolumn="vendorAlternateSkuCodeID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";

	// Related Object Properties (One-to-Many)
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="one-to-many" fkcolumn="vendorOrderItemID" cascade="all-delete-orphan" inverse="true";
	property name="vendorOrderDeliveryItems" singularname="vendorOrderDeliveryItem" cfc="VendorOrderDeliveryItem" fieldtype="one-to-many" fkcolumn="vendorOrderItemID" inverse="true" cascade="delete-orphan";
	
	//Calculated Properties
	property name="calculatedQuantityReceived" ormtype="integer";
	property name="calculatedQuantityUnreceived" ormtype="integer";

	
	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-persistent properties
	property name="extendedCost" persistent="false" hb_formatType="currency";
	property name="grossProfitMargin" persistent="false" hb_formatType="percentage";
	property name="extendedWeight" persistent="false";
	property name="quantityReceived" persistent="false";
	property name="quantityUnreceived" persistent="false";
	property name="quantityDelivered" persistent="false";
	property name="quantityUnDelivered" persistent="false";

	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getPrice(){
		if( !structKeyExists(variables,"price") ){
			if(getCurrencyCode() == getSku().getCurrencyCode()){
				variables.price = !isNull(getSku().getPrice()) ? getSku().getPrice() : 0; 
			}else{
				var skuPrice = getSku().getLivePriceByCurrencyCode(getCurrencyCode());
				variables.price = !isNull(skuPrice) ? skuPrice : 0; 
			}
		}
		
		return variables.price;
	}
	
	public numeric function getGrossProfitMargin(){
		if(!isNull(getPrice()) && !isNull(getCost()) && getPrice() > 0){
			return NumberFormat( ( (val(getPrice()) - val(getCost())) / val(getPrice()) ) * 100,'9.99');
		}
		
		return 0;
	}
	

	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getLandingAmountByQuantity(){
		if(!isNull(getVendorOrder()) && !isNull(getQuantity())){
			var totalQuantity = getVendorOrder().getTotalQuantity();
			var percentageOfTotal = 0;
			if(totalQuantity > 0 && getQuantity() > 0){
				percentageOfTotal = getService('hibachiUtilityService').precisionCalculate(getQuantity()/totalQuantity);
			}
			
			return getService('hibachiUtilityService').precisionCalculate(getVendorOrder().getShippingAndHandlingCost() * percentageOfTotal);	
		}
		return 0;
	}
	
	public numeric function getLandingAmountByWeight(){
		if(!isNull(getVendorOrder()) && !isNull(getExtendedWeight())){
			var totalWeight = getVendorOrder().getTotalWeight();
			if(totalWeight==0){
				return 0;
			}
			var percentageOfTotal = getService('hibachiUtilityService').precisionCalculate(getExtendedWeight()/totalWeight);
			return getService('hibachiUtilityService').precisionCalculate(getVendorOrder().getShippingAndHandlingCost() * percentageOfTotal);	
		}
		return 0;
	}
	
	public numeric function getLandingAmountByCost(){
		if(!isNull(getVendorOrder()) && !isNull(getExtendedCost())){
			var totalCost = getVendorOrder().getTotalCost();
			var percentageOfTotal = getService('hibachiUtilityService').precisionCalculate(getExtendedCost()/totalCost);
			return getService('hibachiUtilityService').precisionCalculate(getVendorOrder().getShippingAndHandlingCost() * percentageOfTotal);	
		}
		return 0;
	}

	public numeric function getExtendedCost() {
		if(!isNull(getCost())) {
			return getCost() * getQuantity();
		}
		return 0;

	}
	
	public numeric function getExtendedWeight() {
		if(
			!isNull(getShippingWeight())
		) {
			return getShippingWeight() * getQuantity();
		}
		return 0;
	}

	public numeric function getQuantityReceived() {
		var quantityReceived = 0;

		for( var i=1; i<=arrayLen(getStockReceiverItems()); i++){
			quantityReceived += getStockReceiverItems()[i].getQuantity();
		}

		return quantityReceived;
	}

	public numeric function getQuantityUnreceived() {
		return getQuantity() - getQuantityReceived();
	}
	
	public numeric function getQuantityUnDelivered() {
		return getQuantity() - getQuantityDelivered();
	}
	
	public numeric function getQuantityDelivered() {
		var quantityDelivered = 0;
		var vendorOrderDeliveryItems = getVendorOrderDeliveryItems();
		
		for( var i=1; i<=arrayLen(vendorOrderDeliveryItems); i++){
			quantityDelivered += vendorOrderDeliveryItems[i].getQuantity();
		}

		return quantityDelivered;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Vendor Order (many-to-one)
	public void function setVendorOrder(required any vendorOrder) {
		variables.vendorOrder = arguments.vendorOrder;
		if(isNew() or !arguments.vendorOrder.hasVendorOrderItem( this )) {
			arrayAppend(arguments.vendorOrder.getVendorOrderItems(), this);
		}
	}
	public void function removeVendorOrder(any vendorOrder) {
		if(!structKeyExists(arguments, "vendorOrder")) {
			arguments.vendorOrder = variables.vendorOrder;
		}
		var index = arrayFind(arguments.vendorOrder.getVendorOrderItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrder.getVendorOrderItems(), index);
		}
		structDelete(variables, "vendorOrder");
	}

	// Stock Receiver Items (one-to-many)
	public void function addStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.setVendorOrderItem( this );
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.removeVendorOrderItem( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		var simpleRepresentation = "";
		if(
			!isNull(getStock())
			&& !isNull(getStock().getSku())
			&& !isNull(getStock().getSku().getProduct())
		){
			if(!isNull(getStock().getSku().getProduct().getCalculatedTitle())){
				simpleRepresentation = getStock().getSku().getProduct().getCalculatedTitle();
			}else if(!isNull(getStock().getSku().getProduct().getTitle())){
				simpleRepresentation = getStock().getSku().getProduct().getTitle();
			}
		}
		return simpleRepresentation;
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================

}
