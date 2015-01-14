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
component entityname="SlatwallTaxCategoryRate" table="SwTaxCategoryRate" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="taxService" hb_permission="taxCategory.taxCategoryRates" {
	
	// Persistent Properties
	property name="taxCategoryRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="taxRate" ormtype="float" hb_formatType="percentage";
	property name="taxAddressLookup" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="taxCategoryRateCode" ormtype="string" index="PI_TAXCATEGORYRATECODE";
	property name="taxLiabilityAppliedToItemFlag" ormtype="boolean" default="true";
	
	// Related Object Properties (many-to-one)
	property name="addressZone" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="addressZoneID" hb_optionsNullRBKey="define.all" hb_nullRBKey="define.all";
	property name="taxCategory" cfc="TaxCategory" fieldtype="many-to-one" fkcolumn="taxCategoryID";
		
	// Related Object Properties (one-to-many)
	property name="appliedTaxes" singularname="appliedTax" cfc="TaxApplied" fieldtype="one-to-many" fkcolumn="taxCategoryRateID" cascade="all" inverse="true" lazy="extra";
	property name="taxIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="taxIntegrationID";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	public boolean function getTaxLiabilityAppliedToItemFlag() {
		if(!structKeyExists(variables, "taxLiabilityAppliedToItemFlag")) {
			variables.taxLiabilityAppliedToItemFlag = 1;
		}
		return variables.taxLiabilityAppliedToItemFlag;
	}
	
	public array function getTaxAddressLookupOptions() {
		variables.taxAddressLookupOptions = [
			{name=rbKey('entity.taxCategoryRate.taxAddressLookup.shipping_billing'), value='shipping_billing'},
			{name=rbKey('entity.taxCategoryRate.taxAddressLookup.billing_shipping'), value='billing_shipping'},
			{name=rbKey('entity.taxCategoryRate.taxAddressLookup.shipping'), value='shipping'},
			{name=rbKey('entity.taxCategoryRate.taxAddressLookup.billing'), value='billing'}
		];
		return variables.taxAddressLookupOptions;
	}
	
		
	public any function getTaxAddressLookup() {
		if(isNull(variables.taxAddressLookup)) {
			variables.taxAddressLookup = 'shipping_billing';
		}
		return variables.taxAddressLookup;
	}

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Tax Category (many-to-one)
	public void function setTaxCategory(required any taxCategory) {
		variables.taxCategory = arguments.taxCategory;
		if(isNew() or !arguments.taxCategory.hasTaxCategoryRate( this )) {
			arrayAppend(arguments.taxCategory.getTaxCategoryRates(), this);
		}
	}
	public void function removeTaxCategory(any taxCategory) {
		if(!structKeyExists(arguments, "taxCategory")) {
			arguments.taxCategory = variables.taxCategory;
		}
		var index = arrayFind(arguments.taxCategory.getTaxCategoryRates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.taxCategory.getTaxCategoryRates(), index);
		}
		structDelete(variables, "taxCategory");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	
	public string function getSimpleRepresentation() {
		var sr = getTaxCategory().getTaxCategoryName();
		if( !isNull(getAddressZone()) ) {
			sr = listAppend(sr, getAddressZone().getAddressZoneName(), " - ");
		} else {
			sr = listAppend(sr, rbKey('define.all'), " - ");
		}
		sr = listAppend(sr, getTaxRate(), " - ");
		return sr;// getTaxCategory().getTaxCategoryName() & " - " & getAddressZone().getAddressZoneName() & " - " & getTaxRate();
	}
	
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
