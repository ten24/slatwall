component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('soundconcepts');
		}
		return variables.integration;
	}
	
	
	public void function afterInfotraxAccountCreateSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity);
	}
	
	public void function afterAccountMarketPartnerUpgradeSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity);
	}
	
	public void function addToQueue(required any entity){
		if(arguments.entity.getAccountType() != 'marketPartner'){
			return;
		}
		
		try {
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				integrationID   = getIntegration().getIntegrationID()
			);
		}
		
		catch( any e) {
			if(!getIntegration().setting('liveModeFlag')){
				rethrow;
			}
		}
	}
	
}