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
	Access Types
	============
	entity
	action
*/
component entityname="SlatwallPermissionRecordRestriction" table="SwPermissionRecordRestriction" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="permission.permissionGroup.permissions" {

	// Persistent Properties
	property name="permissionRecordRestrictionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="permissionRecordRestrictionName" column="permRecordRestrictionName" ormtype="string";
	property name="collectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query";
	property name="restrictionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query";
	property name="enforceOnDirectObjectReference" ormtype="boolean" default="false";
	// Related Object Properties (many-to-one)
	property name="permission" cfc="Permission" fieldtype="many-to-one" fkcolumn="permissionID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	property name="collectionConfigStruct" persistent="false";

	// ============ START: Non-Persistent Property Methods =================
	public boolean function getEnforceOnDirectObjectReference(){
		if(!structKeyExists(variables,'enforceOnDirectObjectReference')){
			variables.enforceOnDirectObjectReference = false;
		}
		return variables.enforceOnDirectObjectReference;
	}


	public string function getCollectionConfig(){
		return variables.collectionConfig;
	}

	public any function getCollectionConfigStruct(){
		if(isNull(variables.collectionConfigStruct)){
			variables.collectionConfigStruct = deserializeCollectionConfig();
		}
		return variables.collectionConfigStruct;
	}

	public void function setCollectionConfig(required string collectionConfig){
		variables.collectionConfig = trim(arguments.collectionConfig);
		//reinflate collectionConfigStruct if the collectionConfig is modified directly
		variables.collectionConfigStruct = deserializeCollectionConfig();
		//adjust restriction Config
		if(structKeyExists(variables.collectionConfigStruct,'filterGroups')){
			variables.restrictionConfig = serializeJson(variables.collectionConfigStruct['filterGroups']);
		}else{
			variables.restrictionConfig = serializeJson([]);
		}
	}

	public any function deserializeCollectionConfig(){
		return deserializeJSON(getCollectionConfig());
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Permission (many-to-one)
	public void function setPermission(required any permission){
		variables.permission = arguments.permission;
		if(!arguments.permission.hasPermissionRecordRestriction(this)){
			arrayAppend(arguments.permission.getPermissionRecordRestrictions(),this);
		}
		//after setting permission populate a default restriction config
		//based on the permission
		var entityName = variables.permission.getEntityClassName();
		var collectionEntity = getService('HibachiCollectionService').invokeMethod('get#entityName#CollectionList');
		setCollectionConfig(serializeJson(collectionEntity.getCollectionConfigStruct()));
	}

	public void function removePermission(any permission){
		if(!structKeyExists(arguments, 'permission')){
			arguments.permission = variables.permission;
		}
		var index = arrayFind(arguments.permission.getPermissionRecordRestrictions(),this);
		if(index > 0){
			arrayDeleteAt(arguments.permission.getPermissionRecordRestrictions(),index);
		}
		structDelete(variables,'permission');
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
