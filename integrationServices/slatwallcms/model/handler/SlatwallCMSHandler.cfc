component {
	
	// This event handler will always get called
	function setupGlobalRequestComplete() {
		// If the domain matches a slatwallCMS application site, then render that site. UNLESS the path has "/admin", then do nothing
		
		// myApp = create an object of /custom/apps/slatwallcms/sitex/Application.cfc
		// myApp.runRequestActions();
		// writeOutput(myApp.generateRenderedContent());
		// abort;
	}
	// Special Function to relay all events called in Slatwall over to mura
	public void function onEvent( required any slatwallScope, required any eventName ) {
		if(arguments.eventName == 'setupGlobalRequestComplete'){
			//try to get a site form the domain name
			var site = arguments.slatwallScope.getService('siteService').getCurrentRequestSite();
			//if a site does exist then check that site directory for the template
			if(!isnull(site)){
				if(directoryExists(arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & site.getApp().getAppID() & '/' & site.getSiteID())) {
					var siteDirectory = arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & site.getApp().getAppID() & '/' & site.getSiteID();
				}else{
					throw('site directory does not exist');
				}
			}
		}
		
	}
}