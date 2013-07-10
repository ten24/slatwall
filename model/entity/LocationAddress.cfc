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
component displayname="Location Address" entityname="SlatwallLocationAddress" table="SlatwallLocationAddress" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="location.locationAddresses" {
	
	// Persistent Properties
	property name="locationAddressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationAddressName" hb_populateEnabled="public" ormtype="string" hint="Nickname for this location Address";
	
	// Related Object Properties (many-to-one)
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID" hb_populateValidationContext="location";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
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

	// ================== START: Overridden Methods ========================
	public string function getSimpleRepresentation() {
		if(!getLocation().isNew()) {
			return "#getLocationAddressName()# - #getLocation().getSimpleRepresentation()#";
		}
		return rbKey('define.new');
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}