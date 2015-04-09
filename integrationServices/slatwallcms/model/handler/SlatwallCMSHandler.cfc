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
			var domainNamesite = arguments.slatwallScope.getService('siteService').getCurrentRequestSite();
			if(!isnull(domainNamesite)){
				//if domainNamesite exits do we have a route for it?
//				var routes = arguments.slatwallscope.getApplicationValue("application").getRoutes();
//				
//				if(structKeyExists){
//					
//				}
				
				//if a site does exist then check that site directory for the template
				if(directoryExists(arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID())) {
					var siteDirectory = arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID();
				}else{
					throw('site directory does not exist');
				}
				
			}
		}
		
	}
}