component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('vibe');
		}
		return variables.integration;
	}
	
	private function addToQueue(required any entity){
		try {
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				integrationID   = getIntegration().getIntegrationID()
			);
			
		}catch( any e) {
			if( !getIntegration().setting('liveModeFlag') ){
				rethrow;
			}
		}
	}
	
	
	public void function afterInfotraxAccountCreateSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity);
	}
	
	
	public void function afterAccountUpgradeSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity.getAccount());
	}
	
	
	
	
	
}
