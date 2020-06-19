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
component entityname="SlatwallVendorOrderDeliveryItem" table="SwVendorOrderDeliveryItem" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="vendorOrderService" hb_permission="this" hb_processContexts="fulfill" {

	// Persistent Properties
	property name="VendorOrderDeliveryItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";

	// Related Object Properties (Many-To-One)
	property name="vendorOrderDelivery" cfc="VendorOrderDelivery" fieldtype="many-to-one" fkcolumn="vendorOrderDeliveryID";
	property name="vendorOrderItem" cfc="VendorOrderItem" fieldtype="many-to-one" fkcolumn="vendorOrderItemID" hb_cascadeCalculate="true";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID" hb_cascadeCalculate="true";

	// Related Object Properties (One-To-Many)


	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non persistent properties
	// ============ START: Non-Persistent Property Methods =================



	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order Delivery (many-to-one)
	public void function setVendorOrderDelivery(required any vendorOrderDelivery) {
		variables.vendorOrderDelivery = arguments.vendorOrderDelivery;
		if(isNew() or !arguments.vendorOrderDelivery.hasVendorOrderDeliveryItem( this )) {
			arrayAppend(arguments.vendorOrderDelivery.getVendorOrderDeliveryItems(), this);
		}
	}
	public void function removeVendorOrderDelivery(any vendorOrderDelivery) {
		if(!structKeyExists(arguments, "vendorOrderDelivery")) {
			arguments.vendorOrderDelivery = variables.vendorOrderDelivery;
		}
		var index = arrayFind(arguments.vendorOrderDelivery.getVendorOrderDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrderDelivery.getVendorOrderDeliveryItems(), index);
		}
		structDelete(variables, "vendorOrderDelivery");
	}

	// Order Item (many-to-one)
	public void function setVendorOrderItem(required any vendorOrderItem) {
		variables.vendorOrderItem = arguments.vendorOrderItem;
		if(isNew() or !arguments.vendorOrderItem.hasVendorOrderDeliveryItem( this )) {
			arrayAppend(arguments.vendorOrderItem.getVendorOrderDeliveryItems(), this);
		}
	}
	public void function removeVendorOrderItem(any vendorOrderItem) {
		if(!structKeyExists(arguments, "vendorOrderItem")) {
			arguments.vendorOrderItem = variables.vendorOrderItem;
		}
		var index = arrayFind(arguments.vendorOrderItem.getVendorOrderDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrderItem.getVendorOrderDeliveryItems(), index);
		}
		structDelete(variables, "vendorOrderItem");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================


	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================


	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	public void function preInsert(){
		super.preInsert();
		getService("inventoryService").createInventory( this );
	}


	// ===================  END:  ORM Event Hooks  =========================
}

