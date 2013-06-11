/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component entityname="SlatwallSkuCurrency" table="SlatwallSkuCurrency" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="skuService" hb_permission="sku.skuCurrencies" {
	
	// Persistent Properties
	property name="skuCurrencyID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="price" ormtype="big_decimal" hb_formatType="currency" hb_rbKey='entity.sku.price';
	property name="renewalPrice" ormtype="big_decimal" hb_formatType="currency" default="0" hb_rbKey='entity.sku.renewalPrice';
	property name="listPrice" ormtype="big_decimal" hb_formatType="currency" default="0" hb_rbKey='entity.sku.listPrice';
	
	// Related Object Properties (many-to-one)
	property name="currency" cfc="Currency" fieldtype="many-to-one" fkcolumn="currencyCode";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Non Update-Insert Properties
	property name="currencyCode" insert="false" update="false";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties

	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Sku (many-to-one)
	public void function setSku(required any sku) {
		variables.sku = arguments.sku;
		if(isNew() or !arguments.sku.hasSkuCurrency( this )) {
			arrayAppend(arguments.sku.getSkuCurrencies(), this);
		}
	}
	public void function removeSku(any sku) {
		if(!structKeyExists(arguments, "sku")) {
			arguments.sku = variables.sku;
		}
		var index = arrayFind(arguments.sku.getSkuCurrencies(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.sku.getSkuCurrencies(), index);
		}
		structDelete(variables, "sku");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return getSku().getSkuCode() & " - " & getCurrency().getCurrencyCode(); 
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}