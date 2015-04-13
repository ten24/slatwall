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
	public void function onEvent( required any slatwallScope, required any eventName) {
		if(arguments.eventName == 'setupGlobalRequestComplete' && !isnull(arguments.appID)){
			//try to get a site form the domain name
			
			var domainNameSite = arguments.slatwallScope.getService('siteService').getCurrentRequestSite();
			if(!isnull(domainNameSite)){
				var app = arguments.slatwallScope.getService('appService').getAppByAppID(arguments.appID);
				
				//if siteid is not specified then try to get the first site from the app
				if(isNull(arguments.siteID)){
					if(arraylen(app.getSites())){
						var site = app.getSites()[1];
					}
				}else{
					var site = arguments.slatwallScope.getService('siteService').getSiteBySiteID(arguments.siteID);
				}
				//if we obtained a site and it is allowed by the domain name then prepare to render content
				if(!isNull(site) && domainNameSite.getSiteID() == site.getSiteID()){
					//if a site does exist then check that site directory for the template
					if(isNull(arguments.conentURL)){
						
					}else{
						if(directoryExists(arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID())) {
							var siteDirectory = arguments.slatwallScope.getApplicationValue('applicationRootMappingPath') & '/apps/' & domainNamesite.getApp().getAppID() & '/' & domainNamesite.getSiteID();
							//now that we have the site directory, we should see if we can retrieve the content via the urltitle and site
							var content = arguments.slatwallScope.getService('contentService').getContentBySiteIDAndUrlTitle(site.getSiteID(),arguments.contentURL);
							if(isNull(content)){
								throw('content does not exists for #arguments.contentURL#');
							}
							var contentTemplateFile = content.Setting('contentTemplateFile');
							
						}else{
							throw('site directory does not exist for ' & site.getSiteName());
						}
					}
				}
			}
		}
	}
}