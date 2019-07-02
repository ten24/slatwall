component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('infotrax');
		}
		return variables.integration;
	}
	
	
	
	public void function onEvent(required any eventName, required struct eventData={}){
		
		//Only focus on entity events
		if(!structKeyExists(arguments,'entity')){
			return;
		}

		var slatwallEntity="#arguments.entity.getClassName()#";
		var infoTraxMapping = getService('infoTraxService').getCustomMappings()
				
		for(var entityMapping in infoTraxMapping){
			//If this mapping matches the slatwall object, then process it.
			if(lcase(entityMapping['slatwallEntity']) != lcase(slatwallEntity)){
				continue;
			}
			
			//If syncEvent is set, only run on that event.
			if (structKeyExists(entityMapping, "syncEvent") && len(entityMapping.syncEvent) && entityMapping.syncEvent != eventName){
				continue
			}
				
			//Check if object pass the filters 
			if (!shouldAddEntityToQueue(arguments.entity, entityMapping)){
				continue;
			}
			
			

			getDAO('HibachiEntityQueueDAO').addEntityQueueData(
				baseID = arguments.entity.getPrimaryIDValue(),
				baseObject = arguments.entity.getClassName(),
				processMethod = 'push',
				entityQueueData = { checksum : hash(serializeJSON(entityMapping),'MD5')},
				integrationID = getIntegration().getIntegrationID()
			);

		}
	}

	
}