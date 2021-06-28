component extends="Slatwall.integrationServices.BaseDataProviderHandler" implements="Slatwall.integrationServices.DataProviderHandlerInterface" {
	
	//event method for items that should be synced after a flush instead of on a schedule
	public void function entityQueuePushNow(array modifiedEntities){
		
		var integrationCFC = getIntegration().getIntegrationCFC('data');
		try{
			var syncFlag = integrationCFC.setting("realTimeSyncFlag");
		}catch(any e){
			logHibachi(e.message);
			return;
		}
		
		if (!isNull(syncFlag) && syncFlag == true){
			for(var entity in modifiedEntities){
				if(listFindNoCase('Sku,Stock,Product,SkuLocationQuantity',entity.getClassName())){
					getService('hibachiUtilityService').logMessage(message="Algolia - Add to Queue");
		    		var addedToQueue = false;
					for(var entityMapping in getHibachiScope().getService('algoliaService').getCustomMappings()){
						//If this mapping matches the slatwall object, then process it.
						if(lcase(entityMapping['remoteIndex']) == 'products_ny' || lcase(entityMapping['remoteIndex']) == 'products_hk'){
							var productEntity = "";
							switch(entity.getClassName()){
								case "Sku":
									productEntity = entity.getProduct();
									break;
								case "Stock":
									productEntity = entity.getSku().getProduct();
									break;
								case "Product":
									productEntity = entity;
									break;
							}
							if(isObject(productEntity)){
								//We will use this. for now, check for id and just call push.
								var entityData = {};
								var primaryIDPropertyName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(productEntity.getClassName());
								entityData[primaryIDPropertyName] = productEntity.getPrimaryIDValue();
								addEntityToQueue(productEntity,entityMapping);
								
								getService('hibachiUtilityService').logMessage(message="DEBUGEVENT - Adding event to queue #eventName#");
								
								addedToQueue = true;
							}
						}
						
					}
					getService('hibachiUtilityService').logMessage(message="Algolia - End Add To Queue");
				}
				
			}
		}
		
		
	}
	
	public void function onEvent(required any eventName, required struct eventData={}){
		
		
	}
	
	public void function onApplicationEnd(){
		
	}
	
	public boolean function shouldAddEntityToQueue(entity, entityMapping){
	    
	    var slatwallEntity = entityMapping.slatwallEntity;
	    var entityIdProperty = getService('hibachiService').getPrimaryIDPropertyNameByEntityName(slatwallEntity);
	    var entityId = arguments.entity.getPrimaryIDValue();
	    
		if (structKeyExists(entityMapping, "filters") && arrayLen(entityMapping['filters'])){
			var entityCollectionList = getService('hibachiService').invokeMethod('get#slatwallEntity#CollectionList');
			entityCollectionList.addFilter("#entityIdProperty#", entityID);
			for(var filter in entityMapping.filters){
				entityCollectionList.addFilter(argumentCollection=filter);
			}
		
			return entityCollectionList.getRecordsCount();
		}
		//else, it should go in the queue.
		return true;
	}
	
	public any function addEntityToQueue(required any entity, required struct entityMapping){
		
		try{
			if (shouldAddEntityToQueue(arguments.entity, arguments.entityMapping)){
				
				
				getService('hibachiUtilityService').logMessage(message="Algolia: Adding entity to queue");
				
				var entityQueueData = { checksum : hash(serializeJSON(arguments.entityMapping),'MD5')};
				entityQueueData['entityMapping']=arguments.entityMapping;
				
				getHibachiScope().addEntityQueueData(
					baseID = arguments.entity.getPrimaryIDValue(),
					baseObject = arguments.entity.getClassName(),
					processMethod = 'syncDataFromEntityQueue',
					integrationID = getIntegration().getIntegrationID(),
					entityQueueData = entityQueueData,
					integration_integrationPackage = 'algolia'
				);
			}
		
		}catch(any e){
			getService('hibachiUtilityService').logMessage(message="Algolia - failure to sync #arguments.entity.getClassName()# #arguments.entity.getPrimaryIDValue()#");
			getService('hibachiUtilityService').logMessage(message="#e.message#");
		}

	}

}
