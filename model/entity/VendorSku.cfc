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
component entityname="SlatwallVendorSku" table="SwVendorSku" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="vendorService" hb_permission="this" {

	// Persistent Properties
	property name="vendorSkuID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Calculated Properties
	property name="calculatedLastCostCurrencyCode" ormtype="string";
	property name="calculatedLastCost" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedQuantity" ormtype="integer";

	// Related Object Properties (many-to-one)
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="alternateSkuCode" cfc="AlternateSkuCode" fieldtype="many-to-one" fkcolumn="alternateSkuCodeID";
	property name="lastVendorOrderItem" cfc="VendorOrderItem" fieldtype="many-to-one" fkcolumn="lastVendorOrderItemID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	property name="lastCostCurrencyCode" persistent="false";
	property name="lastCost" persistent="false";
	property name="quantity" persistent="false";

	// ============ START: Non-Persistent Property Methods =================

	public any function getLastCostCurrencyCode(){
		return getLastVendorOrderItem().getCurrencyCode();
	}

	public numeric function getLastCost(){
		return getLastVendorOrderItem().getCost();
	}

	public numeric function getQuantity(){
		return getLastVendorOrderItem().getQuantity();
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// AlternateSkuCode (many-to-one)
	public void function setAlternateativeSkuCode(required any alternateSkuCode) {
		variables.alternateSkuCode = arguments.alternateSkuCode;
		if(isNew() or !arguments.alternateSkuCode.hasVendorSku( this )) {
			arrayAppend(arguments.alternateSkuCode.getVendorSkus(), this);
		}
	}
	public void function removeAlternateSkuCode(any alternateSkuCode) {
		if(!structKeyExists(arguments, "alternateSkuCode")) {
			arguments.alternateSkuCode = variables.alternateSkuCode;
		}
		var index = arrayFind(arguments.alternateSkuCode.getVendorSkus(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.alternateSkuCode.getVendorSkus(), index);
		}
		structDelete(variables, "alternateSkuCode");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
