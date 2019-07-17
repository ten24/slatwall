component accessors="true" output="false" extends="HibachiService" {
	
	property name="hibachiValidationService" type="any";
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
			var entityQueueIDsToBeUpdated = '';
			
			for(var entityQueue in arguments.entityQueueArray){
			
				var entityService = getServiceByEntityName( entityName=entityQueue['baseObject'] );
				var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#", {1= entityQueue['baseID'] });
				var processContext = listLast(entityQueue['processMethod'], '_');
				var entityValidForContext = getHibachiValidationService().validate(entity, processContext, false); 
				this.logHibachi('entityValidForContext? #entityValidForContext#',true);
				if(isNull(entity) || !entityValidForContext){
					entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
					continue;
				}
	
				var processData = {}; 
				if(isJSON(entityQueue['entityQueueData'])){
					processData = deserializeJSON(entityQueue['entityQueueData']);
				}
				
				try{
					entityService.process(entity, processData, processContext);
					entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
					ormflush();
				}catch(any e){
					rethrow; 
					entityQueueIDsToBeUpdated = listAppend(entityQueueIDsToBeUpdated, entityQueue['entityQueueID']);
				}
			}
			if(listLen(entityQueueIDsToBeDeleted)){
				deleteEntityQueueItems(entityQueueIDsToBeDeleted);
			}
			if(listLen(entityQueueIDsToBeUpdated)){
				updateModifiedDateTime(entityQueueIDsToBeUpdated);
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
