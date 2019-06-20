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

	public void function bulkInsertEntityQueueByPrimaryIDs(required string primaryIDList, required string entityName, required string processMethod, boolean unique=false){
		var primaryIDPropertyName = getHibachiService().getPrimaryIDPropertyNameByEntityName(arguments.entityName);	
		var queryService = new query();
		var sql = "INSERT INTO SwEntityQueue (entityQueueID, baseObject, baseID, processMethod, createdDateTime, modifiedDateTime, createdByAccountID, modifiedByAccountID) ";
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
		sql &= "'#accountID#' as modifiedByAccountID ";

		sql &= "FROM #getHibachiService().getTableNameByEntityName(arguments.entityName)# ";
		sql &= "WHERE #primaryIDPropertyName# in (:primaryIDList)";

		if(arguments.unique){
			sql &= " AND #primaryIDPropertyName# not in (";
			sql &= " SELECT baseID FROM swEntityQueue";
			sql &= " WHERE processMethod = :processMethod";
			sql &= ")";
		} 
	
		queryService.addParam(name='processMethod', value=arguments.processMethod, CFSQLTYPE="CF_SQL_VARCHAR");
		queryService.addParam(name='primaryIDList', value=arguments.primaryIDList, CFSQLTYPE="CF_SQL_VARCHAR");
		queryService.execute(sql=sql);
	} 
	
	public void function insertEntityQueue(required string entityID, required string entityName, required string entityQueueType){
		var queryService = new query();
		var sql = "INSERT INTO SwEntityQueue (entityQueueID,entityQueueType,baseObject,baseID,createdDateTime,createdByAccountID,modifiedByAccountID,modifiedDateTime);
			VALUES ('#createHibachiUUID()#','#arguments.entityQueueType#','#arguments.entityName#','#arguments.entityID#',:createdDateTime,'#getHibachiScope().getAccount().getAccountID()#',
				'#getHibachiScope().getAccount().getAccountID()#',:modifiedDatetime
			)
		";
		queryService.addParam(name='createdDateTime',value='#now()#',CFSQLTYPE="CF_SQL_TIMESTAMP");
		queryService.addParam(name='modifiedDateTime',value='#now()#',CFSQLTYPE="CF_SQL_TIMESTAMP");
		queryService.execute(sql=sql);
	}
	
	public void function addEntityToQueue(required any entity,required entityQueueType){
		
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
