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
component entityname="SlatwallStockAdjustment" table="SwStockAdjustment" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="stockService" hb_permission="this" hb_processContexts="addItems,processAdjustment,addStockAdjustmentItem" {

	// Persistent Properties
	property name="stockAdjustmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="fromLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="fromLocationID";
	property name="toLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="toLocationID";
	property name="stockAdjustmentType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentTypeID" hb_optionsSmartListData="f:parentType.systemCode=stockAdjustmentType";
	property name="stockAdjustmentStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=stockAdjustmentStatusType";
	property name="physical" cfc="Physical" fieldtype="many-to-one" fkcolumn="physicalID";
	
	// Related Object Properties (one-to-many)
	property name="stockAdjustmentItems" singularname="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" inverse="true" cascade="all-delete-orphan";
	property name="stockReceivers" singularname="stockReceiver" cfc="StockReceiver" type="array" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" cascade="all" inverse="true";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="addStockAdjustmentItemSkuOptionsSmartList" persistent="false";
	property name="addStockAdjustmentItemStockOptionsSmartList" persistent="false";
	property name="adjustmentSkuOptions" persistent="false";
	property name="displayName" persistent="false";
	property name="stockAdjustmentStatusTypeSystemCode" persistent="false";
	property name="stockAdjustmentTypeSystemCode" persistent="false";
	
	// Deprecated Properties
	property name="statusCode" persistent="false";		// Use getStockAdjustmentStatusTypeSystemCode()
	
	// For use with Adjustment Items interface, get one location that we will use for stock lookup. 
	public any function getOneLocation() {
		if(getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || getStockAdjustmentType().getSystemCode() == "satManualIn") {
			return getToLocation();
		} else {
			return getFromLocation();
		}
	}
	
	public any function getStockAdjustmentItemForSku(required any sku) {
		return getService("StockService").getStockAdjustmentItemForSku(arguments.sku, this);
	}
	
	// Returns an array of structs, each struct containing a product, and an array of stockAdjustmentItems
	public any function getStockAdjustmentItemsByProduct() {
		var keyByProductId = {};
	
		for(var i=1; i <= ArrayLen(getStockAdjustmentItems()); i++) {
			var product = getStockAdjustmentItems()[i].getOneStock().getSku().getProduct();
			if(structKeyExists(keyByProductId, product.getProductId())) {
				// We already have this product in the array, so simply append the stockAdjustmentItem to the items array
				arrayAppend(keyByProductId[product.getProductId()].stockAdjustmentItems, getStockAdjustmentItems()[i]);
			} else {
				// We did not find the product, so add it to the array
				var struct = {
					product = product, 
					stockAdjustmentItems = [getStockAdjustmentItems()[i]]
				};
				keyByProductId[product.getProductId()] = struct;
			}
		}
		
		// Transform the assocaitive array into an array
		var local.arr = [];
		for (var struct IN keyByProductId) {
			arrayAppend(local.arr, keyByProductId[struct]);
		}

		return local.arr;
	}
	
	public boolean function isNotDeletable() {
		return getStockAdjustmentStatusType().getSystemCode() == "sastClosed";
	}
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getAddStockAdjustmentItemSkuOptionsSmartList() {
		if(!structKeyExists(variables, "addStockAdjustmentItemSkuOptionsSmartList")) {
			variables.addStockAdjustmentItemSkuOptionsSmartList = getService("skuService").getSkuSmartList();
			variables.addStockAdjustmentItemSkuOptionsSmartList.addFilter('activeFlag', 1);
			variables.addStockAdjustmentItemSkuOptionsSmartList.addFilter('product.activeFlag', 1);
		}
		return variables.addStockAdjustmentItemSkuOptionsSmartList;
	}
	
	public any function getAddStockAdjustmentItemStockOptionsSmartList() {
		if(!structKeyExists(variables, "addStockAdjustmentItemStockOptionsSmartList")) {
			variables.addStockAdjustmentItemStockOptionsSmartList = getService("stockService").getStockSmartList();
			variables.addStockAdjustmentItemStockOptionsSmartList.addFilter('location.locationID', getFromLocation().getLocationID());
			variables.addStockAdjustmentItemStockOptionsSmartList.addFilter('sku.activeFlag', 1);
			variables.addStockAdjustmentItemStockOptionsSmartList.addFilter('sku.product.activeFlag', 1);
		}
		return variables.addStockAdjustmentItemStockOptionsSmartList;
	}

	public string function getDisplayName(){
		var displayName = "#getStockAdjustmentType().getTypeName()#:";
		if(!isNull(getFromLocation())) {
			displayName = listAppend(displayName, getFromLocation().getLocationName(), " ");
		}
		if(!isNull(getFromLocation()) && !isNull(getToLocation())) {
			displayName = listAppend(displayName, "-", " ");
		}
		if(!isNull(getToLocation())) {
			displayName = listAppend(displayName, getToLocation().getLocationName(), " ");
		}
		return displayName;
	}
	
	public any function getAdjustmentSkuOptions() {
		if(!structKeyExists(variables, "adjustmentSkuOptions")) {
			variables.adjustmentSkuOptions = getService("skuService").listSku({activeFlag=1}); 
		}
		return variables.adjustmentSkuOptions;
	}
	
	public string function getStockAdjustmentStatusTypeSystemCode() {
		return getStockAdjustmentStatusType().getSystemCode();
	}
	
	public string function getStockAdjustmentTypeSystemCode() {
		return getStockAdjustmentType().getSystemCode();
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Physical (many-to-one)    
	public void function setPhysical(required any physical) {    
		variables.physical = arguments.physical;    
		if(isNew() or !arguments.physical.hasStockAdjustment( this )) {    
			arrayAppend(arguments.physical.getStockAdjustments(), this);    
		}    
	}    
	public void function removePhysical(any physical) {    
		if(!structKeyExists(arguments, "physical")) {    
			arguments.physical = variables.physical;    
		}    
		var index = arrayFind(arguments.physical.getStockAdjustments(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.physical.getStockAdjustments(), index);    
		}    
		structDelete(variables, "physical");    
	}
	
	// Stock Adjustment Items (one-to-many)
	public void function addStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.stockAdjustmentItem.setStockAdjustment( this );
	}
	
	public void function removeStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.stockAdjustmentItem.removeStockAdjustment( this );
	}
	
	// Stock Receivers (one-to-many)
	public void function addStockReceiver(required any stockReceiver) {
		arguments.stockReceiver.setStockAdjustment( this );
	}
	public void function removeStockReceiver(required any stockReceiver) {
		arguments.stockReceiver.removeStockAdjustment( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================

	public any function getStockAdjustmentType() {
		if( !structKeyExists(variables, "stockAdjustmentType") ) {
			variables.stockAdjustmentType = getService("typeService").getTypeBySystemCode("satLocationTransfer");
		}
		return variables.stockAdjustmentType;
	}
	
	public any function getStockAdjustmentStatusType() {
		if( !structKeyExists(variables, "stockAdjustmentStatusType") ) {
			variables.stockAdjustmentStatusType = getService("typeService").getTypeBySystemCode("sastNew");
		}
		return variables.stockAdjustmentStatusType;
	}

	
	// ==============  END: Overridden Implicet Getters ====================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		
		// Verify Defaults are Set
		getStockAdjustmentType();
		getStockAdjustmentStatusType();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// =================== START: Deprecated Methods  =========================
	
	public string function getStatusCode() {
		return getStockAdjustmentStatusType().getSystemCode();
	}
	
	// ===================  END:  Deprecated Methods  =========================
}
