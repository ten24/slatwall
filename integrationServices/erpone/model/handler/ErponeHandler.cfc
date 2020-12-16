component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	property name="erpOneIntegrationCFC";
	
	private function addToQueue(required any entity){
		try {
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'pushAccountDataToErpOne',
				integrationID   = this.erpOneIntegrationCFC().getIntegrationID()
			);
			
		}catch( any e) {
			if( this.erpOneIntegrationCFC().setting('devMode') ){
				rethrow;
			}
		}
	}
	
	
	public void function afterAccountSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity);
	}
	
}