component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('infotrax');
		}
		return variables.integration;
	}
	
	
	
	public void function onEvent(required any eventName, required struct eventData={}){
		try{
			//Only focus on entity events
			if(!structKeyExists(arguments,'entity')){
				return;
			}
	
			if(!getService('infoTraxService').isEntityQualified(arguments.entity.getClassName(), arguments.entity.getPrimaryIDValue(), eventName)){
				return;
			}
			
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				entityQueueData = { 'event' = eventName },
				integrationID   = getIntegration().getIntegrationID()
			);
		}catch( any e){
			//error
		}
	}
	
}