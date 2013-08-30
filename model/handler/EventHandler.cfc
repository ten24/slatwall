component extends="Slatwall.org.Hibachi.HibachiObject" {

	public void function onEvent( required any eventName, required struct eventData={} ) {
		
		// Get the event triggers
		var eventTriggerEvents = getService("eventTriggerService").getEventTriggerEvents();
		
		// If the event name matches defined event trigger(s), then we can fire them
		if(structKeyExists(eventTriggerEvents, arguments.eventName)) {
			
			// Loop over each of the eventTriggers for this event
			for(eventTriggerDetails in eventTriggerEvents[ arguments.eventName ]) {
				
				// Event Trigger - Email
				if(eventTriggerDetails.eventTriggerType eq 'email') {
					
					getService("emailService").generateAndSendFromEntityAndEmailTemplateID(entity=arguments.entity, emailTemplateID=eventTriggerDetails.emailTemplateID);
					
				// Event Trigger - Print
				} else if(eventTriggerDetails.eventTriggerType eq 'print') {
					
					getService("printService").generateAndPrintFromEntityAndPrintTemplateID(entity=arguments.entity, printTemplateID=eventTriggerDetails.printTemplateID);
					
				}
				
			}
		}
	}
	
}