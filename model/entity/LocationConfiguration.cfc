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
component entityname="SlatwallLocationConfiguration" table="SwLocationConfiguration" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="locationService" hb_permission="this" {
	
	// Persistent Properties
	property name="locationConfigurationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="locationConfigurationName" ormtype="string";
	property name="locationConfigurationCapacity" ormtype="integer";
	property name="activeFlag" ormtype="boolean" ;
	
	// Related Object Properties (Many-to-One)
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	
	// Related Object Properties (One-to-Many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="locationConfigurationID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (Many-to-Many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SwSkuLocationConfiguration" fkcolumn="locationConfigurationID" inversejoincolumn="skuID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	//Non-persistent properties
	property name="locationTree" persistent="false";
	property name="locationPathName" persistent="false";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getLocationTree() {
		if(!structKeyExists(variables,"locationTree")) {
			variables.locationTree="";
			var locationOptions = this.getLocation().getLocationOptions();
			variables.locationTree = listAppend(variables.locationTree, locationOptions[1].name, ",");
		}
		return variables.locationTree; 
	}
	
	public any function getLocationPathName() {
		if(!structKeyExists(variables,"locationPathName")) {
			variables.locationPathName = this.getlocation().getLocationPathName();
		}
		return variables.locationPathName;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
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
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setLocationConfiguration( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeLocationConfiguration( this );    
	}
	
	// Skus (many-to-many - inverse)    
	public void function addSku(required any sku) {    
		arguments.sku.addLocationConfiguration( this );    
	}    
	public void function removeSku(required any sku) {    
		arguments.sku.removeLocationConfiguration( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

