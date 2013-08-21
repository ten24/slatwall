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

	// Oracle Naming tests
	public void function oracle_entity_table_name_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			assert(len(getMetaData(entity).table) <= 30, "The table name for the #entityName# entity is longer than 30 characters in length which would break oracle support.  Table Name: #getMetaData(entity).table# Length:#len(getMetaData(entity).table)#");
		}
	}
	
	public void function oracle_entity_table_name_many_to_many_link_table_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			for(var property in entity.getProperties()) {
				if(structKeyExists(property, "fieldtype") && property.fieldtype == "many-to-many") {
					assert(len(property.linktable) <= 30, "In #entityName# entity the many-to-many property '#property.name#' has a link table that is longer than 30 characters in length which would break oracle support. Table Name: #property.linktable# Length:#len(property.linktable)#");
				}
			}
		}
	}
	
	public void function oracle_entity_column_name_max_len_30() {
		var ormClassMetaData = ORMGetSessionFactory().getAllClassMetadata();
		var ormEntityNames = listToarray(structKeyList(ormClassMetaData));
		
		for(var entityName in ormEntityNames) {
			var entity = entityNew( entityName );
			for(var property in entity.getProperties()) {
				if(!structKeyExists(property, "persistent") || property.persistent) {
					if(structKeyExists(property, "column")) {
						assert(len(property.column) <= 30, "In #entityName# entity the property '#property.name#' has a column name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.column)#");
					} else if(structKeyExists(property, "fieldtype") && listFindNoCase("many-to-one,one-to-many", property.fieldtype)) {
						assert(len(property.fkcolumn) <= 30, "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.fkcolumn)#");
					} else if(structKeyExists(property, "fieldtype") && listFindNoCase("many-to-many", property.fieldtype)) {
						assert(len(property.fkcolumn) <= 30, "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.fkcolumn)#");
						assert(len(property.inversejoincolumn) <= 30, "In #entityName# entity the property '#property.name#' has a fkcolumn name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.inversejoincolumn)#");
					} else {
						assert(len(property.name) <= 30, "In #entityName# entity the property '#property.name#' has a column name definition that is longer than 30 characters in length which would break oracle support. Length:#len(property.name)#");
					}
				}
			}
		}
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

}


