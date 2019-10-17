component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('vibe');
		}
		return variables.integration;
	}
	
	
	public void function onEvent(required any eventName, required struct eventData={}){
		
		try{
			//Only focus on entity events
			if(!structKeyExists(arguments,'entity')){
				return;
			}

			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				entityQueueData = { 'event' = arguments.eventName },
				integrationID   = getIntegration().getIntegrationID()
			);
		 }catch( any e){
		 	if(!getIntegration().setting('liveModeFlag')){
		 		rethrow;
		 	}
		 }
	}
	
}