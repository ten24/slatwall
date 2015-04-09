component {
	
	// This event handler will always get called
	function setupGlobalRequestComplete() {
		writeDump('testcms');abort;
		// If the domain matches a slatwallCMS application site, then render that site. UNLESS the path has "/admin", then do nothing
		
		// myApp = create an object of /custom/apps/slatwallcms/sitex/Application.cfc
		// myApp.runRequestActions();
		// writeOutput(myApp.generateRenderedContent());
		// abort;
	}
	// Special Function to relay all events called in Slatwall over to mura
	public void function onEvent( required any slatwallScope, required any eventName ) {
		writeDump('test');abort;
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			if(!structKeyExists(request.customMuraScopeKeys, "slatwall")) {
				request.customMuraScopeKeys.slatwall = arguments.slatwallScope;	
			}
			
			// If there was a request.siteID defined, then announce the event against that specific site.  This would typically happen on a Frontend mura request
			if(structKeyExists(request, "siteID")) {
				arguments.siteID = request.siteID;
				application.serviceFactory.getBean('$').init( arguments ).announceEvent("slatwall#arguments.eventName#");
				
			// If there was no siteID in the request the event probably originated in the Slatwall admin.  In this situation we need to re-announce to all sites that Slatwall is defined for
			} else {
				var asArr = getAssignedSiteIDArray();
				for(var i=1; i<=arrayLen(asArr); i++) {
					arguments.siteID = asArr[i];
					application.serviceFactory.getBean('$').init( arguments ).announceEvent("slatwall#arguments.eventName#");
				}
			}
		}
	}
}