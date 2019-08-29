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

	//delegates to processEntityQueueArray so we're not maintaining one function for object and one for hash map
	//entry point will always be from workflow which should pass collectionData  
	public any function processEntityQueue_processQueue(required any entityQueue, struct data={}){
		if(structKeyExists(arguments.data, 'collectionData')){
			this.processEntityQueueArray(arguments.data.collectionData); 
		} else if(!entityQueue.getNewFlag()){
			var entityQueueArray = [ arguments.entityQueue.getStructRepresentation() ];
			this.processEntityQueueArray(entityQueueArray); 
		} 
		return arguments.entityQueue;
	}

	//attempts to find integration service otherwise gets service by entity name	
	private any function getServiceForEntityQueue(required struct entityQueue){ 
		
		var hasIntegrationPackageService = structKeyExists(entityQueue, 'integration_integrationPackage') && len(trim(entityQueue['integration_integrationPackage']));  
		var hasIntegration = structKeyExists(entityQueue, "integrationID") && !isNull(entityQueue['integrationID']) && len(trim(entityQueue['integrationID'])) 			

		if(hasIntegration || hasIntegrationPackageService){
			
			if(!hasIntegrationPackageService) { 
				var integration = getService("IntegrationService").getIntegrationByIntegrationID(entityQueue['integrationID']);
				entityQueue['integration_integrationPackage'] = integration.getIntegrationPackage();
			}  				
			
			return getService("#entityQueue['integration_integrationPackage']#Service")
		}	
	
		return getServiceByEntityName( entityName=entityQueue['baseObject'] ); 
	} 

	//handles process method case & validates for context otherwise calls method on service returns true if method was invoked
	private boolean function invokeMethodOrProcessOnService(required struct entityQueue, required any entity, required any service){
		
		var entityValidToInvoke = true; //it may not be a processContext

		//not necessarily a processMethod
		var method = entityQueue['processMethod']; 
		
		var hasEntityQueueData = structKeyExists(entityQueue, 'entityQueueData') && isJSON(entityQueue['entityQueueData']); 
		var entityQueueData = {};
		if(hasEntityQueueData){
			entityQueueData = deserializeJson(entityQueue['entityQueueData']); 
		}

		var hasProcessContext = left(method, 7) == 'process' || listLen(method, '_') > 1;
		var processContext = ''; 

		if(hasProcessContext){
			processContext = listLast(method, '_');//listlast to equate processEntity_processContext & processContext
			
			var hibachiErrors = getHibachiValidationService().validate(entity, processContext, false);//don't set errors on object
			entityValidToInvoke = !hibachiErrors.hasErrors();
			//set validation errors on entity queue for tracking purposes? 	
			
			if(entityValidToInvoke){
				arguments.entity = 	arguments.service.process(arguments.entity, entityQueueData, processContext); 	
				entityValidToInvoke = !arguments.entity.hasErrors();
				if(!entityValidToInvoke){
					this.logHibachi('entity queue encountered errors after invoking process #serializeJson(arguments.entity.getErrors())#',true);
				} 
			}   
		} else if(entityValidToInvoke) {
			var methodData = { '1'=entity };
			if(hasEntityQueueData){
				methodData['2'] = entityQueueData;
			}	
			arguments.service.invokeMethod("#entityQueue['processMethod']#", methodData);
		}
		
		return entityValidToInvoke;
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

				try{
					var noMethod = !structKeyExists(entityQueue, 'processMethod') || 
									isNull(entityQueue['processMethod']) || 
								    !len(entityQueue['processMethod']);  

					if(noMethod) { 
						entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
						continue;
					}
				
					var entityService = getServiceForEntityQueue(entityQueue);

					var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#", {1= entityQueue['baseID'] });
					
					if(isNull(entity)){
						entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
						continue;
					}

					var entityMethodInvoked = invokeMethodOrProcessOnService(entityQueue, entity, entityService);  
					
					entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
				
					if(entityMethodInvoked){
						ormflush();
					} 
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
