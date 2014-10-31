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
component displayname="Inventory" entityname="SlatwallInventory" table="SwInventory" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="inventoryService" {
	
	// Persistent Properties
	property name="inventoryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantityIn" ormtype="integer";
	property name="quantityOut" ormtype="integer";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";

	// Related Object Properties (many-to-one)
	property name="stock" fieldtype="many-to-one" fkcolumn="stockID" cfc="Stock";
	property name="stockReceiverItem" cfc="StockReceiverItem" fieldtype="many-to-one" fkcolumn="stockReceiverItemID";
	property name="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="many-to-one" fkcolumn="orderDeliveryItemID";
	//property name="vendorOrderDeliveryItem" cfc="VendorOrderDeliveryItem" fieldtype="many-to-one" fkcolumn="vendorOrderDeliveryItemID";
	property name="stockAdjustmentDeliveryItem" cfc="StockAdjustmentDeliveryItem" fieldtype="many-to-one" fkcolumn="stockAdjustmentDeliveryItemID";
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preUpdate(Struct oldData){
		//throw("Updates to an Inventory Record are not allowed because this illustrates a fundamental flaw in inventory tracking.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
}