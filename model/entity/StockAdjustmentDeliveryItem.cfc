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
component entityname="SlatwallStockAdjustmentDeliveryItem" table="SwStockAdjustmentDeliveryItem" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="stockService" hb_permission="stockAdjustmentDelivery.stockAdjustmentDeliveryItems" {
	
	// Persistent Properties
	property name="stockAdjustmentDeliveryItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="stockAdjustmentDelivery" cfc="StockAdjustmentDelivery" fieldtype="many-to-one" fkcolumn="stockAdjustmentDeliveryID";
	property name="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="many-to-one" fkcolumn="stockAdjustmentItemID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Adjustment Delivery (many-to-one)
	public void function setStockAdjustmentDelivery(required any stockAdjustmentDelivery) {
		variables.stockAdjustmentDelivery = arguments.stockAdjustmentDelivery;
		if(isNew() or !arguments.stockAdjustmentDelivery.hasStockAdjustmentDeliveryItem( this )) {
			arrayAppend(arguments.stockAdjustmentDelivery.getStockAdjustmentDeliveryItems(), this);
		}
	}
	public void function removeStockAdjustmentDelivery(any stockAdjustmentDelivery) {
		if(!structKeyExists(arguments, "stockAdjustmentDelivery")) {
			arguments.stockAdjustmentDelivery = variables.stockAdjustmentDelivery;
		}
		var index = arrayFind(arguments.stockAdjustmentDelivery.getStockAdjustmentDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.stockAdjustmentDelivery.getStockAdjustmentDeliveryItems(), index);
		}
		structDelete(variables, "stockAdjustmentDelivery");
	}
	
	// Stock Adjustment Item (many-to-one)
	public void function setStockAdjustmentItem(required any stockAdjustmentItem) {
		variables.stockAdjustmentItem = arguments.stockAdjustmentItem;
		if(isNew() or !arguments.stockAdjustmentItem.hasStockAdjustmentDeliveryItem( this )) {
			arrayAppend(arguments.stockAdjustmentItem.getStockAdjustmentDeliveryItems(), this);
		}
	}
	public void function removeStockAdjustmentItem(any stockAdjustmentItem) {
		if(!structKeyExists(arguments, "stockAdjustmentItem")) {
			arguments.stockAdjustmentItem = variables.stockAdjustmentItem;
		}
		var index = arrayFind(arguments.stockAdjustmentItem.getStockAdjustmentDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.stockAdjustmentItem.getStockAdjustmentDeliveryItems(), index);
		}
		structDelete(variables, "stockAdjustmentItem");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("inventoryService").createInventory( this );
	}
	
	public void function preUpdate(Struct oldData){
		throw("Updates to StockAdjustment Delivery Items are not allowed because this illustrates a fundamental flaw in inventory tracking.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

