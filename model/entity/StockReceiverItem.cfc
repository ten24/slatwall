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
component entityname="SlatwallStockReceiverItem" table="SwStockReceiverItem" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="stockService" {
	
	// Persistent Properties
	property name="stockReceiverItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	property name="cost" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	
	// Related Object Properties (many-to-one)
	property name="stock" fieldtype="many-to-one" fkcolumn="stockID" cfc="Stock" hb_cascadeCalculate="true";
	property name="stockReceiver" fieldtype="many-to-one" fkcolumn="stockReceiverID" cfc="StockReceiver";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="vendorOrderItem" cfc="VendorOrderItem" fieldtype="many-to-one" fkcolumn="vendorOrderItemID";
	property name="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="many-to-one" fkcolumn="stockAdjustmentItemID";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	
	private boolean function hasOneAndOnlyOneRelatedItem() {
    	var relationshipCount = 0;
    	if(!isNull(getVendorOrderItem())) {
    		relationshipCount++;
    	}
    	if(!isNull(getOrderItem())) {
    		relationshipCount++;
    	}
    	if(!isNull(getStockAdjustmentItem())) {
    		relationshipCount++;
    	}
    	return relationshipCount == 1;
    }
    
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Receiver (many-to-one)    
	public void function setStockReceiver(required any stockReceiver) {    
		variables.stockReceiver = arguments.stockReceiver;    
		if(isNew() or !arguments.stockReceiver.hasStockReceiverItem( this )) {    
			arrayAppend(arguments.stockReceiver.getStockReceiverItems(), this);    
		}    
	}    
	public void function removeStockReceiver(any stockReceiver) {    
		if(!structKeyExists(arguments, "stockReceiver")) {    
			arguments.stockReceiver = variables.stockReceiver;    
		}    
		var index = arrayFind(arguments.stockReceiver.getStockReceiverItems(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.stockReceiver.getStockReceiverItems(), index);    
		}    
		structDelete(variables, "stockReceiver");    
	}

	// Stock Adjustment Item (many-to-one)    
	public void function setStockAdjustmentItem(required any stockAdjustmentItem) {    
		variables.stockAdjustmentItem = arguments.stockAdjustmentItem;    
		if(isNew() or !arguments.stockAdjustmentItem.hasStockReceiverItem( this )) {    
			arrayAppend(arguments.stockAdjustmentItem.getStockReceiverItems(), this);    
		}    
	}    
	public void function removeStockAdjustmentItem(any stockAdjustmentItem) {    
		if(!structKeyExists(arguments, "stockAdjustmentItem")) {    
			arguments.stockAdjustmentItem = variables.stockAdjustmentItem;    
		}    
		var index = arrayFind(arguments.stockAdjustmentItem.getStockReceiverItems(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.stockAdjustmentItem.getStockReceiverItems(), index);    
		}    
		structDelete(variables, "stockAdjustmentItem");    
	}
	
	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasStockReceiverItem( this )) {
			arrayAppend(arguments.orderItem.getStockReceiverItems(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getStockReceiverItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getStockReceiverItems(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// Vendor Order Item (many-to-one)
	public void function setVendorOrderItem(required any vendorOrderItem) {
		variables.vendorOrderItem = arguments.vendorOrderItem;
		if(isNew() or !arguments.vendorOrderItem.hasStockReceiverItem( this )) {	
			arrayAppend(arguments.vendorOrderItem.getStockReceiverItems(), this);
		}
	}
	public void function removeVendorOrderItem(any vendorOrderItem) {
		if(!structKeyExists(arguments, "vendorOrderItem")) {
			arguments.vendorOrderItem = variables.vendorOrderItem;
		}
		var index = arrayFind(arguments.vendorOrderItem.getStockReceiverItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrderItem.getStockReceiverItems(), index);
		}
		structDelete(variables, "vendorOrderItem");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		if(!hasOneAndOnlyOneRelatedItem()) {
			throw("The Stock Receiver Item Needs to have a relationship with 'OrderItem', 'VendorOrderItem', or 'StockAdjustmentItem' and only one of those can exist.");
		}
		super.preInsert();
		getService("inventoryService").createInventory( this );
	}
	
	public void function preUpdate(Struct oldData){
		throw("Updates to Stock Receiver Items are not allowed because this illustrates a fundamental flaw in inventory tracking.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
