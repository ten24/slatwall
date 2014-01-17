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
component displayname="Address" entityname="SlatwallAddress" table="SwAddress" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="addressService" hb_permission="this" {
	
	// Persistent Properties
	property name="addressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="name" hb_populateEnabled="public" ormtype="string";
	property name="company" hb_populateEnabled="public" ormtype="string";
	property name="streetAddress" hb_populateEnabled="public" ormtype="string";
	property name="street2Address" hb_populateEnabled="public" ormtype="string";
	property name="locality" hb_populateEnabled="public" ormtype="string";
	property name="city" hb_populateEnabled="public" ormtype="string";
	property name="stateCode" hb_populateEnabled="public" ormtype="string";
	property name="postalCode" hb_populateEnabled="public" ormtype="string";
	property name="countryCode" hb_populateEnabled="public" ormtype="string";
	
	property name="salutation" hb_populateEnabled="public" ormtype="string" hb_formFieldType="select";
	property name="firstName" hb_populateEnabled="public" ormtype="string";
	property name="lastName" hb_populateEnabled="public" ormtype="string";
	property name="middleName" hb_populateEnabled="public" ormtype="string";
	property name="middleInitial" hb_populateEnabled="public" ormtype="string";
	
	property name="phoneNumber" hb_populateEnabled="public" ormtype="string";
	property name="emailAddress" hb_populateEnabled="public" ormtype="string";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent Properties
	property name="country" persistent="false";
	property name="countryCodeOptions" persistent="false" type="array";
	property name="salutationOptions" persistent="false" type="array";
	property name="stateCodeOptions" persistent="false" type="array";
	
	public any function init() {
		if(isNull(variables.countryCode)) {
			variables.countryCode = "US";
		}
		
		return super.init();
	}
	
	
	// ==================== START: Logical Methods =========================
	
	public boolean function getAddressMatchFlag( required any address ) {
		if(
			nullReplace(getCountryCode(),"") != nullReplace(arguments.address.getCountryCode(),"")
			||
			nullReplace(getName(),"") != nullReplace(arguments.address.getName(),"")
			||
			nullReplace(getStreetAddress(),"") != nullReplace(arguments.address.getStreetAddress(),"")
			||
			nullReplace(getStreet2Address(),"") != nullReplace(arguments.address.getStreet2Address(),"")
			||
			nullReplace(getLocality(),"") != nullReplace(arguments.address.getLocality(),"")
			||
			nullReplace(getCity(),"") != nullReplace(arguments.address.getCity(),"")
			||
			nullReplace(getStateCode(),"") != nullReplace(arguments.address.getStateCode(),"")
			||
			nullReplace(getPostalCode(),"") != nullReplace(arguments.address.getPostalCode(),"")
		) {
			return false;
		}
		
		return true;
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
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getCountry() {
		if(!structKeyExists(variables, "country")) {
			variables.country = getService("addressService").getCountry(getCountryCode());
		}
		return variables.country;
	}
	
	public array function getCountryCodeOptions() {
		return getService("hibachiCacheService").getOrCacheFunctionValue("addressService_getCountryCodeOptions", "addressService", "getCountryCodeOptions");
	}
	
	public array function getSalutationOptions() {
		return [
			rbKey('define.salutationMr'),
			rbKey('define.salutationMrs'),
			rbKey('define.salutationMs'),
			rbKey('define.salutationMiss')
		];
	}
	
	public array function getStateCodeOptions() {
		if(!structKeyExists(variables, "stateCodeOptions")) {
			var smartList = getService("addressService").getStateSmartList();
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

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	public any function getName() {
		if(structKeyExists(variables, "name")) {
			return variables.name;
		} else if (!structKeyExists(variables, "name") && ( !isNull(getSalutation()) || !isNull(getFirstName()) || !isNull(getMiddleName()) || !isNull(getMiddleInitial()) || !isNull(getLastName()) ) ) {
			var name = "";
			if(!isNull(getSalutation())) {
				name = listAppend(name, getSalutation(), " ");
			}
			if(!isNull(getFirstName())) {
				name = listAppend(name, getFirstName(), " ");
			}
			if(!isNull(getMiddleName())) {
				name = listAppend(name, getMiddleName(), " ");
			} else if (!isNull(getMiddleInitial())) {
				name = listAppend(name, getMiddleInitial(), " ");
			}
			if(!isNull(getLastName())) {
				name = listAppend(name, getLastName(), " ");
			}
		} 
	}
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

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
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	public any function getPhone() {
		if(!isNull(getPhoneNumber())) {
			return getPhoneNumber();
		}
		return "";
	}
	
	// ==================  END:  Deprecated Methods ========================
	
}

