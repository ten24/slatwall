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
			
			if(entityValidToInvoke){
			
				arguments.entity = 	arguments.service.process(arguments.entity, entityQueueData, processContext); 	
				
				entityValidToInvoke = !arguments.entity.hasErrors();
				if(!entityValidToInvoke){
					this.logHibachi('entity queue encountered errors after invoking process #serializeJson(arguments.entity.getErrors())#',true);
				}
				
			} else {
				throw('Validation Errors: '&serializeJson(hibachiErrors.getErrors()));
			}
			
		} else {
		    
			var methodData = { '1'=entity };
			
			if( hasEntityQueueData ){
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

		if(!arraylen(arguments.entityQueueArray)){
			return;
		}
	
		if(arguments.useThread == true && !getService('hibachiUtilityService').isInThread()){
			var threadName = "updateCalculatedProperties_#replace(createUUID(),'-','','ALL')#";
			thread name="#threadName#" entityQueueArray="#arguments.entityQueueArray#" maxTryCount="#arguments.maxTryCount#" retryDelay="#arguments.retryDelay#" {
				processEntityQueueArray(entityQueueArray=entityQueueArray, useThread=false, maxTryCount=maxTryCount, retryDelay=retryDelay);
			}
		}else{
			var entityQueueIDsToBeDeleted = '';
			var maxThreads = createObject( "java", "java.lang.Runtime" ).getRuntime().availableProcessors();
			var entityQueueIDsToBeDeletedArray = arguments.entityQueueArray.each( function( entityQueue ){
				try{
					var noMethod = !structKeyExists(entityQueue, 'processMethod') || 
									isNull(entityQueue['processMethod']) || 
								    !len(entityQueue['processMethod']);  
	
					if(noMethod) { 
						return;
					}
				
					var entityService = getServiceForEntityQueue(entityQueue);
	                
	                if( len(entityQueue['baseID']) ){
	                    
					    // not passing the 2nd argument as true to return a new entity, so that we ignore bad entity-IDs;
					    var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#", {1= entityQueue['baseID']} );
	                    
	                } else if( len(entityQueue['remoteID']) ){
	                    
	                    var entity = entityService.invokeMethod( "get#entityQueue['baseObject']#ByRmoteID", {1=entityQueue['remoteID']} );

	                } else {
	                    
	                    var entity = entityService.invokeMethod( "new#entityQueue['baseObject']#" );
	                }
	                
	                
					if( isNull(entity) ){
						return entityQueue['entityQueueID'];
					}
	
					var entityMethodInvoked = invokeMethodOrProcessOnService(entityQueue, entity, entityService);  
					
					if(entityMethodInvoked){
						ormflush();
					} else {
						ORMClearSession();
						getHibachiScope().setORMHasErrors(false);
					}
					deleteEntityQueueItem(entityQueue['entityQueueID']);
				}catch(any e){
					if(val(entityQueue['tryCount']) >= maxTryCount){
						getHibachiEntityQueueDAO().archiveEntityQueue(entityQueue['entityQueueID'], e.message);
					}else{
						getHibachiEntityQueueDAO().updateNextRetryDateAndMostRecentError(entityQueue['entityQueueID'], e.message);
					}
					
					if(getHibachiScope().setting("globalLogMessages") == "detail"){
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
