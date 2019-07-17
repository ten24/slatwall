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

				try{
					var noMethod = !structKeyExists(entityQueue, 'processMethod') || 
									isNull(entityQueue['processMethod']) || 
								    !len(entityQueue['processMethod']);  

					if(noMethod) { 
						entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
						continue;
					}
				
					var entityService = getServiceByEntityName( entityName=entityQueue['baseObject'] );
					var hasIntegrationPackageService = structKeyExists(entityQueue, 'integration_integrationPackage') && len(trim(entityQueue['integration_integrationPackage']));  
					var hasIntegration = structKeyExists(entityQueue, "integrationID") && !isNull(entityQueue['integrationID']) && len(trim(entityQueue['integrationID'])) 			

					if(hasIntegration || hasIntegrationPackageService){
						
						if(!hasIntegrationPackageService) { 
							var integration = getService("IntegrationService").getIntegrationByIntegrationID(entityQueue['integrationID']);
							entityQueue['integration_integrationPackage'] = integration.getIntegrationPackage();
						}  				
						
						entityService = getService("#entityQueue['integration_integrationPackage']#Service")
					}

					var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#", {1= entityQueue['baseID'] });
					if(isNull(entity)){
						entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
						continue;
					}

					var entityValidForMethod = true; //it may not be a processContext

					//not necessarily a processMethod
					var method = entityQueue['processMethod']; 
					var hasEntityQueueData = structKeyExists(entityQueue, 'entityQueueData') && isJSON(entityQueue['entityQueueData']); 
					var entityQueueData = {};
					if(hasEntityQueueData){
						entityQueueData = deserializeJson(entityQueue['entityQueueData']); 
					}
	
					var hasProcessContext = left(method, 7) == 'process' || listLen(method, '_') > 1;
					var processContext = ''; 
					var methodData = entityQueueData;  	
		
					if(hasProcessContext){
						processContext = listLast(method, '_');//listlast to equate processEntity_processContext & processContext
						
						if(entity.hasProcessObject(processContext)){
							entityValidForMethod = getHibachiValidationService().validate(entity, processContext, false);//don't set errors
						} else { 
							entityQueueIDsToBeDeleted = listAppend(entityQueueIDsToBeDeleted, entityQueue['entityQueueID']);
							continue;
						}
			
					} else if(entityValidForMethod) {
						methodData = { '1'=entity };
						if(hasEntityQueueData){
							methodData['2'] = entityQueueData;
						}	
						entityService.invokeMethod("#entityQueue['processMethod']#", methodData);
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
