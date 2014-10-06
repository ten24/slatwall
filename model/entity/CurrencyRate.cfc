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
component entityname="SlatwallCurrencyRate" table="SwCurrencyRate" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="currencyService" {
	
	// Persistent Properties
	property name="currencyRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="conversionRate" ormtype="float";
	property name="effectiveStartDateTime" ormtype="timestamp" hb_nullRBKey="define.now";
	
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="currency" cfc="Currency" fieldtype="many-to-one" fkcolumn="currencyCode" length="255";
	property name="conversionCurrency" cfc="Currency" fieldtype="many-to-one" fkcolumn="conversionCurrencyCode" length="255";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Quick Lookup Properties
	property name="currencyCode" insert="false" update="false" length="255";
	property name="conversionCurrencyCode" insert="false" update="false" length="255";
	
	// Remote Properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
	// Deprecated Properties


	// ==================== START: Logical Methods =========================
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getConversionCurrencyOptionsSmartList() {
		if(!structKeyExists(variables, "conversionCurrencyOptionsSmartList")) {
			variables.conversionCurrencyOptionsSmartList = getPropertyOptionsSmartList('conversionCurrency');
		}
		return variables.conversionCurrencyOptionsSmartList;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Currency (many-to-one)    
	public void function setCurrency(required any currency) {    
		variables.currency = arguments.currency;    
		if(isNew() or !arguments.currency.hasCurrencyRate( this )) {    
			arrayAppend(arguments.currency.getCurrencyRates(), this);    
		}    
	}    
	public void function removeCurrency(any currency) {    
		if(!structKeyExists(arguments, "currency")) {    
			arguments.currency = variables.currency;    
		}    
		var index = arrayFind(arguments.currency.getCurrencyRates(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.currency.getCurrencyRates(), index);    
		}    
		structDelete(variables, "currency");    
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
	
	public void function preInsert(){
		if(isNull(getEffectiveStartDateTime())) {
			setEffectiveStartDateTime( now() );
		}
		super.preInsert();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}