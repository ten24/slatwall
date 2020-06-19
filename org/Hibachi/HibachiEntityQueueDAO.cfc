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
	
	public void function insertEntityQueue(required string baseID, required string baseObject, string processMethod='', string entityQueueID = createHibachiUUID()){
		var queryService = new query();
		queryService.addParam(name='entityQueueID',value='#arguments.entityQueueID#',CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='entityQueueType',value='#arguments.entityQueueType#',CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='baseObject',value='#arguments.baseObject#',CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='baseID',value='#arguments.baseID#',CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='processMethod',value='#arguments.processMethod#',CFSQLTYPE="CF_SQL_STRING");
		queryService.addParam(name='dateTimeNow',value='#now()#',CFSQLTYPE="CF_SQL_TIMESTAMP");
		queryService.addParam(name='accountID',value='#getHibachiScope().getAccount().getAccountID()#',CFSQLTYPE="CF_SQL_STRING");
		
		var sql =	"INSERT INTO 
						SwEntityQueue (entityQueueID,entityQueueType,baseObject,baseID,processMethod,createdDateTime,createdByAccountID,modifiedByAccountID,modifiedDateTime)
					VALUES 
						(:entityQueueID,:entityQueueType,:baseObject,:baseID,:processMethod,:dateTimeNow,:accountID,:accountID,:dateTimeNow)";
						
		queryService.execute(sql=sql);
	}
	
	public void function deleteEntityQueues(required string entityQueueIDs){
		var queryService = new query();
		queryService.addParam(name='entityQueueID',value='#arguments.entityQueueIDs#',CFSQLTYPE="CF_SQL_STRING", list="true");
		var sql = "DELETE FROM SwEntityQueue WHERE entityQueueID IN ( :entityQueueID )";
						
		queryService.execute(sql=sql);
	}

	public void function updateModifiedDateTime(required string entityQueueIDs){
		var queryService = new query();
		queryService.addParam(name='entityQueueID',value='#arguments.entityQueueIDs#',CFSQLTYPE="CF_SQL_STRING", list="true");
		queryService.addParam(name='now',value='#now()#',CFSQLTYPE="CF_SQL_DATE", list="true");
		var sql = "UPDATE SwEntityQueue SET modifiedDateTime = :now, tryCount= COALESCE(tryCount, 0) + 1  WHERE entityQueueID IN ( :entityQueueID )";
						
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