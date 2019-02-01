component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

	public void function onEvent( required any eventName, required struct eventData={} ) {

		// =============== WORKFLOW ==================

		// Make sure that there is an entity for this event
		if(structKeyExists(arguments, "entity") && isObject(arguments.entity)) {
			getService("workflowService").runAllWorkflowsByEventTrigger(argumentCollection=arguments);
		}
		
	}

}
