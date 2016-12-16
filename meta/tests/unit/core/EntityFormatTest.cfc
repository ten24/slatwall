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
	
	public void function all_entity_properties_with_tomany_has_singularname() {
		//holds all errors
		var entitiesThatDontHaveSingularNameArray = [];
		
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		
		for(var entityName in allEntities) {
			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {
				if(
					structkeyExists(property,'fieldtype') 
					&& (property.fieldtype == 'one-to-many' || property.fieldtype == 'many-to-many')
				){
					//if we have a to-many then singularname should be defined
					if(!structkeyExists(property,'singularname')){
						arrayAppend(entitiesThatDontHaveSingularNameArray,{propertyName=property.name,entityName=entityName});
					}
				}

			}
		}
		
		
		assert(!arrayLen(entitiesThatDontHaveSingularNameArray));
	}
	
	public void function allcfcPropertiesAreCaseSensitive(){
		var allSpelledProperly = true;
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		for(var entityName in allEntities) {
			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {
				if(
					structkeyExists(property,'cfc') 
				){
					var longEntityName = 'Slatwall' & property.cfc;
					if(!ArrayFind(allEntities,longEntityName)){
						allSpelledProperly = false;
						addToDebug( '#entityName#:#property.name# cfc attribute #property.cfc# needs to be case-sensitive' );
					}
				}
			}
		}
		assert(allSpelledProperly);
	}

	//Entity Audit Properties Test
	public void function all_entity_properties_have_audit_properties() {

		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));

		var entitiesThatDontHaveAuditPropertiesArray = [];

		// Exception Entities with no properties
		var entitiesWithNoAuditPropsRequired = "SlatwallCommentRelationship,SlatwallAudit,SlatwallUpdateScript";

		// Exception Entities that only require the createdByAccountID & createdDateTime
		var entitiesWithCreatedOnlyProperties = "SlatwallComment,SlatwallEmail,SlatwallInventory,SlatwallPrint,SlatwallShippingMethodOption,SlatwallShippingMethodOptionSplitShipment,SlatwallStockReceiverItem,SlatwallEmailBounce";

		// Exception Entities that only required createdDateTime & modifiedDateTime
		var entitiesWithCreatedAndModifiedTimeOnlyProperties = "SlatwallSession";


		for(var entityName in allEntities) {

			if(!listFindNoCase(entitiesWithNoAuditPropsRequired, entityName)) {

				var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
				var auditPropertiesFoundCount = 0;

				for(var property in properties) {

					// If logic finds an audit property, break from this entity's properties loop
					if( (listFindNoCase(entitiesWithCreatedOnlyProperties, entityName) && listFindNoCase("createdDateTime,createdByAccountID", property.name))
						||
						(listFindNoCase(entitiesWithCreatedAndModifiedTimeOnlyProperties, entityName) && listFindNoCase("createdDateTime,modifiedDateTime", property.name))
						||
						(!listFindNoCase(entitiesWithCreatedOnlyProperties, entityName) && !listFindNoCase(entitiesWithCreatedAndModifiedTimeOnlyProperties, entityName) && listFindNoCase("createdDateTime,createdByAccountID,modifiedDateTime,modifiedByAccountID", property.name))
						) {
						var auditPropertiesFoundCount += 1;
					}

				}

				// If logic finds an audit property, break from this entity's properties loop
				if( (listFindNoCase(entitiesWithCreatedOnlyProperties, entityName) && auditPropertiesFoundCount != 2)
					||
					(listFindNoCase(entitiesWithCreatedAndModifiedTimeOnlyProperties, entityName) && auditPropertiesFoundCount != 2)
					||
					(!listFindNoCase(entitiesWithCreatedOnlyProperties, entityName) && !listFindNoCase(entitiesWithCreatedAndModifiedTimeOnlyProperties, entityName) && auditPropertiesFoundCount != 4)
					) {

					arrayAppend(entitiesThatDontHaveAuditPropertiesArray, entityName);

				}

			}

		}

		addToDebug(entitiesThatDontHaveAuditPropertiesArray);

		assert(!arrayLen(entitiesThatDontHaveAuditPropertiesArray));
	}

	//Misspell persistent Test
	public void function all_entity_properties_didnt_mispell_persistent() {

		var misspellCount = 0;
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));

		for(var entityName in allEntities) {

			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {

				// If logic finds an audit property, break from this entity's properties loop
				if(!structKeyExists(property, "persistent"))
					if(structKeyExists(property,"persistant") ||
					   structKeyExists(property,"persitent")
					 ){
						misspellCount++;
						addToDebug(entityName);
						addToDebug(property);
					}
				}

		}
		assert(misspellCount EQ 0);
	}

	//Misspell persistent Test
	public void function all_calculated_properties_are_setup_correctly() {

		var calculatedErrors = 0;
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));

		for(var entityName in allEntities) {

			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {

				if(left(property.name, 10) eq "calculated"){

					var metaData = getMetaData(entityNew( entityName ));
					var isFound = false;
					var nonPersistentPropertyName = right(property.name, len(property.name)-10);
					for(var func in metaData.functions){
						if(func.name == "get" & nonPersistentPropertyName){
							isFound = true;
							break;
						}
					}
					if(!isFound){
						calculatedErrors++;
						addToDebug(entityName);
					}
					isFound = false;
					for(var property in properties) {
						if(property.name == nonPersistentPropertyName
							&& structKeyExists(property,"persistent")
							&& lcase(property.persistent) eq "false"
						){
							isFound = true;
							break;
						}
					}
					if(!isFound){
						calculatedErrors++;
						addToDebug(entityName);
					}
				}

			}
		}
		assert(calculatedErrors EQ 0);
	}

	// Oracle Naming tests
	public void function oracle_entity_table_name_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		var pass = true;

		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			if(len(getMetaData(entity).table) > 30) {
				addToDebug("The table name for the #entityName# entity is longer than 30 characters in length which would break oracle support.  Table Name: #getMetaData(entity).table# Length:#len(getMetaData(entity).table)#");
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
						addToDebug( "In #entityName# entity the many-to-many property '#property.name#' has a link table that is longer than 30 characters in length which would break oracle support. Table Name: #property.linktable# Length:#len(property.linktable)#");
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
							addToDebug( "In #entityName# entity the property '#property.name#' has a column name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.column)#" );
							pass = false;
						}
					} else if(structKeyExists(property, "fieldtype") && listFindNoCase("many-to-one,one-to-many", property.fieldtype)) {
						if(len(property.fkcolumn) > 30) {
							addToDebug( "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.fkcolumn)#");
							pass = false;
						}
					} else if(structKeyExists(property, "fieldtype") && listFindNoCase("many-to-many", property.fieldtype)) {
						if(len(property.fkcolumn) > 30) {
							addToDebug( "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.fkcolumn)#");
							pass = false;
						}
						if(len(property.inversejoincolumn) > 30){
							addToDebug( "In #entityName# entity the property '#property.name#' has a inversejoincolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.inversejoincolumn)#");
							pass = false;
						}
					} else {
						if(len(property.name) > 30){
							addToDebug( "In #entityName# entity the property '#property.name#' has a column name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.name)#");
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
						addToDebug( "OTM-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #entityName# 'add#property.singularName#'");
					}
					// Check for 'remove' on this side
					if(findNoCase("function remove#property.singularname#", entityFile) && !listFindNoCase(validMethodsList, "#entityName#:remove#property.singularName#")) {
						pass = false;
						addToDebug( "OTM-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #entityName# 'remove#property.singularName#'");
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
								addToDebug( "MTO-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #thatEntityName# 'set#thatProperty.name#'");
							}
							// Check for 'remove' on that side
							if(findNoCase("function remove#thatProperty.name#", thatEntityFile) && !listFindNoCase(validMethodsList, "#thatEntityName#:remove#thatProperty.name#")) {
								pass = false;
								addToDebug( "MTO-BD-Helper: incorrect bidirectional helper method on extra lazy relationship - #thatEntityName# 'remove#thatProperty.name#'");
							}
						}
					}

				}
			}
		}

		assert(pass);
	}

	public void function all_smart_list_search_dont_have_errors() {
		// Get all entities
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));

		// Entities that cause known errors
		var exceptionErrorEntities = [];

		// Sets up the "Long Search Phrase" search keyword
		var searchData = {};
		searchData.keywords = "ThisIsALongSearchStringThatShouldReturnNoResults";

		// Loops over all of the entities and tests entity smartlists using the search keyword
		for(var entityName in allEntities){

			try{
				var entityService = request.slatwallScope.getService("hibachiService").getServiceByEntityName( entityName );
				var smartList = entityService.invokeMethod("get#replace(entityName, 'Slatwall', '', 'all')#SmartList", {1=searchData});
				smartList.getPageRecords();
			} catch (any e) {
				arrayAppend(exceptionErrorEntities, entityName);
				arrayAppend(exceptionErrorEntities, e.message);
			}

		}

		addToDebug( exceptionErrorEntities );

		assert(!arrayLen(exceptionErrorEntities));
	}

	public void function all_smart_list_search_return_no_results_with_invalid_keywords() {
		// Get all entities
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));

		// Entities that cause known errors
		var nonFilteredEntities = [];

		// Sets up the "Long Search Phrase" search keyword
		var searchData = {};
		searchData.keywords = "ThisIsALongSearchStringThatShouldReturnNoResults";

		// Loops over all of the entities and tests entity smartlists using the search keyword
		for(var entityName in allEntities){

			var entityService = request.slatwallScope.getService("hibachiService").getServiceByEntityName( entityName );
			var smartList = entityService.invokeMethod("get#replace(entityName, 'Slatwall', '', 'all')#SmartList", {1=searchData});
			if(arrayLen(smartList.getPageRecords())) {
				arrayAppend(nonFilteredEntities, entityName);
			}

		}

		addToDebug( nonFilteredEntities );

		assert(!arrayLen(nonFilteredEntities));
	}
	
	//this function makes sure that many-to-many relationships are not using cascade delete. 
	public void function check_delete_cascade_of_many_to_many_associations() {
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		
		var criminalsMessage = "";

		for(var entityName in allEntities) {
			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {
				
				if (
					structKeyExists(property, "fieldtype") 
					&& property.fieldtype == "many-to-many" 
					&& structKeyExists(property, "cascade") 
					&& findNoCase('delete', property.cascade)
					&& !structKeyExists(property,'allowcascade')
				   ) {
					criminalsMessage &= "entityName=#entityName# propertyName=#property.name#, <br>";
				}	
							
			}			
		}
		
		assert(
			len(criminalsMessage) == 0,
			criminalsMessage
		);
		
	}
	
	//This function checks if a persistant property (not cfc) uses type instead of ormtype to define the datatype
	public void function check_persistant_nonCFC_properties_that_use_type() {
		var allEntities = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
		
		var criminalsMessage = "";

		for(var entityName in allEntities) {
			var properties = request.slatwallScope.getService("hibachiService").getPropertiesByEntityName(entityName);
			for(var property in properties) {
				if (
						(
							!structKeyExists(property,'persistent')
							 ||(
							 	structKeyExists(property,'persistent') 
							 	&& property.persistent
							   )
						)
						&& !structKeyExists(property, "cfc") 
						&& structKeyExists(property, "type") 
						&& property.type != 'any'
				   ) {
					criminalsMessage &= "entityName=#entityName# propertyName=#property.name# #property.type#, <br>"&chr(10)&chr(13);
				}
			}			
		}
		assert(
			len(criminalsMessage) == 0,
			criminalsMessage
		);
	}

}
