component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('connect');
		}
		return variables.integration;
	}
	
	
	public void function afterInfotraxAccountCreateSuccess(any slatwallScope, any entity, any eventData){
		dump("in 'afterInfotraxAccountCreateSuccess' account: #arguments.entity.getPrimaryIDValue()#");
		
		writelog(file='connect',text="in 'afterInfotraxAccountCreateSuccess' accountID: #arguments.entity.getPrimaryIDValue()#");

		try{
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				integrationID   = getIntegration().getIntegrationID()
			);
		 }catch( any e){
		 	writelog(file='connect',text="Error in afterInfotraxAccountCreateSuccess() :#e.message#");
		 	if(!getIntegration().setting('liveModeFlag')){
		 		rethrow;
		 	}
		 }
	}
	
}