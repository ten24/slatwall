component accessors="true" output="false" extends="HibachiService" {

	public any function getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegrationAndEntityQueueData(required string baseObject, required string baseID, required string entityQueueType, required any integration, required entityQueueData){
		return getDao('hibachiEntityQueueDao').getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegrationAndEntityQueueData(argumentCollection=arguments);
	}

	public void function processEntityQueue_processQueue( required any entityQueue, required any processObject ) {

		//call process from Queued Entity
		var entityService = getServiceByEntityName( entityName=arguments.entityQueue.getBaseObject() );
		var processContext = arguments.entityQueue.getProcessMethod();
		var entity = entityService.invokeMethod( "get#arguments.entityQueue.getBaseObject()#", arguments.entityQueue.getBaseID() );
		var processData = { '1' = arguments.entity };

		if( arguments.entity.hasProcessObject( processContext ) ){
			processData['2'] = arguments.entity.getProcessObject( processContext );
		}

		entityService.invokeMethod( "process#arguments.entityQueue.getBaseObject()#_#arguments.entityQueue.getProcessMethod()#", processData );
	}

}
