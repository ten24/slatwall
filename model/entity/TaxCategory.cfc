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
component entityname="SlatwallTaxCategory" table="SwTaxCategory" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="taxService" hb_permission="this" {
	
	// Persistent Properties
	property name="taxCategoryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="taxCategoryName" ormtype="string";
	property name="taxCategoryCode" ormtype="string" index="PI_TAXCATEGORYCODE";
	
	// Related Object Properties (one-to-many)
	property name="taxCategoryRates" singularname="taxCategoryRate" cfc="TaxCategoryRate" type="array" fieldtype="one-to-many" fkcolumn="taxCategoryID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-persistent properties
	property name="taxCategoryRatesDeletableFlag" type="boolean" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================

	
	public boolean function getTaxCategoryRatesDeletableFlag() {
		if(!structKeyExists(variables,"taxCategoryRatesDeletableFlag")) {
			variables.taxCategoryRatesDeletableFlag = true;
			for(var taxCategoryRate in getTaxCategoryRates()) {
				if(!taxCategoryRate.isDeletable()) {
					variables.taxCategoryRatesDeletableFlag = false;
					break;
				}
			}
		}
		return variables.taxCategoryRatesDeletableFlag;
	}
	
	public array function getTaxCategoryRateIntegrationOptions() {
		var optionsSL = getService("integrationService").getIntegrationSmartList();
		optionsSL.addFilter('activeFlag', '1');
		optionsSL.addLikeFilter('integrationTypeList', '%tax%');
		optionsSL.addSelect('integrationName', 'name');
		optionsSL.addSelect('integrationID', 'value');
		return optionsSL.getRecords();
	}	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Tax Category Rates (one-to-many)
	public void function addTaxCategoryRate(required any taxCategoryRate) {
		arguments.taxCategoryRate.setTaxCategory( this );
	}
	public void function removeTaxCategoryRate(required any taxCategoryRate) {
		arguments.taxCategoryRate.removeTaxCategory( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

