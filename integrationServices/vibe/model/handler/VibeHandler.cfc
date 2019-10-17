component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('vibe');
		}
		return variables.integration;
	}
	
	
	public void function afterInfotraxAccountCreateSuccess(required any slatwallScope, required any account, required any data={}){
		
		try{


			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				integrationID   = getIntegration().getIntegrationID()
			);
		 }catch( any e){
		 	if(!getIntegration().setting('liveModeFlag')){
		 		rethrow;
		 	}
		 }
	}
	
}