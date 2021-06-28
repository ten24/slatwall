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
component entityname="SlatwallSkuLocationQuantity" table="SwSkuLocationQuantity" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="inventoryService" hb_permission="this" hb_processContexts="" hb_auditable=false {

	// Persistent Properties
	property name="skuLocationQuantityID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Calculated Properties
	property name="calculatedQATS" ormtype="float";
	property name="calculatedQOH" ormtype="float";

	// Related Object Properties (many-to-one)
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="qats" type="numeric" persistent="false";
	property name="qoh" type="numeric" persistent="false";
	
	// Deprecated Properties


	// ==================== START: Logical Methods =========================	

	// END: Quantity Helper Methods

	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================
	public any function getQATS() {
		return getSku().getQuantity(quantityType="QATS", locationID=getLocation().getLocationId());
	}

	public any function getQOH() {
		return getSku().getQuantity(quantityType="QOH", locationID=getLocation().getLocationId());
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Sku (many-to-one)
	public void function setSku(required any sku) {
		variables.sku = arguments.sku;
		if(isNew() or !arguments.sku.hasSkuLocationQuantity( this )) {
			arrayAppend(arguments.sku.getSkuLocationQuantities(), this);
		}
	}
	public void function removeSku(any sku) {
		if(!structKeyExists(arguments, "sku")) {
			arguments.sku = variables.sku;
		}
		var index = arrayFind(arguments.sku.getSkuLocationQuantities(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.sku.getSkuLocationQuantities(), index);
		}
		structDelete(variables, "sku");
	}
	
	// Location (many-to-one)
	public void function setLocation(required any location) {
		variables.location = arguments.location;
		if(isNew() or !arguments.location.hasSkuLocationQuantity( this )) {
			arrayAppend(arguments.location.getSkuLocationQuantities(), this);
		}
	}
	public void function removeLocation(any location) {
		if(!structKeyExists(arguments, "location")) {
			arguments.location = variables.location;
		}
		var index = arrayFind(arguments.location.getSkuLocationQuantities(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.location.getSkuLocationQuantities(), index);
		}
		structDelete(variables, "location");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================


}
