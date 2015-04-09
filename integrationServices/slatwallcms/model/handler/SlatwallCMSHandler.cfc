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
	//announced event should send eventdata of appid,siteid,contentURL
	public void function onEvent( required any slatwallScope, required any eventName, struct eventData = {} ) {
		if(arguments.eventName == 'setupGlobalRequestComplete'){
			//try to get a site form the domain name
			var domainNamesite = arguments.slatwallScope.getService('siteService').getCurrentRequestSite();
			
			if(!isnull(domainNamesite)){
				
				var app = arguments.slatwallScope.getService('appService').getAppByAppID(arguments.eventData.appID);
				
				//if siteid is not specified then try to get the first site from the app
				if(isNull(arguments.eventData.siteID)){
					if(arraylen(app.getSites())){
						var site = app.getSites()[1];
					}
				}else{
					var site = arguments.slatwallScope.getService('siteService').getSiteBySiteID(arguments.eventData.siteID);
				}
				//if we obtained a site and it is allowed by the domain name then prepare to render content
				if(!isNull(site) && domanNameSite.getSiteID() == site.getSiteID()){
					//if a site does exist then check that site directory for the template
					if(directoryExists(arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID())) {
						var siteDirectory = arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID();
					}else{
						throw('site directory does not exist for ' & site.getSiteName());
					}
				}
			}
		}
		
	}
}