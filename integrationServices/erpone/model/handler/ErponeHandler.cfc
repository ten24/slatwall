component extends='Slatwall.org.Hibachi.HibachiEventHandler' persistent="false" accessors="true" output="false"{
	
	property name="erpOneIntegrationCFC";
	
	private any function getIntegrationID(){
		if(!structKeyExists(variables, 'integrationID')){
			variables.integration = this.getErpOneIntegrationCFC().getIntegration().getIntegrationID();
		}
		return variables.integration;
	}
	
	private function addToQueue(required any entity){
		try {
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'pushAccountDataToErpOne',
				integrationID   = this.getIntegrationID()
			);
			
		}catch( any e) {
			if( this.getErpOneIntegrationCFC().setting('devMode') ){
				rethrow;
			}
		}
	}
	
	
	public void function afterAccountSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity);
	}
	
}