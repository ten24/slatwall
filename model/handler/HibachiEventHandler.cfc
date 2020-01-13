component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

	public void function onEvent( required any eventName, required struct eventData={} ) {

		// =============== WORKFLOW ==================

		// Make sure that there is an entity for this event
		if(structKeyExists(arguments, "entity") && isObject(arguments.entity)) {
			getService("workflowService").runAllWorkflowsByEventTrigger(argumentCollection=arguments);
		}
		
	}
	
	
	public void function beforeWorkflowTriggerPopulate(required any workflowTrigger, required numeric timeout){
		//Identify Entity Queue Workflow Trigger
		if(arguments.workflowTrigger.getWorkflowTriggerID() == '2ef0215ec344ba7a6c5d7e9529b64417'){
			//reset items that have an abandoned server
			getService('HibachiEntityQueueService').resetTimedOutEntityQueueItems(arguments.timeout);
			//reserve items based on fetchSize to be processed by specific server
			getService('HibachiEntityQueueService').claimEntityQueueItemsByServer(getHibachiScope().getServerInstanceID(),arguments.workflowTrigger.getCollectionFetchSize());
			arguments.workflowTrigger.getScheduleCollection().addFilter('serverInstance.serverInstanceID',getHibachiScope().getServerInstanceID());
		}
	}

}
