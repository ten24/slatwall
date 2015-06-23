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
component displayname="Country" entityname="SlatwallCountry" table="SwCountry" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="addressService" hb_permission="this" hb_defaultOrderProperty="countryName" {
	
	// Persistent Properties
	property name="countryCode" length="2" ormtype="string" fieldtype="id";
	property name="countryCode3Digit" ormtype="string" length="3";
	property name="countryISONumber" ormtype="integer";
	property name="countryName" ormtype="string";
	property name="activeFlag" ormtype="boolean";
	
	property name="streetAddressLabel" ormtype="string";
	property name="streetAddressShowFlag" ormtype="boolean";
	property name="streetAddressRequiredFlag" ormtype="boolean";
	
	property name="street2AddressLabel" ormtype="string";
	property name="street2AddressShowFlag" ormtype="boolean";
	property name="street2AddressRequiredFlag" ormtype="boolean";
	
	property name="localityLabel" ormtype="string";
	property name="localityShowFlag" ormtype="boolean";
	property name="localityRequiredFlag" ormtype="boolean";
	
	property name="cityLabel" ormtype="string";
	property name="cityShowFlag" ormtype="boolean";
	property name="cityRequiredFlag" ormtype="boolean";
	
	property name="stateCodeLabel" ormtype="string";
	property name="stateCodeShowFlag" ormtype="boolean";
	property name="stateCodeRequiredFlag" ormtype="boolean";
	
	property name="postalCodeLabel" ormtype="string";
	property name="postalCodeShowFlag" ormtype="boolean";
	property name="postalCodeRequiredFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	property name="defaultCurrency" cfc="Currency" fieldtype="many-to-one" fkcolumn="defaultCurrencyCode";
	
	// Non-Persistent Properties
	property name="defaultCurrencyOptions" persistent="false" type="array";
	property name="states" persistent="false" type="array" hb_rbKey="entity.state_plural";
	property name="stateCodeOptions" persistent="false" type="array";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";


	// ============ START: Non-Persistent Property Methods =================
	
	public array function getStates() {
		if(!structKeyExists(variables, "states")) {
			var smartList = getStatesSmartList();
			variables.states = smartList.getRecords();
		}
		return variables.states;
	}
	
	public any function getStatesSmartList() {
		if(!structKeyExists(variables, "statesSmartList")) {
			variables.statesSmartList = getService("addressService").getStateSmartList();
			variables.statesSmartList.addFilter("countryCode", getCountryCode()); 
		}
		return variables.statesSmartList;
	}
	
	public array function getStateCodeOptions() {
		if(!structKeyExists(variables, "stateCodeOptions")) {
			var smartList = getService("addressService").getStateSmartList();
			smartList.addSelect(propertyIdentifier="stateName", alias="name");
			smartList.addSelect(propertyIdentifier="stateCode", alias="value");
			smartList.addFilter("countryCode", getCountryCode()); 
			smartList.addOrder("stateName|ASC");
			variables.stateCodeOptions = smartList.getRecords();
		}
		return variables.stateCodeOptions;
	}
	
	public array function getDefaultCurrencyOptions() {
		if(!structKeyExists(variables, "defaultCurrencyOptions")) {
			var smartList = getService("currencyService").getCurrencySmartList();
			smartList.addSelect(propertyIdentifier="currencyName", alias="name");
			smartList.addSelect(propertyIdentifier="currencyCode", alias="value");
			smartList.addOrder("currencyName|ASC");
			
			variables.defaultCurrencyOptions = smartList.getRecords();
			arrayPrepend(variables.defaultCurrencyOptions, {value='',name=rbKey('define.none')});
		}
		return variables.defaultCurrencyOptions;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}

