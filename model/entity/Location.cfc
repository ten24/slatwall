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
component displayname="Location" entityname="SlatwallLocation" table="SwLocation" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="this" {
	
	// Persistent Properties
	property name="locationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationName" ormtype="string";
	
	// Related Object Properties (Many-to-One)
	property name="primaryAddress" cfc="LocationAddress" fieldtype="many-to-one" fkcolumn="locationAddressID";
	
	// Related Object Properties (One-to-Many)
	property name="locationAddresses" singularname="locationAddress" cfc="LocationAddress" type="array" fieldtype="one-to-many" fkcolumn="locationID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (Many-to-Many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="physicals" singularname="physical" cfc="Physical" type="array" fieldtype="many-to-many" linktable="SwPhysicalLocation" fkcolumn="locationID" inversejoincolumn="physicalID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public boolean function isDeletable() {
		return !(getService("LocationService").isLocationBeingUsed(this) || getService("LocationService").getLocationCount() == 1);
	}
	
	public any function getPrimaryAddress() {
		if(isNull(variables.primaryAddress)) {
			return getService("locationService").newLocationAddress();
		} else {
			return variables.primaryAddress;
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Location Addresses (one-to-many)
	public void function addLocationAddress(required any locationAddress) {
		arguments.locationAddress.setLocation( this );
	}
	public void function removeLocationAddress(required any locationAddress) {
		arguments.locationAddress.removeLocation( this );
	}
	
	// Physicals (many-to-many - inverse)
	public void function addPhysical(required any physical) {
		arguments.physical.addLocation( this );
	}
	public void function removePhysical(required any physical) {
		arguments.physical.removeLocation( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

