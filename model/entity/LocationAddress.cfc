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
component displayname="Location Address" entityname="SlatwallLocationAddress" table="SwLocationAddress" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="location.locationAddresses" {
	
	// Persistent Properties
	property name="locationAddressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationAddressName" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID" hb_populateValidationContext="location";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties


	public any function getAddress() {
		if(isNull(variables.address)) {
			return getService("addressService").newAddress();
		} else {
			return variables.address;
		}
	}
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Location (many-to-one)
	public void function setLocation(required any location) {
		variables.location = arguments.location;
		if(isNew() or !arguments.location.hasLocationAddress( this )) {
			arrayAppend(arguments.location.getLocationAddresses(), this);
		}
	}
	public void function removeLocation(any location) {
		if(!structKeyExists(arguments, "location")) {
			arguments.location = variables.location;
		}
		var index = arrayFind(arguments.location.getLocationAddresses(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.location.getLocationAddresses(), index);
		}
		structDelete(variables, "location");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =============== START: Custom Validation Methods ====================
	public boolean function hasNoAssociatedOrders() {
		var locationConfigurationSmartList =  this.getLocation().getLocationConfigurationsSmartlist();
		locationConfigurationSmartList.joinRelatedProperty('SlatwallLocationConfiguration', 'skus');
		locationConfigurationSmartList.joinRelatedProperty('SlatwallSku', 'orderItems');

		if ( locationConfigurationSmartList.getRecordsCount() ) {
			return false;
		}else{
			return true;
		}
	}
	
	// ===============  END: Custom Validation Methods =====================

	// ================== START: Overridden Methods ========================
	public string function getSimpleRepresentation() {
		var simpleRepresentation = "";
		if(!isNull(getLocationAddressName())) {
			simpleRepresentation &= getLocationAddressName();
		}
		if(!isNull(getAddress())) {
			if(len(simpleRepresentation)) {
				simpleRepresentation &= " - ";	
			}
			simpleRepresentation &= getAddress().getSimpleRepresentation();
		}
		if(len(simpleRepresentation)) {
			return simpleRepresentation;
		}
		return rbKey('define.new');
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
