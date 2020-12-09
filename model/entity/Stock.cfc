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
component displayname="Stock" entityname="SlatwallStock" table="SwStock" persistent="true" accessors="true" output="false" hb_permission="this" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="stockService" {

	// Persistent Properties
	property name="stockID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="minQuantity" ormtype="integer" default="0";
	property name="maxQuantity" ormtype="integer" default="0";
	property name="averageCost" ormtype="big_decimal"  hb_formatType="currency";
	property name="averageLandedCost" ormtype="big_decimal"  hb_formatType="currency";

	// Related Object Properties (many-to-one)
	property name="location" fieldtype="many-to-one" fkcolumn="locationID" cfc="Location";
	property name="sku" fieldtype="many-to-one" fkcolumn="skuID" cfc="Sku" hb_cascadeCalculate="true"; // We always want sku when we get a stock

	// Related Object Properties (one-to-many). Including this property to allow HQL to do  stock -> vendorOrderItem lookups
	property name="vendorOrderItems" singularname="vendorOrderItem" cfc="VendorOrderItem" fieldtype="one-to-many" fkcolumn="stockID" inverse="true";
	property name="inventory" singularname="inventory" cfc="Inventory" fieldtype="one-to-many" fkcolumn="stockID" inverse="true" lazy="extra";
	property name="fulfillmentBatchItems" singularname="fulfillmentBatchItem" fieldType="one-to-many" type="array" fkColumn="stockID" cfc="FulfillmentBatchItem" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="stockID" cascade="all-delete-orphan" inverse="true";
	//Calculated Properties
	property name="calculatedQATS" ormtype="float";
	property name="calculatedQOH" ormtype="float";
	property name="calculatedQNC" ormtype="float";
	property name="calculatedQOQ" ormtype="float";
	property name="calculatedCurrentMargin" ormtype="big_decimal" hb_formatType="percentage";
	property name="calculatedCurrentLandedMargin" ormtype="big_decimal" hb_formatType="percentage";
	property name="calculatedCurrentAssetValue" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedAveragePriceSold" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedAverageMarkup" ormtype="big_decimal" hb_formatType="percentage";
	property name="calculatedAverageLandedMarkup" ormtype="big_decimal" hb_formatType="percentage";
	property name="calculatedAverageProfit" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedAverageLandedProfit" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedAveragePriceSoldAfterDiscount" column="calcAvgPriceSoldBeforeDiscount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedAverageDiscountAmount" column="calcAvgDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedCurrentSkuPrice" ormtype="big_decimal" hb_formatType="currency";
	
	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="currentMargin" persistent="false" hb_formatType="percentage";
	property name="currentLandedMargin" persistent="false" hb_formatType="percentage";
	property name="currentAssetValue" persistent="false" hb_formatType="currency";
	//property name="currentRevenueTotal" persistent="false" hb_formatType="currency";
	property name="averagePriceSold" persistent="false" hb_formatType="currency";
	property name="averagePriceSoldAfterDiscount" persistent="false" hb_formatType="currency";
	property name="averageDiscountAmount" persistent="false" formatType="currency";
	property name="averageMarkup" persistent="false" hb_formatType="percentage";
	property name="averageLandedMarkup" persistent="false" hb_formatType="percentage";
	property name="averageProfit" persistent="false" hb_formatType="currency";
	property name="averageLandedProfit" persistent="false" hb_formatType="currency";
	property name="currentSkuPrice" persistent="false" hb_formatType="currency";

	property name="QATS" persistent="false";
	property name="QOH" persistent="false";
	property name="QNC" persistent="false";
	property name="QOQ" persistent="false";

	//Derived Properties
	//property name="derivedQOH" formula="select COALESCE( SUM(inventory.quantityIn), 0 ) - COALESCE( SUM(inventory.quantityOut), 0 ) from swInventory as inventory where inventory.stockID= stockID";
	//Simple
	
	public string function getSimpleRepresentation() {
		var representation = "";
	
		if(!isNull(getSku().getSkuCode())) {
			representation = getSku().getSkuCode();
		} 
 		
		if(!isnull(getLocation()) && len(getLocation().getLocationName())) {
			representation &= " - " & getLocation().getLocationName();
		}
		
		return representation;
	}
	
	public any function getSkuLocationQuantity(){
		if( !isNull(getLocation()) ) {
			return getService('InventoryService').getSkuLocationQuantityBySkuIDANDLocationID(getSku().getSkuID(), getLocation().getLocationID());
		} else {
			return new('SkuLocationQuantity');
		}
	}
	
	// Quantity
	public numeric function getQuantity(required string quantityType) {
		if( !structKeyExists(variables, arguments.quantityType) ) {
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA,QDOO", arguments.quantityType)) {
				return getSku().getQuantity(quantityType=arguments.quantityType, stockID=this.getStockID());
			} else if(listFindNoCase("MQATSBOM,QC,QE,QNC,QATS,QIATS,QOQ", arguments.quantityType)) {
				variables[ arguments.quantityType ] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
		}
		return variables[ arguments.quantityType ];
	}

	public void function updateAverageCost(required numeric newCost, required numeric newQuantity){
		var currentQOH = val(getQOH());
		var currentAverageCost = val(getAverageCost());
		if((currentQOH + newQuantity) > 0){
			variables.averageCost = ( ( currentAverageCost * currentQOH ) + ( newCost * newQuantity ) ) / ( currentQOH + newQuantity);
		}
	}

	public void function updateAverageLandedCost(required numeric newLandedCost, required numeric newQuantity, required numeric newShippingCost){
		var currentQOH = val(getQOH());
		var currentAverageLandedCost = val(getAverageLandedCost());
		if((currentQOH + newQuantity) > 0){
			variables.averageLandedCost = ( ( currentAverageLandedCost * currentQOH ) + ( newLandedCost * newQuantity ) + newShippingCost ) / ( currentQOH + newQuantity);
		}
	}

	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getAverageDiscountAmount(required string currencyCode="USD"){
		return getDao('stockDao').getAverageDiscountAmount(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getAveragePriceSoldAfterDiscount(required string currencyCode="USD"){
		return getDao('stockDao').getAveragePriceSoldAfterDiscount(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getAverageProfit(required string currencyCode="USD"){
		return getDao('stockDao').getAverageProfit(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getAverageLandedProfit(required string currencyCode="USD"){
		return getDao('stockDao').getAverageLandedProfit(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getAverageMarkup(required string currencyCode="USD"){
		return getDao('stockDao').getAverageMarkup(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getAverageLandedMarkup(required string currencyCode="USD"){
		return getDao('stockDao').getAverageLandedMarkup(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getCurrentMargin(required string currencyCode="USD"){
		return getDao('stockDao').getCurrentMargin(this.getStockID(),arguments.currencyCode);
	}
	
	public numeric function getCurrentLandedMargin(required string currencyCode="USD"){
		return getDao('stockDao').getCurrentLandedMargin(this.getStockID(),arguments.currencyCode);
	}

	public numeric function getCurrentSkuPrice() {
	    var currencyCode = "USD";
	    
	    //Find it on the location.
	    if (!isNull(getLocation()) && !isNull(getLocation().getCurrencyCode())){
	        var currencyCode = getLocation().getCurrencyCode();
	    }
	    if (currencyCode != getSku().getCurrencyCode()) {
	        var currentSkuPrice = getSku().getPriceByCurrencyCode(currencyCode = currencyCode, quantity=1);    
	    }else{
	        var currentSkuPrice = getSku().getPrice();
	    }
		return currentSkuPrice;
	}
	
	
	/*
	public numeric function getAverageCost(required string currencyCode="USD"){
		return getDao('stockDao').getAverageCost(this.getStockID(),arguments.currencyCode);
	}
	
	
	public numeric function getAverageLandedCost(required string currencyCode="USD"){
		return getDao('stockDao').getAverageLandedCost(this.getStockID(),arguments.currencyCode);
	}
	*/
	
	public numeric function getCurrentAssetValue(required string currencyCode="USD"){
		return getQOH() * getAverageCost();
	}

//	public numeric function getCurrentRevenueTotal(){
//		return getQuantity('QDOO') * getAveragePriceSold();
//	}

	public numeric function getAveragePriceSold(required string currencyCode="USD"){
		return getDao('stockDao').getAveragePriceSold(this.getStockID(),arguments.currencyCode);
	}
	
	public any function getQOQ() {
		return getQuantity("QOQ");
	}

	public any function getQATS() {
		return getQuantity("QATS");
	}

	public any function getQOH() {
		return getQuantity("QOH");
	}

	public any function getQNC() {
		return getQuantity("QNC");
	}

	public boolean function getLocationIsLeafNode(){
		return getLocation().getChildLocationsCount() == 0;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Vendor Order Items (one-to-many)
	public void function addVendorOrderItem(required any vendorOrderItem) {
		arguments.vendorOrderItem.setStock( this );
	}
	public void function removeVendorOrderItem(required any vendorOrderItem) {
		arguments.vendorOrderItem.removeStock( this );
	}
	
	// Fulfillment Batches (one-to-many)
	public void function addFulfillmentBatchItem(required any fulfillmentBatchItem) {
	   arguments.fulfillmentBatchItem.setStock(this);
	}
	public void function removeFulfillmentBatchItem(required any fulfillmentBatchItem) {
	   arguments.fulfillmentBatchItem.removeStock(this);
	}
	
	public void function updateCalculatedProperties(boolean runAgain=false) {
 		if(!structKeyExists(variables, "calculatedUpdateRunFlag") || runAgain) {
 			super.updateCalculatedProperties(argumentCollection=arguments);
			ormflush();
 			getService("stockService").processStock(this, "updateInventoryCalculationsForLocations");
 		}
 	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================	
	
}
