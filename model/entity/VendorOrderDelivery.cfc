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
component entityname="SlatwallVendorOrderDelivery" table="SwVendorOrderDelivery" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="vendorOrderService" hb_permission="this" hb_processContexts="fulfill" {

	// Persistent Properties
	property name="VendorOrderDeliveryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Object Properties (Many-To-One)
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";

	// Related Object Properties (One-To-Many)
	property name="vendorOrderDeliveryItems" singularname="vendorOrderDeliveryItem" cfc="VendorOrderDeliveryItem" fieldtype="one-to-many" fkcolumn="vendorOrderDeliveryID" cascade="all-delete-orphan" inverse="true";

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	
	public boolean function getLocationIsLeafNode(){
		return  !getLocation().hasChildren();
	}

	// Non persistent properties
	// ============ START: Non-Persistent Property Methods =================



	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order (many-to-one)
	public void function setVendorOrder(required any vendorOrder) {
		variables.vendorOrder = arguments.vendorOrder;
		if(isNew() or !arguments.vendorOrder.hasVendorOrderDelivery( this )) {
			arrayAppend(arguments.vendorOrder.getVendorOrderDeliveries(), this);
		}
	}
	public void function removeVendorOrder(any vendorOrder) {
		if(!structKeyExists(arguments, "vendorOrder")) {
			arguments.vendorOrder = variables.vendorOrder;
		}
		var index = arrayFind(arguments.vendorOrder.getVendorOrderDeliveries(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrder.getVendorOrderDeliveries(), index);
		}
		structDelete(variables, "vendorOrder");
	}

	// Order Delivery Items (one-to-many)
	public void function addVendorOrderDeliveryItem(required any vendorOrderDeliveryItem) {
		arguments.vendorOrderDeliveryItem.setVendorOrderDelivery( this );
	}
	public void function removeVendorOrderDeliveryItem(required any vendorOrderDeliveryItem) {
		arguments.vendorOrderDeliveryItem.removeVendorOrderDelivery( this );
	}



	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================


	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================


	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================


	// ===================  END:  ORM Event Hooks  =========================
}

