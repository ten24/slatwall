component extends='Slatwall.org.Hibachi.HibachiEventHandler' {
	
	private any function getIntegration(){
		if ( !structKeyExists(variables,'integration') ) {
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage('infotrax');
		}
		return variables.integration;
	}
	
	
	
	public void function onEvent(required any eventName, required struct eventData={}){
		
		
		 try {
			//Only focus on entity events
			if ( !structKeyExists(arguments,'entity') ) {
				return;
			}
			
			
			// Sync any pending order after account creation
			if( arguments.eventName == 'afterInfotraxAccountCreateSuccess' ) {
				ormFlush();
				var orders = getService('infoTraxService').pendingPushOrders(arguments.entity.getPrimaryIDValue());
				for(var order in orders){
					getDAO('HibachiEntityQueueDAO').insertEntityQueue(
						baseID          = order['orderID'],
						baseObject      = 'Order',
						processMethod   = 'push',
						entityQueueData = { 'event' = 'afterOrderSaveSuccess' },
						integrationID   = getIntegration().getIntegrationID()
					);
				}
				return;
			}
	
			if ( !getService('infoTraxService').isEntityQualified(arguments.entity.getClassName(), arguments.entity.getPrimaryIDValue(), arguments.eventName) ) {
				return;
			}
			
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = 'push',
				entityQueueData = { 'event' = arguments.eventName },
				integrationID   = getIntegration().getIntegrationID()
			);
		 } catch( any e) {
		 	if ( !getIntegration().setting('liveModeFlag') ) {
		 		rethrow;
		 	}
		 }
	}
	
}