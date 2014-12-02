<!---

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
	
--->
<cfcomponent accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiDAO">
	
	<cffunction name="createSlatwallUUID" returntype="string" access="public">
		<cfreturn createHibachiUUID() />
	</cffunction>
	
	<cffunction name="reencryptData" returntype="void" access="public">
		<cfscript>
		super.reencryptData();
		
		var latestEncryptionDateTime = getService('hibachiUtilityService').getEncryptionPasswordArray()[1].createdDateTime;
		var entitiesMetaData = getService('hibachiService').getEntitiesMetaData();
		var updateStatements = [];
		
		var reencryptionMetaData = {};
		
		// Inspect all entity data for encrypted properties when necessary
		for (var entityName in entitiesMetaData) {
			
			// Get instance for inspection purposes
			var entityObject = getService('hibachiService').getEntityObject(entityName);
			var entityAlias = 'a#lCase(entityName)#';
			
			// Further proceed for entity that has any encrypted properties
			if ((structKeyExists(entityObject, 'getEncryptedPropertiesExistFlag') && entityObject.getEncryptedPropertiesExistFlag()) || entityName == 'Setting') {
				
				// Determine relevant fields and generate where clause for select statement
				var fieldNames = [entityObject.getPrimaryIDPropertyName()];
				var encryptedProperties = [];
				var whereClause = "";
				var mapClause = "#entityAlias#.#entityObject.getPrimaryIDPropertyName()# as #entityObject.getPrimaryIDPropertyName()#";
				
				var encyptedPropertiesStruct = entityObject.getEncryptedPropertiesStruct();
				if (entityName == 'Setting') {
					encyptedPropertiesStruct = {'settingValue' = {}};
				}
				
				// Add any encrypted properties to the select statement for retrieval
				for (var encryptedPropertyName in encyptedPropertiesStruct) {
					arrayAppend(encryptedProperties, encryptedPropertyName);
					arrayAppend(fieldNames, encryptedPropertyName);
					if (entityName == 'Setting' && encryptedPropertyName == 'settingValue') {
						arrayAppend(fieldNames, '#encryptedPropertyName#EncryptedDateTime');
						arrayAppend(fieldNames, '#encryptedPropertyName#EncryptedGenerator');
					} else {
						arrayAppend(fieldNames, '#encryptedPropertyName#DateTime');
						arrayAppend(fieldNames, '#encryptedPropertyName#Generator');
					}
					
					if (len(whereClause)) {
						whereClause &= "or ";
					}
					
					mapClause &= ', #entityAlias#.#encryptedPropertyName# as #encryptedPropertyName#';
					
					// Override behavior for Setting entity because it does not adhere to conventions
					if (entityName == 'Setting' && encryptedPropertyName == 'settingValue') {
						mapClause &= ', #entityAlias#.#encryptedPropertyName#EncryptedDateTime as #encryptedPropertyName#EncryptedDateTime';
						mapClause &= ', #entityAlias#.#encryptedPropertyName#EncryptedGenerator as #encryptedPropertyName#EncryptedGenerator';
						//whereClause &= '#entityAlias#.#encryptedPropertyName#EncryptedDateTime < :latestEncryptionDateTime';
						whereClause &= '#entityAlias#.#encryptedPropertyName#EncryptedDateTime < :latestEncryptionDateTime and #entityAlias#.#encryptedPropertyName#EncryptedGenerator is not null';
					} else {
						mapClause &= ', #entityAlias#.#encryptedPropertyName#DateTime as #encryptedPropertyName#DateTime';
						mapClause &= ', #entityAlias#.#encryptedPropertyName#Generator as #encryptedPropertyName#Generator';
						
						// Interested only in reencrypting the outdated encrypted records
						whereClause &= '#entityAlias#.#encryptedPropertyName#DateTime < :latestEncryptionDateTime ';
					}
				}
				
				// Build HQL statement
				if (structCount(encyptedPropertiesStruct)) {
					selectStatement = 'select new map( #mapClause# ) from #entityObject.getEntityName()# as #entityAlias# where #whereClause#';
					reencryptionMetaData['#entityName#'] = {
						'entityObject' = entityObject,
						'entityAlias' = entityAlias,
						'fieldNames' = fieldNames,
						'encryptedProperties' = encryptedProperties,
						'selectStatement' = selectStatement
					};
				}
			}
		}
		
		// Build update statements
		for (var entityName in reencryptionMetaData) {
			var rmd = reencryptionMetaData[entityName];
			
			// Execute sql statement to retrieve data
			var records = ormExecuteQuery(rmd.selectStatement, {latestEncryptionDateTime=latestEncryptionDateTime});
			
			for (var record in records) {
				var updateSetColumnClause = '';
				for (var encryptedPropertyName in rmd.encryptedProperties) {
					
					var generatorKey = '#encryptedPropertyName#Generator';
					if (entityName == 'Setting' && encryptedPropertyName == 'settingValue') {
						generatorKey = '#encryptedPropertyName#EncryptedGenerator';
					}
					
					var decryptedValue = getService('hibachiUtilityService').decryptValue(value=record[encryptedPropertyName],salt=record[generatorKey]);
					if (len(decryptedValue)) {
						var generatorValue = createHibachiUUID();
						var encryptedValue = getService('hibachiUtilityService').encryptValue(decryptedValue, generatorValue);
						
						// Determine if appending to update statement when multiple encrypted properties exist for an entity
						if (len(updateSetColumnClause)) {
							updateSetColumnClause &= ', ';
						}
						
						if (entityName == 'Setting' && encryptedPropertyName == 'settingValue') {
							updateSetColumnClause &= "#rmd.entityAlias#.#encryptedPropertyName#='#encryptedValue#', #rmd.entityAlias#.#encryptedPropertyName#EncryptedGenerator='#generatorValue#', #rmd.entityAlias#.#encryptedPropertyName#EncryptedDateTime=:nowDateTime";
						} else {
							updateSetColumnClause &= "#rmd.entityAlias#.#encryptedPropertyName#='#encryptedValue#', #rmd.entityAlias#.#encryptedPropertyName#Generator='#generatorValue#', #rmd.entityAlias#.#encryptedPropertyName#DateTime=:nowDateTime";
						}
					}
				}
				
				if (len(updateSetColumnClause)) {
					// Build update statement
					arrayAppend(updateStatements, "update #rmd.entityObject.getEntityName()# as #rmd.entityAlias# set #updateSetColumnClause# where #rmd.entityObject.getPrimaryIDPropertyName()#='#record[rmd.entityObject.getPrimaryIDPropertyName()]#'");
				}
			}
		}
		
		// TODO How do we specifically want to handle the batch updates as smaller units
		// Do we want to create threads? What scope should we store the update statements in memory ie. thread, variables?
		// Track the status of the task so it cannot again run without finishing
		// Could the TaskService be utilized for any of this?
		// At this point we have all of our update statements generated and ready to execute
		// Need to convert HQL statements to SQL equivalent if necessary
		for (var hqlStatement in updateStatements) {
			ormExecuteQuery(hqlStatement, {nowDateTime=now()});
		}
		</cfscript>
	</cffunction>
	
</cfcomponent>