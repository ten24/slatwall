component accessors="true" output="false" extends="HibachiService" {
	
	property name="hibachiEntityQueueDAO" type="any";
	

	public any function getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegrationAndEntityQueueData(required string baseObject, required string baseID, required string entityQueueType, required any integration, required entityQueueData){
		return getHibachiEntityQueueDAO().getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegrationAndEntityQueueData(argumentCollection=arguments);
	}


	public void function addQueueHistory(required any entityQueue, required boolean success){
		var entityQueueHistory = this.newEntityQueueHistory();
		entityQueueHistory.setEntityQueueType(arguments.entityQueue.getEntityQueueType());
		entityQueueHistory.setBaseObject(arguments.entityQueue.getBaseObject());
		entityQueueHistory.setBaseID(arguments.entityQueue.getBaseID());
		entityQueueHistory.setEntityQueueHistoryDateTime(arguments.entityQueue.getEntityQueueDateTime());
		entityQueueHistory.setSuccessFlag(arguments.success);
		entityQueueHistory = this.saveEntityQueueHistory(entityQueueHistory);
	}

	public any function processEntityQueueArray(required array entityQueueArray, useThread = false){
			
		if(!arraylen(arguments.entityQueueArray)){
			return;
		}
		
		if(arguments.useThread == true && !getService('hibachiUtilityService').isInThread()){
			var threadName = "updateCalculatedProperties_#replace(createUUID(),'-','','ALL')#";
			thread name="#threadName#" entityQueueArray="#arguments.entityQueueArray#" {
				processEntityQueueArray(entityQueueArray, false);
			}
		}else{
			var entityQueueIDsToBeDeleted = '';
			
			for(var entityQueue in arguments.entityQueueArray){
			
				var entityService = getServiceByEntityName( entityName=entityQueue['baseObject'] );
				var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#", {1= entityQueue['baseID'] });
				if(isNull(entity) || !len(entityQueue['processMethod'])){
					entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
					continue;
				}
				var processContextIndex = '2';
				var processData = { '1'=entity };
				
				if(isJSON(entityQueue['entityQueueData'])){
					processData['2'] = deserializeJSON(entityQueue['entityQueueData']);
					processContextIndex = '3';
				}
	
				if(len(entityQueue['processMethod']) && entity.hasProcessObject(entityQueue['processMethod'])){
					processData[processContextIndex] = entity.getProcessObject(entityQueue['processMethod']);
				}
				
				try{
					if(structKeyExists(entityQueue, 'integration_integrationPackage') && len(trim(entityQueue['integration_integrationPackage']))){
						getService("#entityQueue['integration_integrationPackage']#Service").invokeMethod("#entityQueue['processMethod']#", processData);
					}else if(structKeyExists(entityQueue, "integrationID") && !isNull(entityQueue['integrationID']) && len(trim(entityQueue['integrationID']))) { 
						var integration = getService("IntegrationService").getIntegrationByIntegrationID(entityQueue['integrationID']);
						entityQueue['integration_integrationPackage'] = integration.getIntegrationPackage();
						getService("#entityQueue['integration_integrationPackage']#Service").invokeMethod("#entityQueue['processMethod']#", processData);
					}else{
						entityService.invokeMethod("#entityQueue['processMethod']#", processData);
					}
					entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
					ormflush();
				}catch(any e){
					getHibachiEntityQueueDAO().updateModifiedDateTimeAndMostRecentError(entityQueue['entityQueueID'], e.message & " - processEntityQueue_processQueueArray");
				}
			}
			if(listLen(entityQueueIDsToBeDeleted)){
				deleteEntityQueueItems(entityQueueIDsToBeDeleted);
			}

		}
	}
	
	

	public any function insertEntityQueueItem(required string baseID, required string baseObject, string processMethod='', any entityQueueData={}, string entityQueueType = '', string entityQueueID = createHibachiUUID()){
		getHibachiEntityQueueDAO().insertEntityQueue(argumentCollection=arguments);
	}
	
	public void function deleteEntityQueueItems(required string entityQueueID){
		getHibachiEntityQueueDAO().deleteEntityQueues(entityQueueID);
	}
	
	public void function updateModifiedDateTime(required string entityQueueID){
		getHibachiEntityQueueDAO().updateModifiedDateTime(entityQueueID);
	}
	
}
