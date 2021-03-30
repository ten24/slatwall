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
	
	
	// will move the entity-queue to entity-queue-failure 
	public any function processEntityQueueFailure_reQueue(required any entityQueueFailure){

	    this.getHibachiEntityQueueDAO().reQueueEntityQueueFailure( arguments.entityQueueFailure.getEntityQueueFailureID() );
	    return arguments.entityQueueFailure;
	}

	// will move the entity-queue to entity-queue-failure 
	public any function processEntityQueue_archive(required any entityQueue){

	    this.getHibachiEntityQueueDAO().archiveEntityQueue( arguments.entityQueue.getEntityQueueID(), arguments.entityQueue.getMostRecentError() );
	    return arguments.entityQueue;
	}
	
	
	public void function resetTimedOutEntityQueueItems(required numeric timeout){
		getHibachiEntityQueueDAO().resetTimedOutEntityQueueItems(argumentCollection=arguments);	
	}

	public void function claimEntityQueueItemsByServer(required any collection, required numeric fetchSize){
		getHibachiEntityQueueDAO().claimEntityQueueItemsByServer(argumentCollection=arguments);
	}

	//delegates to processEntityQueueArray so we're not maintaining one function for object and one for hash map
	//entry point will always be from workflow which should pass collectionData  
	public any function processEntityQueue_processQueue(required any entityQueue, struct data={}){
		
		var maxTryCount = 3;
		var retryDelay = 0;
		
		if(structKeyExists(arguments.data, 'workflowTrigger') && isNumeric(arguments.data.workflowTrigger.getMaxTryCount())){
			maxTryCount = arguments.data.workflowTrigger.getMaxTryCount();
		}
		
		if(structKeyExists(arguments.data, 'workflowTrigger') && isNumeric(arguments.data.workflowTrigger.getRetryDelay())){
			retryDelay = arguments.data.workflowTrigger.getRetryDelay();
		}
		
		if(structKeyExists(arguments.data, 'collectionData')){
			this.processEntityQueueArray(entityQueueArray=arguments.data.collectionData, maxTryCount=maxTryCount, retryDelay=retryDelay); 
		} else if(!entityQueue.getNewFlag()){
			var entityQueueArray = [ arguments.entityQueue.getStructRepresentation() ];
			this.processEntityQueueArray(entityQueueArray=entityQueueArray, maxTryCount=maxTryCount, retryDelay=retryDelay); 
		} 
		return arguments.entityQueue;
	}

	//attempts to find integration service otherwise gets service by entity name	
	private any function getServiceForEntityQueue(required struct entityQueue){ 
		
		var hasIntegrationPackageService = structKeyExists(entityQueue, 'integration_integrationPackage') && len(trim(entityQueue['integration_integrationPackage']));  
		var hasIntegration = structKeyExists(entityQueue, 'integration_integrationID') && !isNull(entityQueue['integration_integrationID']) && len(trim(entityQueue['integration_integrationID'])) 			

		if(hasIntegration || hasIntegrationPackageService){
			
			if(!hasIntegrationPackageService) { 
				var integration = getService("IntegrationService").getIntegrationByIntegrationID(entityQueue['integration_integrationID']);
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

		var hasProcessContext = left(method, 7) == 'process' && listLen(method, '_') > 1;
		var processContext = ''; 

		if(hasProcessContext){
			processContext = listLast(method, '_');//listlast to equate processEntity_processContext & processContext
			
			var hibachiErrors = getHibachiValidationService().validate(entity, processContext, false);//don't set errors on object
			entityValidToInvoke = !hibachiErrors.hasErrors();
			
			if(entityValidToInvoke){
				arguments.entity = 	arguments.service.process(arguments.entity, entityQueueData, processContext); 	
				entityValidToInvoke = !arguments.entity.hasErrors();
				if(!entityValidToInvoke){
					this.logHibachi('entity queue encountered errors after invoking process #serializeJson(arguments.entity.getErrors())#',true);
				} 
			}else{
				throw('Validation Errors: '&serializeJson(hibachiErrors.getErrors()));
			}
			
		} else {
			
			var methodData = { '1'=entity };
			if(hasEntityQueueData){
				methodData['2'] = entityQueueData;
			}	
			
			var entityOrAnything = arguments.service.invokeMethod("#entityQueue['processMethod']#", methodData);

			if( !isNull(entityOrAnything) && isObject(entityOrAnything) ){   // then assuming it's will be an entity

			    arguments.entity = entityOrAnything;

			    entityValidToInvoke = !arguments.entity.hasErrors();

				if( !entityValidToInvoke ){
				    throw('Entity queue encountered errors after invoking #entityQueue["processMethod"]#: '&serializeJson(arguments.entity.getErrors()) );
				}
			}
		}
		
		return entityValidToInvoke;
	} 
 

	public any function processEntityQueueArray(required array entityQueueArray, boolean useThread = false, numeric maxTryCount = 3, numeric retryDelay = 0){

		if( !arraylen(arguments.entityQueueArray) ){
		    this.logHibachi("EntityQueue - processEntityQueueArray() - entityQueueArray is empty, skipping this call");
			return;
		}
	
		if(arguments.useThread == true && !getService('hibachiUtilityService').isInThread()){
		
			var threadName = "updateCalculatedProperties_#replace(createUUID(),'-','','ALL')#";
			thread name="#threadName#" entityQueueArray="#arguments.entityQueueArray#" maxTryCount="#arguments.maxTryCount#" retryDelay="#arguments.retryDelay#" {
                
                this.processEntityQueueArray(
				    entityQueueArray = entityQueueArray, 
				    useThread        = false, 
				    maxTryCount      = maxTryCount, 
				    retryDelay       = retryDelay
				);
			}
			
		} else {
		    
			var entityQueueIDsToBeDeleted = '';
			var maxThreads = createObject( "java", "java.lang.Runtime" ).getRuntime().availableProcessors();
			
			arguments.entityQueueArray.each( function( entityQueue ){
			    
				var success = true;
				
				try{
				
					var noMethod = !structKeyExists(arguments.entityQueue, 'processMethod') || 
									isNull(arguments.entityQueue['processMethod']) || 
								    !len(arguments.entityQueue['processMethod']);  
	
					if(noMethod) { 
                        this.logHibachi("EntityQueue - processEntityQueueArray() did not find any processMethod in entityQueueData, deleting this record");
						this.deleteEntityQueueItem( arguments.entityQueue['entityQueueID'] );
						return;
					}
					
					var entityService = getServiceForEntityQueue(arguments.entityQueue);
	                if( len(arguments.entityQueue['baseID']) ){
					    // not passing the 2nd argument as true to return a new entity, so that we ignore bad entity-IDs;
					    var entity = entityService.invokeMethod( "get#arguments.entityQueue['baseObject']#", { 1=arguments.entityQueue['baseID']} );
	                } else {
	                    var entity = entityService.invokeMethod( "new#arguments.entityQueue['baseObject']#" );
	                }

					if( isNull(entity) ){
						this.logHibachi("EntityQueue - processEntityQueueArray() - entity is null, deleting this record #arguments.entityQueue['entityQueueID']#");
						this.deleteEntityQueueItem( arguments.entityQueue['entityQueueID'] );
						return;
					}
	
					var entityMethodInvoked = invokeMethodOrProcessOnService(arguments.entityQueue, entity, entityService);  
					
					if( entityMethodInvoked ){
						this.getHibachiScope().hibachiORMFlush();
					} else {
						ORMClearSession();
						this.getHibachiScope().setORMHasErrors(false);
					}
					
					this.deleteEntityQueueItem(arguments.entityQueue['entityQueueID'], true);
					
				} catch(any e){
					
					if(!structKeyExists(arguments.entityQueue,'tryCount') || isNull(arguments.entityQueue['tryCount'])){
						arguments.entityQueue['tryCount'] = 1; 
					}
					
					if(val(arguments.entityQueue['tryCount']) >= maxTryCount){
						getHibachiEntityQueueDAO().archiveEntityQueue(arguments.entityQueue['entityQueueID'], e.message);
					}else{
						getHibachiEntityQueueDAO().updateNextRetryDateAndMostRecentError(arguments.entityQueue['entityQueueID'], e.message);
					}
					
					if(this.getHibachiScope().setting("globalLogMessages") == "detail"){
						logHibachiException(e);
					}
				}
				
	
			
			}, true, maxThreads);
		}
	}
	
	

	public any function insertEntityQueueItem(required string baseID, required string baseObject, string processMethod='', any entityQueueData={}, string entityQueueType = '', string entityQueueID = createHibachiUUID()){
		getHibachiEntityQueueDAO().insertEntityQueue(argumentCollection=arguments);
	}
	
	public void function deleteEntityQueueItem(required string entityQueueID){
		getHibachiEntityQueueDAO().deleteEntityQueueItem(entityQueueID);
	}
	
	public void function updateModifiedDateTime(required string entityQueueID){
		getHibachiEntityQueueDAO().updateModifiedDateTime(entityQueueID);
	}
	
	
}
