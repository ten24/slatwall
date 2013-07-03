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
component displayname="Location" entityname="SlatwallLocation" table="SlatwallLocation" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="this" hb_parentPropertyName="parentLocation" {
	
	// Persistent Properties
	property name="locationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationIDPath" ormtype="string";
	property name="locationName" ormtype="string";
	property name="activeFlag" ormtype="boolean" ;
	
	// Related Object Properties (Many-to-One)
	property name="primaryAddress" cfc="LocationAddress" fieldtype="many-to-one" fkcolumn="locationAddressID";
	property name="parentLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="parentLocationID";
	
	// Related Object Properties (One-to-Many)
	property name="locationAddresses" singularname="locationAddress" cfc="LocationAddress" type="array" fieldtype="one-to-many" fkcolumn="locationID" cascade="all-delete-orphan" inverse="true";
	property name="childLocations" singularname="childLocation" cfc="Location" fieldtype="one-to-many" inverse="true" fkcolumn="parentLocationID" cascade="all";
	
	// Related Object Properties (Many-to-Many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="physicals" singularname="physical" cfc="Physical" type="array" fieldtype="many-to-many" linktable="SlatwallPhysicalLocation" fkcolumn="locationID" inversejoincolumn="physicalID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="parentLocationOptions" persistent="false";
	
	
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
	
	public any function getParentLocationOptions() {
		if(!structKeyExists(variables, "parentLocationOptions")) {
			var smartList = getPropertyOptionsSmartList( "parentLocation" );
			var records = smartList.getRecords();
			
			variables.parentLocationOptions = [
				{name=rbKey('define.none'), value=''}
			];
			
			for(var i=1; i<=arrayLen(records); i++) {
				if(records[i].getLocationID() != getLocationID()) {
					arrayAppend(variables.parentLocationOptions, {name=records[i].getSimpleRepresentation(), value=records[i].getLocationID()});	
				}
			}
		}
		return variables.parentLocationOptions;
	}
	
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
