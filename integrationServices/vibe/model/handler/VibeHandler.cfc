component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('vibe');
		}
		return variables.integration;
	}
	
	
	public void function afterInfotraxAccountCreateSuccess(required any slatwallScope, required any account, required any data={}){
		writelog(file='vibe',text="in 'afterInfotraxAccountCreateSuccess' account: #arguments.account.getAccountID()#, data: #arguments.data#');

		try{
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.account.getAccountID(),
				baseObject      = "Account",
				processMethod   = 'push',
				integrationID   = getIntegration().getIntegrationID()
			);
		 }catch( any e){
		 	writelog(file="vibe",text="Error in afterInfotraxAccountCreateSuccess() :#e.message#");
		 	if(!getIntegration().setting('liveModeFlag')){
		 		rethrow;
		 	}
		 }
	}
	
}