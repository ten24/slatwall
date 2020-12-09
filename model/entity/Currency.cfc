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
component displayname="Currency" entityname="SlatwallCurrency" table="SwCurrency" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="currencyService" hb_permission="this" hb_defaultOrderProperty="currencyName" {
	
	// Persistent Properties
	property name="currencyCode" ormtype="string" fieldtype="id" unique="true" generated="never";
	property name="currencyISONumber" ormtype="integer";
	property name="activeFlag" ormtype="boolean";
	property name="currencyName" ormtype="string";
	property name="currencySymbol" ormtype="string";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="currencyRates" singularname="currencyRate" cfc="CurrencyRate" type="array" fieldtype="one-to-many" fkcolumn="currencyCode" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="currencyLocalOptions" persistent="false";
	property name="formattedExample" persistent="false" hb_formatType="currency"; 

	
	// ============ START: Non-Persistent Property Methods =================
	public array function getCurrencyLocalOptions() {
		return ['Chinese (China)','Chinese (Hong Kong)','Chinese (Taiwan)','Dutch (Belgian)','Dutch (Standard)','English (Australian)','English (Canadian)','English (New Zealand)','English (UK)','English (US)','French (Belgian)','French (Canadian)','French (Standard)','French (Swiss)','German (Austrian)','German (Standard)','German (Swiss)','Italian (Standard)', 'Italian (Swiss)','Japanese','Korean','Norwegian (Bokmal)','Norwegian (Nynorsk)','Portuguese (Brazilian)','Portuguese (Standard)','Spanish (Mexican)','Spanish (Modern)','Spanish (Standard)','Swedish'];
	}
	
	public string function getFormattedExample() {
		return 12345.67;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Currency Rates (one-to-many)    
	public void function addCurrencyRate(required any currencyRate) {    
		arguments.currencyRate.setCurrency( this );    
	}    
	public void function removeCurrencyRate(required any currencyRate) {    
		arguments.currencyRate.removeCurrency( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
