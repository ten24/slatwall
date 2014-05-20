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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
	
	//Entity Audit Properties Test
	public void function all_entity_properties_have_audit_properties() {
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		var hasAuditProperties = true;
		var entitiesWithoutAuditProperties = "";
		//Exception Entities
		var entitiesWithNoProps = "SlatwallCommentRelationship,SlatwallAudit,SlatwallShortReference,SlatwallUpdateScript";
		var entitiesWithTwoProps = "SlatwallComment,SlatwallEmail,SlatwallInventory,SlatwallPrint,SlatwallShippingMethodOption,SlatwallStock,SlatwallStockReceiverItem";
		// SlatwallSession has createdDateTime & modifiedDateTime only
		var SlatwallSession = "SlatwallSession";
		
		for(var entityName in allEntities) {
			//Sets auditPropertyBoolean to 0 each loop
			var auditPropertyBoolean = 0;

			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			//Loop over all the properties checking for audit properties
			if((!listFindNoCase(entitiesWithNoProps, entityName)) && (!listFindNoCase(entitiesWithTwoProps, entityName))){
				for(var property in properties) {
					//If logic finds an audit property, break from this entity's properties loop
					if(structKeyExists(property, "name") && (listFindNoCase("createdDateTime,createdByAccountID,modifiedDateTime,modifiedByAccountID", property.name))){
						auditPropertyBoolean = 1;
						break;
					}
				}
				//If the entity's auditPropertyBoolean is 0 and entitiesWithoutAuditProperties list does not contain the new entity
				if (!listContains(entitiesWithoutAuditProperties, entityName) && auditPropertyBoolean == 0) {
					entitiesWithoutAuditProperties = listAppend(entitiesWithoutAuditProperties, entityName);
					hasAuditProperties = false;	
				}
			// Ensure that the Entities that are not supposed to have audit props, dont
			} else if((!listFindNoCase(entitiesWithNoProps, entityName))){
				for(var property in properties) {
					//If logic finds any audit properties, break
					if(structKeyExists(property, "name") && (!listFindNoCase("createdDateTime,createdByAccountID,modifiedDateTime,modifiedByAccountID", property.name))){
						auditPropertyBoolean = 1;
						break;
					}
				}
				//If the entity's auditPropertyBoolean is 0 and entitiesWithoutAuditProperties list does not contain the new entity
				if (!listContains(entitiesWithoutAuditProperties, entityName) && auditPropertyBoolean == 0) {
					entitiesWithoutAuditProperties = listAppend(entitiesWithoutAuditProperties, entityName);
					hasAuditProperties = false;	
				}
			// Loop over the entities that are only supposed to have createdDateTime & createdByAccountID only have those two
			} else if((listFindNoCase(entitiesWithTwoProps, entityName))){
				for(var property in properties) {
					//If logic finds the correct audit properties, break
					if((structKeyExists(property, "name"))
							&& (listFindNoCase("createdDateTime,createdByAccountID", property.name) 
							&& (!listFindNoCase("modifiedDateTime,modifiedByAccountID", property.name)))){
						
						auditPropertyBoolean = 1;
						break;
					}
				}
				//If the entity's auditPropertyBoolean is 0 and entitiesWithoutAuditProperties list does not contain the new entity
				if (!listContains(entitiesWithoutAuditProperties, entityName) && auditPropertyBoolean == 0) {
					entitiesWithoutAuditProperties = listAppend(entitiesWithoutAuditProperties, entityName);
					hasAuditProperties = false;	
				}
			} else if((listFindNoCase(SlatwallSession, entityName))){
				for(var property in properties) {
					//If logic finds the correct audit properties, break
					if((structKeyExists(property, "name"))
							&& (listFindNoCase("createdDateTime,modifiedDateTime", property.name) 
							&& (!listFindNoCase("createdByAccountID,modifiedByAccountID", property.name)))){
						
						auditPropertyBoolean = 1;
						break;
					}
				}
				//If the entity's auditPropertyBoolean is 0 and entitiesWithoutAuditProperties list does not contain the new entity
				if (!listContains(entitiesWithoutAuditProperties, entityName) && auditPropertyBoolean == 0) {
					entitiesWithoutAuditProperties = listAppend(entitiesWithoutAuditProperties, entityName);
					hasAuditProperties = false;	
				}
			}
		}

		entitiesWithoutAuditPropertiesArr = listToArray(entitiesWithoutAuditProperties);
		
		for(i = 1; i <= ArrayLen(entitiesWithoutAuditPropertiesArr); i++){
			debug(entitiesWithoutAuditPropertiesArr[i]);
		}
		assert(hasAuditProperties);
	}
	
	// Oracle Naming tests
	public void function oracle_entity_table_name_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		var pass = true;
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			if(len(getMetaData(entity).table) > 30) {
				arrayAppend(variables.debugArray, "The table name for the #entityName# entity is longer than 30 characters in length which would break oracle support.  Table Name: #getMetaData(entity).table# Length:#len(getMetaData(entity).table)#");
				pass = false;
			}
		}
		
		assert(pass);
	}
	
	public void function oracle_entity_table_name_many_to_many_link_table_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		var pass = true;
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			for(var property in entity.getProperties()) {
				if(structKeyExists(property, "fieldtype") && property.fieldtype == "many-to-many") {
					if(len(property.linktable) > 30) {
						arrayAppend(variables.debugArray, "In #entityName# entity the many-to-many property '#property.name#' has a link table that is longer than 30 characters in length which would break oracle support. Table Name: #property.linktable# Length:#len(property.linktable)#");
						pass = false;
					}
				}
			}
		}
		
		assert(pass);
	}
	
	public void function oracle_entity_column_name_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		var pass = true;
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			for(var property in entity.getProperties()) {
				if(!structKeyExists(property, "persistent") || property.persistent) {
					if(structKeyExists(property, "column")) {
						if(len(property.column) > 30) {
							arrayAppend(variables.debugArray, "In #entityName# entity the property '#property.name#' has a column name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.column)#");	
							pass = false;
						}
					} else if(structKeyExists(property, "fieldtype") && listFindNoCase("many-to-one,one-to-many", property.fieldtype)) {
						if(len(property.fkcolumn) > 30) {
							arrayAppend(variables.debugArray, "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.fkcolumn)#");
							pass = false;
						}
					} else if(structKeyExists(property, "fieldtype") && listFindNoCase("many-to-many", property.fieldtype)) {
						if(len(property.fkcolumn) > 30) {
							arrayAppend(variables.debugArray, "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.fkcolumn)#");
							pass = false;
						}
						if(len(property.inversejoincolumn) > 30){
							arrayAppend(variables.debugArray, "In #entityName# entity the property '#property.name#' has a inversejoincolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.inversejoincolumn)#");
							pass = false;
						}
					} else {
						if(len(property.name) > 30){
							arrayAppend(variables.debugArray, "In #entityName# entity the property '#property.name#' has a column name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.name)#");
							pass = false;
							
						}
					}
				}
			}
		}
		
		assert(pass);
	}
	
	// Table Name Prefixes
	public void function table_name_starts_with_sw() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			assert(left(getMetaData(entity).table,2) == "Sw", "The table name for the #entityName# entity is longer than 30 characters in length which would break oracle support.  Table Name: #getMetaData(entity).table# Length:#len(getMetaData(entity).table)#");
		}
	}
	
	public void function table_name_starts_with_sw_on_many_to_many_link_table() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			for(var property in entity.getProperties()) {
				if(structKeyExists(property, "fieldtype") && property.fieldtype == "many-to-many") {
					assert(left(property.linktable,2) == "Sw", "In #entityName# entity the many-to-many property '#property.name#' has a link table that is longer than 30 characters in length which would break oracle support. Table Name: #property.linktable# Length:#len(property.linktable)#");
				}
			}
		}
	}
	
	// Bi Directional Helpers
	public void function extra_lazy_properties_have_no_bidirectional_helpers() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		
		// This variable logs valid method overrides that don't need to be removed
		var validMethodsList = "SlatwallOrderFulfillment:setShippingMethod";
		
		var pass = true;
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			var entityProperties = entity.getProperties();
			var entityFile = fileRead(getMetaData(entity).path);
			for(var property in entity.getProperties()) {
				if((!structKeyExists(property, "persistent") || property.persistent) && structKeyExists(property, "fieldtype") && listFindNoCase("one-to-many", property.fieldtype) && structKeyExists(property, "lazy") && property.lazy == "extra") {
					// Check for 'add' on this side
					if(findNoCase("function add#property.singularname#", entityFile) && !listFindNoCase(validMethodsList, "#entityName#:add#property.singularName#")) {
						pass = false;
						arrayAppend(variables.debugArray, "OTM-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #entityName# 'add#property.singularName#'");
					}
					// Check for 'remove' on this side
					if(findNoCase("function remove#property.singularname#", entityFile) && !listFindNoCase(validMethodsList, "#entityName#:remove#property.singularName#")) {
						pass = false;
						arrayAppend(variables.debugArray, "OTM-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #entityName# 'remove#property.singularName#'");
					}
					
					var thatEntityName = "Slatwall#property.cfc#";
					var thatEntity = entityNew( thatEntityName );
					var thatEntityProperties = thatEntity.getProperties();
					var thatEntityFile = fileRead(getMetaData(thatEntity).path);
					for(var thatProperty in thatEntityProperties) {
						if(structKeyExists(thatProperty, "fkcolumn") && thatProperty.fkcolumn == property.fkcolumn) {
							// Check for 'set' on that side
							if(findNoCase("function set#thatProperty.name#", thatEntityFile) && !listFindNoCase(validMethodsList, "#thatEntityName#:set#thatProperty.name#")) {
								pass = false;
								arrayAppend(variables.debugArray, "MTO-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #thatEntityName# 'set#thatProperty.name#'");
							}
							// Check for 'remove' on that side
							if(findNoCase("function remove#thatProperty.name#", thatEntityFile) && !listFindNoCase(validMethodsList, "#thatEntityName#:remove#thatProperty.name#")) {
								pass = false;
								arrayAppend(variables.debugArray, "MTO-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #thatEntityName# 'remove#thatProperty.name#'");
							}
						}
					}
					
				}
			}
		}
		
		assert(pass);
	}

}