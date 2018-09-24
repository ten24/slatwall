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

		if(!entityQueue.getNewFlag()){
			//Process a single QUEUE item:
			
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
		}else if(structKeyExists(arguments, 'processObject') && structKeyExists(arguments.processObject,'collectionData')){
			//Process a collection of QUEUE
			var entityQueueIDsToBeDeleted = '';
			
			for(var entityQueue in arguments.processObject.collectionData){
				var entityService = getServiceByEntityName( entityName=entityQueue['baseObject'] );
				var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#", entityQueue['baseID'] );
				if(isNull(entity)){
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
					entityService.invokeMethod("process#entityQueue['baseObject']#_#entityQueue['processMethod']#", processData);
					entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
				}catch(any e){
				
				
				}
			}
			deleteEntityQueueItems(entityQueueIDsToBeDeleted);
		}else{
			//Build a queue collection list 
			var entityQueueCollection = getEntityQueueCollectionList();
			entityQueueCollection.setDisplayProperties('entityQueueID,baseObject,baseID,entityQueueData,processMethod');
			entityQueueCollection.setPageRecordsShow(20);
			entityQueueCollection.addOrderBy('modifiedDateTime|DESC');
			var entityQueuItems = entityQueueCollection.getPageRecords(formatRecords=false);
			
			return this.processEntityQueue_processQueue( this.newEntityQueue(), { 'collectionData' = entityQueuItems } );
		}
	
		return entityQueue;
	}
	
	
	public any function insertEntityQueueItem(required string entityID, required string entityName, required string entityQueueType, string entityQueueID = createHibachiUUID(), numeric priority = 2, numeric totalRetry=5){
		getHibachiEntityQueueDAO().insertEntityQueue(argumentCollection=arguments);
	}
	
	public void function deleteEntityQueueItems(required string entityQueueID){
		getHibachiEntityQueueDAO().deleteEntityQueues(entityQueueID);
	}
	
}
