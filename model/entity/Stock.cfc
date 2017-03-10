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
component displayname="Stock" entityname="SlatwallStock" table="SwStock" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="stockService" {

	// Persistent Properties
	property name="stockID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Object Properties (many-to-one)
	property name="location" fieldtype="many-to-one" fkcolumn="locationID" cfc="Location";
	property name="sku" fieldtype="many-to-one" fkcolumn="skuID" cfc="Sku" hb_cascadeCalculate="true"; // We always want sku when we get a stock

	// Related Object Properties (one-to-many). Including this property to allow HQL to do  stock -> vendorOrderItem lookups
	property name="vendorOrderItems" singularname="vendorOrderItem" cfc="VendorOrderItem" fieldtype="one-to-many" fkcolumn="stockID" inverse="true";
	property name="inventory" singularname="inventory" cfc="Inventory" fieldtype="one-to-many" fkcolumn="stockID" inverse="true" lazy="extra";

	//Calculated Properties
	property name="calculatedQATS" ormtype="integer";
	property name="calculatedQOH" ormtype="integer";
	property name="calculatedQNC" ormtype="integer";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	property name="QATS" persistent="false";
	property name="QOH" persistent="false";
	property name="QNC" persistent="false";

	//Derived Properties
	//property name="derivedQOH" formula="select COALESCE( SUM(inventory.quantityIn), 0 ) - COALESCE( SUM(inventory.quantityOut), 0 ) from swInventory as inventory where inventory.stockID= stockID";

	// Quantity
	public numeric function getQuantity(required string quantityType) {
		if( !structKeyExists(variables, arguments.quantityType) ) {
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA", arguments.quantityType)) {
				return getSku().getQuantity(quantityType=arguments.quantityType, stockID=this.getStockID());
			} else if(listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType)) {
				variables[ arguments.quantityType ] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
		}
		return variables[ arguments.quantityType ];
	}


	// ============ START: Non-Persistent Property Methods =================

	public any function getQATS() {
		return getQuantity("QATS");
	}

	public any function getQOH() {
		return getQuantity("QOH");
	}

	public any function getQNC() {
		return getQuantity("QNC");
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

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}

