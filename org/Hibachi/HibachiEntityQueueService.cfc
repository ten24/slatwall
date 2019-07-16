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
	
	public any function processEntityQueue_processQueue( required any entityQueue, any processObject ={} ) {
		
		if(!entityQueue.getNewFlag()){
			//Process a single QUEUE item:
			
			var entityService = getServiceByEntityName( entityName=arguments.entityQueue.getBaseObject() );
			var entity = entityService.invokeMethod( "get#arguments.entityQueue.getBaseObject()#", {1=arguments.entityQueue.getBaseID()} );
			var processContext = arguments.entityQueue.getProcessMethod();
			if(isNull(entity) || !len(arguments.entityQueue.getProcessMethod())){
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
				if(!isNull(entityQueue.getIntegration()) && !isNull(entityQueue.getIntegration().getIntegrationPackage())){
					// override the default entity service.
					var entityServiceName = "#entityQueue.getIntegration().getIntegrationPackage()#Service";
					entityService = getService(entityServiceName);
					entityService.invokeMethod("#arguments.entityQueue.getProcessMethod()#", processData);
					
				//for other
				}else{
					entityService.invokeMethod("#entityQueue.getProcessMethod()#", processData);
				}
				
				deleteEntityQueueItems(arguments.entityQueue.getEntityQueueID());
			}catch(any e){
				rethrow;
				if(!isNull(entityQueue.getLogHistoryFlag()) && entityQueue.getLogHistoryFlag()){
					addQueueHistory(entityQueue, false);
				}
				this.saveEntityQueue(arguments.entityQueue);
				//update the error on the queue item.
				getHibachiEntityQueueDAO().updateModifiedDateTimeAndMostRecentError(arguments.entityQueue.getEntityQueueID(), e.message & " - processEntityQueue_processQueue");
			}
		}else if(structKeyExists(arguments, 'processObject') && structKeyExists(arguments.processObject,'collectionData')){
			//Process a collection of QUEUE
			processEntityQueueArray(arguments.processObject.collectionData);
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
					rethrow;
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
