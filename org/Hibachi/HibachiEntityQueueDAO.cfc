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
component extends="HibachiDAO" persistent="false" accessors="true" output="false" {

	property name="hibachiService" type="any";

	public array function getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegrationAndEntityQueueData(required string baseObject, required string baseID, required string entityQueueType, any integration, string entityQueueData){
		var hql = 'SELECT eq FROM #getApplicationValue('applicationKey')#EntityQueue eq where eq.baseID=:baseID AND baseObject=:baseObject AND entityQueueType=:entityQueueType ';
		var params = {baseID=arguments.baseID,baseObject=arguments.baseObject,entityQueueType=arguments.entityQueueType};
		if(structKeyExists(arguments,'integration')){
			hql &= ' AND integration=:integration ';
			params.integration = arguments.integration;
		}	
		if(structKeyExists(arguments,'entityQueueData')){
			hql &= ' AND entityQueueData=:entityQueueData ';
			params.entityQueueData = arguments.entityQueueData;
		}	
			
		return ORMExecuteQuery(
			hql,
			params
		);
	}
	
	
	public void function resetTimedOutEntityQueueItems(required numeric timeout){
		var queryService = new query();
		queryService.addParam(name='timeoutDateTime', value='#DateAdd("s",-1*arguments.timeout,now())#', CFSQLTYPE='CF_SQL_TIMESTAMP');
			
		var sql =	"UPDATE SwEntityQueue 
					SET serverInstanceKey=NULL
					WHERE 
						serverInstanceKey IS NOT NULL
						AND entityQueueProcessingDateTime < :timeoutDateTime
					";
						
		queryService.execute(sql=sql);
	}
	
	public any function claimEntityQueueItemsByServer(required any collection, required numeric fetchSize){
		
		var newCollection = arguments.collection.duplicateCollection();
		newCollection.addFilter('serverInstanceKey', 'NULL', 'IS');
		var entityQueueIDs = newCollection.getPrimaryIDList(fetchSize * 2);
		
		var queryService = new query();
		queryService.addParam(name='serverInstanceKey', value=getHibachiScope().getServerInstanceKey(), CFSQLTYPE='CF_SQL_STRING');
		queryService.addParam(name='entityQueueIDs', value=entityQueueIDs, CFSQLTYPE='CF_SQL_STRING', list=true);
		queryService.addParam(name='dateTimeNow', value='#now()#', CFSQLTYPE="CF_SQL_TIMESTAMP");
		
		var sql =	"UPDATE 
						SwEntityQueue 
					SET serverInstanceKey=:serverInstanceKey,
					entityQueueProcessingDateTime = :dateTimeNow
					WHERE 
						entityQueueID IN (:entityQueueIDs)
					AND
						serverInstanceKey IS NULL
					LIMIT
					#arguments.fetchSize#";
						
		return queryService.execute(sql=sql);
	}

	public void function bulkInsertEntityQueueByPrimaryIDs(required string primaryIDList, required string entityName, required string processMethod, boolean unique=false){
		var primaryIDPropertyName = getHibachiService().getPrimaryIDPropertyNameByEntityName(arguments.entityName);	
		var queryService = new query();
		var sql = "INSERT INTO SwEntityQueue (entityQueueID, baseObject, baseID, processMethod, createdDateTime, modifiedDateTime, createdByAccountID, modifiedByAccountID, tryCount) ";
		sql &= "SELECT LOWER(REPLACE(CAST(UUID() as char character set utf8),'-','')) as entityQueueID, "; 
		sql &= "'#arguments.entityName#' as baseObject, ";  
		sql &= "#primaryIDPropertyName# as baseID, ";
		sql &= "'#arguments.processMethod#' as processMethod, ";
		sql &= "now() as createdDateTime, ";
		sql &= "now() as modifiedDateTime, ";

		var accountID = 'NULL';
		if(!isNull(getHibachiScope().getAccount())){
			accountID = getHibachiScope().getAccount().getAccountID(); 
		}
		sql &= "'#accountID#' as createdByAccountID, ";
		sql &= "'#accountID#' as modifiedByAccountID, ";
		sql &= "0 as tryCount ";
		
		sql &= "FROM #getHibachiService().getTableNameByEntityName(arguments.entityName)# ";
		sql &= "WHERE #primaryIDPropertyName# in ('";

		//not paramatizing because cf query param has in list limit this allows us to do 10000+ insertions
		//because user can't control IDs this is safe
		sql &= replaceNoCase(arguments.primaryIDList, ",","','","all")  & "')";

		if(arguments.unique){
			sql &= " AND #primaryIDPropertyName# not in (";
			sql &= " SELECT baseID FROM swEntityQueue";
			sql &= " WHERE processMethod = :processMethod";
			sql &= ")";
		} 
	
		queryService.addParam(name='processMethod', value=arguments.processMethod, CFSQLTYPE="CF_SQL_VARCHAR");

		queryService.execute(sql=sql);
	} 

	public void function bulkInsertEntityQueueByFlagPropertyName(required string flagPropertyName, required string entityName, required string processMethod, boolean unique = false, boolean flagValue = true, struct entityQueueData = {} ){
		
		var primaryIDPropertyName = getHibachiService().getPrimaryIDPropertyNameByEntityName(arguments.entityName);	
		var queryService = new query();
		
		var sql = "INSERT INTO SwEntityQueue (entityQueueID, baseObject, baseID, processMethod, entityQueueData, createdDateTime, modifiedDateTime, createdByAccountID, modifiedByAccountID, tryCount) ";
		sql &= "SELECT LOWER(REPLACE(CAST(UUID() as char character set utf8),'-','')) as entityQueueID, "; 
		sql &= "'#arguments.entityName#' as baseObject, ";  
		sql &= "#primaryIDPropertyName# as baseID, ";
		sql &= "'#arguments.processMethod#' as processMethod, ";
		sql &= "'#serializeJson(arguments.entityQueueData)#' as entityQueueData, ";
		sql &= "now() as createdDateTime, ";
		sql &= "now() as modifiedDateTime, ";

		var accountID = 'NULL';
		if(!isNull(getHibachiScope().getAccount())){
			accountID = getHibachiScope().getAccount().getAccountID(); 
		}
		
		sql &= "'#accountID#' as createdByAccountID, ";
		sql &= "'#accountID#' as modifiedByAccountID, ";
		sql &= "0 as tryCount ";
		
		sql &= "FROM #getHibachiService().getTableNameByEntityName(arguments.entityName)# ";
		sql &= "WHERE #arguments.flagPropertyName# = :flagValue";
	
		if(arguments.unique){
			sql &= " AND #primaryIDPropertyName# not in (";
			sql &= " SELECT baseID FROM swEntityQueue";
			sql &= " WHERE processMethod = :processMethod";
			sql &= ")";
		}
	
		queryService.addParam(name='flagValue', value=arguments.flagValue, CFSQLTYPE="CF_SQL_BIT");
		queryService.addParam(name='processMethod', value=arguments.processMethod, CFSQLTYPE="CF_SQL_VARCHAR");

		queryService.execute(sql=sql);
	}	

	public void function insertEntityQueue(required string baseID, required string baseObject, string entityQueueID, string processMethod='', struct entityQueueData={}, string integrationID=''){

		if(!structKeyExists(arguments, 'entityQueueID')){
			var dataString = "#arguments.baseObject#_#arguments.baseID#_#arguments.processMethod#_#serializeJSON(arguments.entityQueueData)#";
			
			if (structKeyExists(arguments, "integrationID") && len(arguments.integrationID)){
				dataString = dataString & "_#integrationID#"; 
			}
			arguments.entityQueueID = hash(dataString, 'MD5');
		}
		
		var queryService = new query();
		queryService.addParam(name='entityQueueID', value='#arguments.entityQueueID#', CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='baseObject', value='#arguments.baseObject#', CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='baseID', value='#arguments.baseID#', CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='processMethod', value='#arguments.processMethod#', CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='entityQueueData', value='#serializeJSON(arguments.entityQueueData)#', CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='integrationID', value='#arguments.integrationID#', CFSQLTYPE="CF_SQL_STRING", null=len(trim(arguments.integrationID)) ? false : true);
		queryService.addParam(name='dateTimeNow', value='#now()#', CFSQLTYPE="CF_SQL_TIMESTAMP");
		
		if (structKeyExists(arguments, "entityQueueProcessingDateTime")){
			queryService.addParam(name='entityQueueProcessingDateTime', value='#arguments.entityQueueProcessingDateTime#', CFSQLTYPE="CF_SQL_TIMESTAMP");
		}else{
			queryService.addParam(name='entityQueueProcessingDateTime', CFSQLTYPE="CF_SQL_TIMESTAMP", null=true);
		}
		
		queryService.addParam(name='accountID', value='#getHibachiScope().getAccount().getAccountID()#', CFSQLTYPE="CF_SQL_STRING");
		
		var sql =	"INSERT IGNORE INTO
						SwEntityQueue (entityQueueID,baseObject,baseID,processMethod,entityQueueData,integrationID,createdDateTime,createdByAccountID,modifiedByAccountID,modifiedDateTime,tryCount,entityQueueProcessingDateTime)
					VALUES 
						(:entityQueueID,:baseObject,:baseID,:processMethod,:entityQueueData,:integrationID,:dateTimeNow,:accountID,:accountID,:dateTimeNow,1,:entityQueueProcessingDateTime)";
						
		queryService.execute(sql=sql);
	}
	
	public void function deleteEntityQueues(required string entityQueueIDs){
		var queryService = new query();
		queryService.addParam(name='entityQueueID',value='#arguments.entityQueueIDs#',CFSQLTYPE="CF_SQL_STRING", list="true");
		var sql = "DELETE FROM SwEntityQueue WHERE entityQueueID IN ( :entityQueueID )";


		queryService.execute(sql=sql);
	}
	
	public void function updateModifiedDateTimeAndMostRecentError(required string entityQueueID, required string errorMessage){
		var queryService = new query();
		queryService.addParam(name='entityQueueID',value='#arguments.entityQueueID#',CFSQLTYPE="CF_SQL_STRING", list="true");
		queryService.addParam(name='now',value='#now()#',CFSQLTYPE="CF_SQL_TIMESTAMP");
		queryService.addParam(name='errorMessage',value='#errorMessage#',CFSQLTYPE="CF_SQL_STRING");
		var sql = "UPDATE SwEntityQueue SET modifiedDateTime = :now, tryCount = tryCount + 1, mostRecentError=:errorMessage, serverInstanceKey = NULL WHERE entityQueueID = :entityQueueID";

		queryService.execute(sql=sql);
	}
	
	
	public void function bulkInsertEntityQueueFailures(required string entityQueueIDs ){
	
	
		var columns = 'baseObject, baseID, processMethod, entityQueueType, entityQueueDateTime, entityQueueData, mostRecentError, integrationID, createdDateTime, modifiedDateTime, createdByAccountID, modifiedByAccountID, tryCount';
		
		var insertQuery = new query();
		
		var sql = "INSERT INTO SwEntityQueueFailure (entityQueueFailureID, remoteID, #columns#) ";
		sql &= "SELECT LOWER(REPLACE(CAST(UUID() as char character set utf8),'-','')) as entityQueueFailureID, entitQueueID as remoteID, #columns#";
		sql &= "FROM swEntityQueue";
		sql &= "WHERE entityQueueID IN (:entityQueueIDs)";
		insertQuery.addParam(name='entityQueueIDs', value=arguments.entityQueueIDs, CFSQLTYPE="CF_SQL_VARCHAR", list=true);
		var inserts = insertQuery.execute(sql=sql);
		dd(inserts);
		
		var deleteQuery = new query();
		
		sql = "DELETE FROM swEntityQueue WHERE entityQueueID IN (:entityQueueIDs)";
		deleteQuery.addParam(name='entityQueueIDs', value=arguments.entityQueueIDs, CFSQLTYPE="CF_SQL_VARCHAR", list=true);
		deleteQuery.execute(sql=sql);
		
	}	
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
