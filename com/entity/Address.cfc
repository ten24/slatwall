/*

    Slatwall - An Open Source eCommerce Platform
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
component displayname="Address" entityname="SlatwallAddress" table="SlatwallAddress" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="addressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="name" ormtype="string";
	property name="company" ormtype="string";
	property name="phone" ormtype="string";
	property name="streetAddress" ormtype="string";
	property name="street2Address" ormtype="string";
	property name="locality" ormtype="string";
	property name="city" ormtype="string";
	property name="stateCode" ormtype="string";
	property name="postalCode" ormtype="string";
	property name="countryCode" ormtype="string";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent Properties
	property name="country" persistent="false";
	property name="countryCodeOptions" persistent="false" type="array";
	property name="stateCodeOptions" persistent="false" type="array";
	
	public any function init() {
		if(isNull(variables.countryCode)) {
			variables.countryCode = "US";
		}
		
		return super.init();
	}
	
	public any function copyAddress( saveNewAddress=false ) {
		return getService("addressService").copyAddress( this, arguments.saveNewAddress );
	}

	public string function getFullAddress(string delimiter = ", ") {
		var address = "";
		address = listAppend(address,getCompany());
		address = listAppend(address, getStreetAddress());
		address = listAppend(address,getStreet2Address());
		address = listAppend(address,getCity());
		address = listAppend(address,getStateCode());
		address = listAppend(address,getPostalCode());
		address = listAppend(address,getCountryCode());
		// this will remove any empty elements and insert any passed-in delimiter
		address = listChangeDelims(address,arguments.delimiter,",","no");
		return address;
	}
	

	// ============ START: Non-Persistent Property Methods =================
	
	public any function getCountry() {
		if(!structKeyExists(variables, "country")) {
			variables.country = getService("addressService").getCountry(getCountryCode());
		}
		return variables.country;
	}
	
	public array function getCountryCodeOptions() {
		if(!structKeyExists(variables, "countryCodeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallCountry");
			smartList.addFilter(propertyIdentifier="activeFlag", value=1);
			smartList.addSelect(propertyIdentifier="countryName", alias="name");
			smartList.addSelect(propertyIdentifier="countryCode", alias="value");
			smartList.addOrder("countryName|ASC");
			variables.countryCodeOptions = smartList.getRecords();
		}
		return variables.countryCodeOptions;
	}
	
	public array function getStateCodeOptions() {
		if(!structKeyExists(variables, "stateCodeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallState");
			smartList.addSelect(propertyIdentifier="stateName", alias="name");
			smartList.addSelect(propertyIdentifier="stateCode", alias="value");
			smartList.addFilter("countryCode", getCountryCode()); 
			smartList.addOrder("stateName|ASC");
			variables.stateCodeOptions = smartList.getRecords();
			arrayPrepend(variables.stateCodeOptions, {value="", name=rbKey('define.select')});
		}
		return variables.stateCodeOptions;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		var simpleRepresentation = "";
		if( !isNull(getStreetAddress()) ) {
			simpleRepresentation = listAppend(simpleRepresentation, " #getStreetAddress()#" );
		}
		if( !isNull(getStreet2Address()) ) {
			simpleRepresentation = listAppend(simpleRepresentation, " #getStreet2Address()#" );
		}
		if( !isNull(getCity()) ) {
			simpleRepresentation = listAppend(simpleRepresentation, " #getCity()#" );
		}
		if( !isNull(getStateCode()) ) {
			simpleRepresentation = listAppend(simpleRepresentation, " #getStateCode()#" );
		}
		if( !isNull(getPostalCode()) ) {
			simpleRepresentation = listAppend(simpleRepresentation, " #getPostalCode()#" );
		}
		if( !isNull(getCountryCode()) ) {
			simpleRepresentation = listAppend(simpleRepresentation, " #getCountryCode()#" );
		}
		
		return simpleRepresentation;
	}
	
	// This overrides the base validation method to dynamically add rules based on country specific requirements
	public any function validate() {
		
		// Get the country of this address
		var country = getCountry();
		
		// Check each of the contries required fields
		if ( country.getStreetAddressRequiredFlag() ) {
			getValidateThis().addRule(objectType="Address",propertyName="streetAddress", valType="required", contexts="full,location");
		}
		if ( country.getStreet2AddressRequiredFlag() ) {
			getValidateThis().addRule(objectType="Address",propertyName="street2Address", valType="required", contexts="full,location");
		}
		if ( country.getLocalityRequiredFlag() ) {
			getValidateThis().addRule(objectType="Address",propertyName="locality", valType="required", contexts="full,location");
		}
		if ( country.getCityRequiredFlag() ) {
			getValidateThis().addRule(objectType="Address",propertyName="city", valType="required", contexts="full,location");
		}
		if ( country.getStateCodeRequiredFlag() ) {
			getValidateThis().addRule(objectType="Address",propertyName="stateCode", valType="required", contexts="full,location");
		}
		if ( country.getPostalCodeRequiredFlag() ) {
			getValidateThis().addRule(objectType="Address",propertyName="postalCode", valType="required", contexts="full,location");
		}
		
		// Call the base method validate with any additional arguments passed in
		super.validate(argumentCollection=arguments);
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
