component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if(!structKeyExists(variables,'integration')){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('erpone');
		}
		return variables.integration;
	}
	
	private function addToQueue(required any entity){
		try {
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'pushAccountDataToErpOne',
				integrationID   = getIntegration().getIntegrationID()
			);
			
		}catch( any e) {
			if( getIntegration().setting('devMode') ){
				rethrow;
			}
		}
	}
	
	
	public void function afterAccountSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity);
	}
	
}