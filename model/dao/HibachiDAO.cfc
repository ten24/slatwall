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
	<cfscript>
		public void function reencryptData(numeric batchSizeLimit=0){
		
		
			var batchSizeLimitFlag = arguments.batchSizeLimit > 0;
			var batchSizeLimitReachedFlag = false;
			
			var latestEncryptionDateTime = getService('hibachiUtilityService').getEncryptionPasswordArray()[1].createdDateTime;
			var nowDateTime = now();
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
						
						if (len(whereClause)) {
							whereClause &= " or ";
						}
						
						// Convention is to add 'DateTime' or 'Generator' to encrypted property name
						var encryptedDateTimePropertyName = '#encryptedPropertyName#DateTime';
						var encryptedGeneratorPropertyName = '#encryptedPropertyName#Generator';
						
						// Handle Setting entity because it does not adhere to naming convention
						if (entityName == 'Setting' && encryptedPropertyName == 'settingValue') {
							encryptedDateTimePropertyName = '#encryptedPropertyName#EncryptedDateTime';
							encryptedGeneratorPropertyName = '#encryptedPropertyName#EncryptedGenerator';
						}
						
						mapClause &= ', #entityAlias#.#encryptedPropertyName# as #encryptedPropertyName#';
						mapClause &= ', #entityAlias#.#encryptedDateTimePropertyName# as #encryptedDateTimePropertyName#';
						mapClause &= ', #entityAlias#.#encryptedGeneratorPropertyName# as #encryptedGeneratorPropertyName#';
						
						// Interested only in reencrypting the outdated encrypted records
						// HQL parameter binding ignoring time portion in comparison
						// whereClause &= '(#entityAlias#.#encryptedDateTimePropertyName# < :latestEncryptionDateTime';
						whereClause &= '(#entityAlias#.#encryptedDateTimePropertyName# < ''#dateFormat(latestEncryptionDateTime, "yyyy-mm-dd")# #timeFormat(latestEncryptionDateTime, "HH:mm:ss")#''';
						
						// Add additional where condition for Setting entity to determine whether value is encrypted or not
						if (entityName == 'Setting' && encryptedPropertyName == 'settingValue') {
							whereClause &= ' and #entityAlias#.#encryptedGeneratorPropertyName# is not null';
						}
						
						whereClause &= ')';
					}
					
					// Build HQL statement
					if (structCount(encyptedPropertiesStruct)) {
						selectStatement = 'select new map( #mapClause# ) from #entityObject.getEntityName()# as #entityAlias# where #whereClause#';
						reencryptionMetaData['#entityName#'] = {
							'entityObject' = entityObject,
							'entityAlias' = entityAlias,
							'encryptedProperties' = encryptedProperties,
							'selectStatement' = selectStatement
						};
					}
				}
			}
			
			// Build update statements
			for (var entityName in reencryptionMetaData) {
				var rmd = reencryptionMetaData[entityName];
				
				// Execute sql select statement to retrieve data
				var queryOptions = {};
				if (batchSizeLimitFlag) {
					queryOptions.maxResults = batchSizeLimit;
				}

				var records = ormExecuteQuery(rmd.selectStatement,  false, queryOptions);
				
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
								//updateSetColumnClause &= "#rmd.entityAlias#.#encryptedPropertyName#='#encryptedValue#', #rmd.entityAlias#.#encryptedPropertyName#EncryptedGenerator='#generatorValue#', #rmd.entityAlias#.#encryptedPropertyName#EncryptedDateTime='#dateFormat(nowDateTime, "yyyy-mm-dd")# #timeFormat(nowDateTime, "HH:mm:ss")#'";
							} else {
								updateSetColumnClause &= "#rmd.entityAlias#.#encryptedPropertyName#='#encryptedValue#', #rmd.entityAlias#.#encryptedPropertyName#Generator='#generatorValue#', #rmd.entityAlias#.#encryptedPropertyName#DateTime=:nowDateTime";
								//updateSetColumnClause &= "#rmd.entityAlias#.#encryptedPropertyName#='#encryptedValue#', #rmd.entityAlias#.#encryptedPropertyName#Generator='#generatorValue#', #rmd.entityAlias#.#encryptedPropertyName#DateTime='#dateFormat(nowDateTime, "yyyy-mm-dd")# #timeFormat(nowDateTime, "HH:mm:ss")#'";
							}
						}
					}
					
					if (len(updateSetColumnClause)) {
						// Build update statement
						arrayAppend(updateStatements, "update #rmd.entityObject.getEntityName()# as #rmd.entityAlias# set #updateSetColumnClause# where #rmd.entityObject.getPrimaryIDPropertyName()#='#record[rmd.entityObject.getPrimaryIDPropertyName()]#' and #rmd.entityAlias#.#generatorKey#='#record[generatorKey]#'");
					}
				}
				
				// Decrement to fetch the batch size remaining
				if (batchSizeLimitFlag) {
					batchSizeLimit -= arraylen(records);
					
					// Batch size limit reached, stop generating sql statements
					if (batchSizeLimit <= 0) {
						batchSizeLimitReachedFlag = true;
						break;
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
				ormExecuteQuery(hqlStatement, {nowDateTime=nowDateTime});
			}
	}
	</cfscript>
	
	<cffunction name="verifyUniqueTableValue" returntype="boolean">
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="column" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset var rs="" />
		
		<cfquery name="rs">
			SELECT #arguments.column# FROM #arguments.tableName# WHERE #arguments.column# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#" /> 
		</cfquery>
		
		<cfif rs.recordCount>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="verifyUniquePropertyValue" returntype="boolean">
		<cfargument name="entityName" type="string" required="true" />
		<cfargument name="propertyName" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfset var result = ORMExecuteQuery("SELECT COUNT(#arguments.propertyName#) FROM #arguments.entityName# WHERE #arguments.propertyName# = :value",{value=arguments.value},true)/>
		<cfreturn result eq 0/>
	</cffunction>
	
</cfcomponent>
