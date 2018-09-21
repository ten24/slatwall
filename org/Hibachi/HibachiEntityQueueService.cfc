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
	
	public void function processEntityQueue_processQueue( required any entityQueue, any processObject ={} ) {

		var entityService = getServiceByEntityName( entityName=arguments.entityQueue.getBaseObject() );
		var entity = entityService.invokeMethod( "get#arguments.entityQueue.getBaseObject()#", arguments.entityQueue.getBaseID() );
		var processContext = arguments.entityQueue.getProcessMethod();
		if(isNull(entity)){
			deleteEntityQueueItems(arguments.entityQueue.getEntityQueueID());
			return arguments.entityQueue;
		}
		
		var processContextIndex = '2';
		var processData = {'1'=entity};
		
		if(isJSON(entityQueue.getEntityQueueData())){
			processData['2'] = deserializeJSON(entityQueue.getEntityQueueData());
			processContextIndex = '3';
		}

		if(len(processContext) && entity.hasProcessObject(processContext)){
			processData[processContextIndex] = entity.getProcessObject(processContext);
		}
		
		try{
			entityService.invokeMethod("process#arguments.entityQueue.getBaseObject()#_#arguments.entityQueue.getProcessMethod()#", processData);
			deleteEntityQueueItems(arguments.entityQueue.getEntityQueueID());
		}catch(any e){
			if(!isNull(entityQueue.getLogHistoryFlag()) && entityQueue.getLogHistoryFlag()){
				addQueueHistory(entityQueue, true);
			}
		}
		
	}
	
	
	public any function insertEntityQueueItem(required string entityID, required string entityName, required string entityQueueType, string entityQueueID = createHibachiUUID(), numeric priority = 2, numeric totalRetry=5){
		getHibachiEntityQueueDAO().insertEntityQueue(argumentCollection=arguments);
	}
	
	public void function deleteEntityQueueItems(required string entityQueueID){
		getHibachiEntityQueueDAO().deleteEntityQueues(entityQueueID);
	}
	
}
