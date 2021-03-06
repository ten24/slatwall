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
	property name="addressName" hb_populateEnabled="public" ormtype="string" length="1024"; 
	property name="company" hb_populateEnabled="public" ormtype="string";
	property name="streetAddress" hb_populateEnabled="public" ormtype="string";
	property name="street2Address" hb_populateEnabled="public" ormtype="string";
	property name="locality" hb_populateEnabled="public" ormtype="string";
	property name="city" hb_populateEnabled="public" ormtype="string";
	property name="stateCode" hb_populateEnabled="public" ormtype="string";
	property name="postalCode" hb_populateEnabled="public" ormtype="string";
	property name="shortPostalCode" hb_populateEnabled="public" ormtype="string" hint="Store Only 5 digits ZIPCODE for US Addresses";
	property name="countryCode" hb_populateEnabled="public" ormtype="string";
	
	property name="salutation" hb_populateEnabled="public" ormtype="string" hb_formFieldType="select";
	property name="firstName" hb_populateEnabled="public" ormtype="string";
	property name="lastName" hb_populateEnabled="public" ormtype="string";
	property name="middleName" hb_populateEnabled="public" ormtype="string";
	property name="middleInitial" hb_populateEnabled="public" ormtype="string";
	
	property name="phoneNumber" hb_populateEnabled="public" ormtype="string";
	property name="emailAddress" hb_populateEnabled="public" ormtype="string";
	property name="urlTitle" hb_populateEnabled="public" ormtype="string";

	property name="verifiedByIntegrationFlag" hb_populateEnabled="false" ormtype="boolean";
	property name="IntegrationVerificationErrorMessage" hb_populateEnabled="public" ormtype="string";
	property name="verificationCacheKey" ormtype="string" hb_auditable="false";
	property name="verificationJson" ormtype="string" length="8000" hb_formFieldType="json" hb_auditable="false"; //Avalara returns a big json
	
	//one-to-many
  	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="addressID" cascade="all-delete-orphan" inverse="true";
	
	// Remote properties
	property name="remoteID" hb_populateEnabled="private" ormtype="string" hint="Only used when integrated with a remote system";
	property name="importRemoteID" hb_populateEnabled="private" ormtype="string" hint="Used via data-importer as a unique-key to find records for upsert";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non Persistent Properties
	property name="country" persistent="false";
	property name="countryCodeOptions" persistent="false" type="array";
	property name="salutationOptions" persistent="false" type="array";
	property name="stateCodeOptions" persistent="false" type="array";
	
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
	
	public any function copyAddress( saveNewAddress=true ) {
		return getService("addressService").copyAddress( this, arguments.saveNewAddress );
	}
	
	public boolean function getVerifiedByIntegrationFlag(){
		return !isNull(variables.verifiedByIntegrationFlag) ? variables.verifiedByIntegrationFlag : false;
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
	
	public any function populateFromAddressValueCopy(required any sourceAddress) {
		this.setName( arguments.sourceAddress.getName() );
		this.setCompany( arguments.sourceAddress.getCompany() );
		this.setStreetAddress( arguments.sourceAddress.getStreetAddress() );
		this.setStreet2Address( arguments.sourceAddress.getStreet2Address() );
		this.setLocality( arguments.sourceAddress.getLocality() );
		this.setCity( arguments.sourceAddress.getCity() );
		this.setStateCode( arguments.sourceAddress.getStateCode() );
		this.setPostalCode( arguments.sourceAddress.getPostalCode() );
		this.setCountryCode( arguments.sourceAddress.getCountryCode() );
		this.setSalutation( arguments.sourceAddress.getSalutation() );
		this.setFirstName( arguments.sourceAddress.getFirstName() );
		this.setLastName( arguments.sourceAddress.getLastName() );
		this.setMiddleName( arguments.sourceAddress.getMiddleName() );
		this.setMiddleInitial( arguments.sourceAddress.getMiddleInitial() );
		this.setPhoneNumber( arguments.sourceAddress.getPhoneNumber() );
		this.setEmailAddress( arguments.sourceAddress.getEmailAddress() );
	}
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getCountry() {
		if(!structKeyExists(variables, "country") && !isNull(getCountryCode())) {
			variables.country = getService("addressService").getCountry(getCountryCode());
			if(isNull(variables.country)){
				variables.country = getService('addressService').getCountryByCountryCode3Digit(getCountryCode());
			}
		}
		if(structKeyExists(variables, "country")) {
			return variables.country;	
		}
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
	
	public any function getStateCodeFromAddressZoneOptions(){
		var collectionList = getService('AddressService').getAddressZoneCollectionList();
		collectionList.setDisplayProperties('stateCode|value,stateName|name');
		if(!isNull(getCountryCode())) {
			collectionList.addFilter("addressZoneCode", getCountryCode());	
		} else {
			collectionList.addFilter("addressZoneCode", 'US');
		}
		var options = [{'value' ='', 'name'='-- Select a State'}];
		arrayAppend(options, collectionList.getRecords(), true );

		return options;
	}
	
	public array function getStateCodeOptions() {
		if(!structKeyExists(variables, "stateCodeOptions")) {
			var collectionList = getService("addressService").getStateCollectionList();
			collectionList.setDisplayProperties('stateName|name, stateCode|value');
			if(!isNull(getCountryCode())) {
				collectionList.addFilter("countryCode", getCountryCode());	
			} else {
				collectionList.addFilter("countryCode", 'US');
			}
			collectionList.addOrderBy("stateName|ASC");
			variables.stateCodeOptions = collectionList.getRecords();
			arrayPrepend(variables.stateCodeOptions, {'value'="", 'name'=rbKey('define.select')});
		}
		return variables.stateCodeOptions;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	public string function getAddressName(){
		if(!structKeyExists(variables,'addressName')){
			var name = "";
			if( !isNull(getStreetAddress()) ) {
				name =  listAppend(name, " #getStreetAddress()#" );
			}
			if( !isNull(getStreet2Address()) ) {
				name = listAppend(name, " #getStreet2Address()#" );
			}
			if( !isNull(getCity()) ) {
				name = listAppend(name, " #getCity()#" );
			}
			if( !isNull(getStateCode()) ) {
				name = listAppend(name, " #getStateCode()#" );
			}
			if( !isNull(getPostalCode()) ) {
				name = listAppend(name, " #getPostalCode()#" );
			}
			if( !isNull(getCountryCode()) ) {
				name = listAppend(name, " #getCountryCode()#" );
			}
			variables.addressName = name; 
		}
		
		return variables.addressName;
	}
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attribute Values (one-to-many)    
 	public void function addAttributeValue(required any attributeValue) {    
  		arguments.attributeValue.setAddress( this );    
  	}    
  	public void function removeAttributeValue(required any attributeValue) {    
  		arguments.attributeValue.removeAddress( this );    
  	}
  	
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
			return name;
		} 
	}
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return 'addressName';
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		getAddressName();
		
		if(getCountryCode() == 'US'){
			variables.shortPostalCode = left(getPostalCode(), 5);
		}else{
			variables.shortPostalCode = getPostalCode();
		}
	}
	
	public void function preUpdate(){
		structDelete(variables,'addressName');
		getAddressName();
		
		if(getCountryCode() == 'US'){
			variables.shortPostalCode = left(getPostalCode(), 5);
		}else{
			variables.shortPostalCode = getPostalCode();
		}
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	public any function getPhone() {
		if(!isNull(getPhoneNumber())) {
			return getPhoneNumber();
		}
		return "";
	}
	
	// ==================  END:  Deprecated Methods ========================
	public string function getAddressURL() {
		return "/#setting('globalUrlKeyAddress')#/#getUrlTitle()#/";
	}
	
}

