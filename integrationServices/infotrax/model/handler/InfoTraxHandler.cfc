component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('infotrax');
		}
		return variables.integration;
	}
	
	
	
	public void function onEvent(required any eventName, required struct eventData={}){
		//TODO: Uncomment this before going live
		//try{
			//Only focus on entity events
			if(!structKeyExists(arguments,'entity')){
				return;
			}
	
			if(!getService('infoTraxService').isEntityQualified(arguments.entity.getClassName(), arguments.entity.getPrimaryIDValue(), arguments.eventName)){
				return;
			}
			
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				entityQueueData = { 'event' = arguments.eventName },
				integrationID   = getIntegration().getIntegrationID()
			);
		// }catch( any e){
		// 	//error
		// }
	}
	
}