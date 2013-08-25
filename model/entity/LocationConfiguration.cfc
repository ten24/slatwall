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
component entityname="SlatwallLocationConfiguration" table="SwLocationConfiguration" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="this" {
	
	// Persistent Properties
	property name="locationConfigurationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationConfigurationName" ormtype="string";
	property name="activeFlag" ormtype="boolean" ;
	
	// Related Object Properties (Many-to-One)
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="parentLocationConfiguration" cfc="LocationConfiguration" fieldtype="many-to-one" fkcolumn="parentLocationConfigurationID";
	
	// Related Object Properties (One-to-Many)
	property name="locationConfigurations" singularname="locationConfiguration" cfc="LocationConfiguration" type="array" fieldtype="one-to-many" fkcolumn="locationConfigurationID" cascade="all-delete-orphan" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="locationConfigurationID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (Many-to-Many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SwSkuLocationConfiguration" fkcolumn="locationConfigurationID" inversejoincolumn="skuID";
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attribute Values (one-to-many)    
    	public void function addAttributeValue(required any attributeValue) {    
    		arguments.attributeValue.setLocationConfiguration( this );    
    	}    
    	public void function removeAttributeValue(required any attributeValue) {    
    		arguments.attributeValue.removeLocationConfiguration( this );    
    	}
	
	// Location (many-to-one)    
	public void function setLocation(required any location) {    
		variables.location = arguments.location;    
		if(isNew() or !arguments.location.hasLocationConfiguration( this )) {    
			arrayAppend(arguments.location.getLocationConfigurations(), this);    
		}    
	}    
	public void function removeLocation(any location) {    
		if(!structKeyExists(arguments, "location")) {    
			arguments.location = variables.location;    
		}    
		var index = arrayFind(arguments.location.getLocationConfigurations(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.location.getLocationConfigurations(), index);    
		}    
		structDelete(variables, "location");    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
