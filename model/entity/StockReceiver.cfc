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
component entityname="SlatwallStockReceiver" table="SwStockReceiver" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="stockService" {
	
	
	// Persistent Properties
	property name="stockReceiverID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="packingSlipNumber" ormtype="string";
	property name="boxCount" ormtype="integer";
	property name="receiverType" ormtype="string" hb_formatType="rbKey" notnull="true";
	
	// Related Object Properties (many-to-one)
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="stockAdjustment" cfc="StockAdjustment" fieldtype="many-to-one" fkcolumn="stockAdjustmentID";
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	
	// Related Object Properties (one-to-many)
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" fieldtype="one-to-many" fkcolumn="stockReceiverID" cascade="all-delete-orphan" inverse="true";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasStockReceiver( this )) {
			arrayAppend(arguments.order.getStockReceivers(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getStockReceivers(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getStockReceivers(), index);
		}
		structDelete(variables, "order");
	}
	
	// Vendor Order (many-to-one)
	public void function setVendorOrder(required any vendorOrder) {
		variables.vendorOrder = arguments.vendorOrder;
		if(isNew() or !arguments.vendorOrder.hasStockReceiver( this )) {
			arrayAppend(arguments.vendorOrder.getStockReceivers(), this);
		}
	}
	public void function removeVendorOrder(any vendorOrder) {
		if(!structKeyExists(arguments, "vendorOrder")) {
			arguments.vendorOrder = variables.vendorOrder;
		}
		var index = arrayFind(arguments.vendorOrder.getStockReceivers(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrder.getStockReceivers(), index);
		}
		structDelete(variables, "vendorOrder");
	}
	
	// Stock Adjustment (many-to-one)    
	public void function setStockAdjustment(required any stockAdjustment) {    
		variables.stockAdjustment = arguments.stockAdjustment;    
		if(isNew() or !arguments.stockAdjustment.hasStockReceiver( this )) {    
			arrayAppend(arguments.stockAdjustment.getStockReceivers(), this);    
		}    
	}    
	public void function removeStockAdjustment(any stockAdjustment) {    
		if(!structKeyExists(arguments, "stockAdjustment")) {    
			arguments.stockAdjustment = variables.stockAdjustment;    
		}    
		var index = arrayFind(arguments.stockAdjustment.getStockReceivers(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.stockAdjustment.getStockReceivers(), index);    
		}    
		structDelete(variables, "stockAdjustment");    
	}
	
	// Stock Receiver Items (one-to-many)
	public void function addStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.setStockReceiver( this );
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.removeStockReceiver( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "packingSlipNumber";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
